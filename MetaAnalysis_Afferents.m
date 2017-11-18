G = 450;
L = -20;

cd('C:\Users\kperks\spikedata\matdata\')
[num,txt,raw] = xlsread('C:\Users\kperks\scripts\SawtellLab\KP_analysis\MetaList_Afferents.xlsx',1);

headers = raw(1,:);

ind=find(ismember(headers,'name'));
names = raw(2:end,ind);
naff = size(names,1);

ind=find(ismember(headers,'longdelay'));
longdelay = cell2mat(raw(2:end,ind));

ind=find(ismember(headers,'zone'));
zone = (raw(2:end,ind));
includeaff = zeros(naff,1);
for i = 1:size(zone,1)
    if strcmp(zone{i},'mz')
        includeaff(i) = 1;
    end
end

names = names(find(includeaff));
longdelay = longdelay(find(includeaff));

baselinewin = [1:20];

FSLmat = cell(naff,1);
POSmat = cell(naff,1);
CNTmat = cell(naff,1);
meetsdemands = [];
for iname = 1:size(names,1)
    exptname = names{iname};
    load(['C:\Users\kperks\spikedata\matdata\' exptname '\' exptname '.mat'])
    
    stimonset_t = longdelay(iname);%0.045;
    stimonset_samp = round(stimonset_t/expt.meta.dt);
    latwin = [(stimonset_t-0.0005):0.0001:(stimonset_t+0.0005)];
    artifactwin = [stimonset_samp: stimonset_samp + 35] ;
    spikeswin = [artifactwin(end):artifactwin(end) + 0.05/expt.meta.dt];
    
    thisexpt = filtesweeps(expt,0,'global',G,'local',L);
    nsweeps = size(thisexpt.wc.Vm,1);
    
    spikelatency = NaN(nsweeps,1);
    spikecount = zeros(nsweeps,1);
    if nsweeps ~= 0
        meetsdemands(iname) = 1;
        for isweep = 1:nsweeps
            findspk = find(thisexpt.wc.Spikes(isweep,spikeswin));
            if ~isempty(findspk) %there was a spike on this trial
                spikelatency(isweep) =  (min(findspk) + spikeswin(1)) * thisexpt.meta.dt *1000;
                ispikes = size(findspk,2);
                if ispikes >1
                    spikecount(isweep) = size(findspk,2);
                end
                if ispikes == 1
                    if isempty(findspk)
                        spikecount(isweep) = 0;
                    end
                    if ~isempty(findspk)
                        spikecount(isweep) = 1;
                    end
                end
            end
        end
        if doplot ==1
            figure;
            hold on
            subplot(1,3,1); hold on
            scatter(spikelatency- stimonset_t*1000 + 0.0045*1000,thisexpt.sweeps.position)
            ylabel('position')
            xlabel('FSL msec')
            title(['global:' num2str(G) '; Obj:' num2str(L)])
            set(gca,'XLim',[(0.0045)*1000, (0.015)*1000] )

            subplot(1,3,2); hold on
            scatter(spikecount,thisexpt.sweeps.position)
            ylabel('position')
            xlabel('spike count')
            set(gca,'XTick',[1:max(spikecount)],'XLim',[0,max(spikecount)+1])
            set(gcf,'Position', [ 132         553        1440         420]); %[ 1275         553         297         420])
            title(['global:' num2str(G) '; L:' num2str(L)])
 
            subplot(1,3,3);
            hold on
            for isweep = 1:nsweeps
                thisdata = thisexpt.wc.Vm(isweep,:);
                findspk = find(thisexpt.wc.Spikes(isweep,:));
                stimdata = thisdata(stimonset_samp:stimonset_samp+600);
                line(xtime- stimonset_t*1000 + 0.0045*1000,thisdata+(thisexpt.sweeps.position(isweep)*50),'color','k');
            end
            axis tight
           set(gca,'XLim',[(0.0045)*1000, (0.015)*1000] )
        end
    end
    
    [x,i] = sort(thisexpt.sweeps.position);
    spikelatency = spikelatency(i);
    FSLmat{iname} = spikelatency - stimonset_t*1000 + 0.0045*1000;
    CNTmat{iname} = spikecount(i);
    POSmat{iname} = x;
    %    find(diff(spikelatency) == max(diff(spikelatency)))
end
%%
figure;hold on
for iname = 1:size(names,1)
    scatter(POSmat{iname},FSLmat{iname})
end
set(gca,'YLim',[6,15])
set(gcf,'Position',[1300         203         503         740])
title(['global=' num2str(G) '; local=' num2str(L)])

%%
dx = 0.02;
x = [2:dx:3.5];
pos = round([-0.25/dx:0.05/dx:0.25/dx]);

n = 3;
f = fit(POSmat{3},FSLmat{3},'gauss6');
% figure;plot(f,POSmat{3},FSLmat{3})
y3 = feval(f,x);
c = find(y3==min(y3));
latmat(1,:) = y3(c+pos);

n = 5;
f = fit(POSmat{5},FSLmat{5},'gauss6');
% figure;plot(f,POSmat{5},FSLmat{5})
y5 = feval(f,x);
c = find(y5==min(y5));
latmat(2,:) = y5(c+pos);

n = 6;
f = fit(POSmat{6},FSLmat{6},'gauss6');
% figure;plot(f,POSmat{6},FSLmat{6})
y6 = feval(f,x);
c = find(y6==min(y6));
latmat(3,:) = y6(c+pos);

n = 16;
f = fit(POSmat{n},FSLmat{n},'gauss6');
% figure;plot(f,POSmat{n},FSLmat{n})
y16 = feval(f,x);
c = find(y16==min(y16));
latmat(4,:) = y16(c+pos);

n = 17;
f = fit(POSmat{n},FSLmat{n},'gauss6');
% figure;plot(f,POSmat{n},FSLmat{n})
y17 = feval(f,x);
c = find(y17==min(y17));
latmat(5,:) = y17(c+pos);

figure;hold on
line(pos,latmat')


anal_pos = x(find(x == 2.5)+pos);
%%
figure;hold on
for iname = 1:size(names,1)
    scatter(POSmat{iname},CNTmat{iname})
    line(POSmat{iname},CNTmat{iname})
end
set(gca,'YLim',[0,5])
set(gcf,'Position',[1300         203         503         740])
title(['global=' num2str(G) '; local=' num2str(L)])
%%

figure;hold on
for iname = 1:size(names,1)
    line(FSLmat{iname},CNTmat{iname})
    scatter(FSLmat{iname},CNTmat{iname})
    %     line(POSmat{iname},CNTmat{iname})
end
axis tight
set(gca,'YTick',[0:4],'YLim',[0,4],'XLim',[5,14])
% set(gca,'YLim',[0,5])
% set(gcf,'Position',[1300         203         503         740])
title(['global=' num2str(G) '; local=' num2str(L)])