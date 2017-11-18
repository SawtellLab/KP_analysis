naff = 3;

FSLmat = cell(naff,1);
POSmat = cell(naff,1);
CNTmat = cell(naff,1);
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
    end
    
    [x,i] = sort(thisexpt.sweeps.position);
    spikelatency = spikelatency(i);
    FSLmat{iname} = spikelatency - stimonset_t*1000 + 0.0045*1000;
    CNTmat{iname} = spikecount(i);
    POSmat{iname} = x;
    %    find(diff(spikelatency) == max(diff(spikelatency)))
end
%%

for iname = 1:size(newnames,1)
    figure;hold on
    scatter(POSmat{iname},FSLmat{iname})

set(gca,'YLim',[6,15])
set(gcf,'Position',[1300         203         503         740])
title(['global=' num2str(G) '; local=' num2str(L)])
end

%% Medium Fusiform
exptname ='20171102_000';
load(['C:\Users\kperks\spikedata\matdata\' exptname '\' exptname '.mat'])

timerange = [];%[753:0.0001:796];%[763.5:0.0001:815.72];%
Irange = []; %-47;

G = 450;%Globall(i); %
Obj = -20;%Objall(i); % 

  onsetind = [];
  peakval = [];
  
stimonset_t = 0.075;

stimonset_samp = round(stimonset_t/expt.meta.dt);
latwin = [(stimonset_t-0.0005):0.0001:(stimonset_t+0.0005)];
%  a = filtesweeps(expt,0,'latency',[0.04:0.0001:0.05],'time',[90:0.0001:139]);
artifactwin = [stimonset_samp: stimonset_samp + 35] ; %[1500:1535];%
baselinewin = [1:20]; %[1400:1500];%
spikeswin = [artifactwin(end):artifactwin(end) + 0.05/expt.meta.dt];

nsweeps = size(expt.wc.Vm,1);
nsamps = size(expt.wc.Vm,2);
% datamat = expt.wc.Vm;% - median(expt.wc.Vm(:,baselinewin),2);

plotwin =[artifactwin(end):artifactwin(end)+round(0.03/expt.meta.dt)];

a = filtesweeps(expt,0,'latency',latwin,'global',G,'local',Obj);
if ~isempty(timerange)
  a = filtesweeps(a,0,'time',timerange);
end
if ~isempty(Irange)
  a = filtesweeps(a,0,'current',Irange);
end
datamat = a.wc.Vm - median(a.wc.Vm(:,baselinewin),2);
nsweeps = size(a.wc.Vm,1);

xtime = [1:size(a.wc.Vm,2)]*expt.meta.dt*1000;
figure;line(xtime,datamat','color','k')

for i = 1:size(datamat,1)
    thisdata = datamat(i,plotwin);
  onsetind(i)= min(find(thisdata>1));
  peakval(i) = max(thisdata);
end

%%

figure;
scatter(a.sweeps.position,((artifactwin(end)+onsetind)*expt.meta.dt*1000)-(stimonset_t*1000))
ylabel('onset')

figure;
scatter(a.sweeps.position,peakval)
ylabel('peakval')

figure;hold on
for i = 1:size(datamat,1)
    
    scaley = 10;
    offset = (a.sweeps.position(i))*scaley;
   line(xtime(plotwin)+offset,datamat(i,plotwin),'color','k')
end

%%

G = 450;%Globall(i); %
Obj = -20;%Objall(i); % 

stimonset_t = 0.0045;

stimonset_samp = round(stimonset_t/expt.meta.dt);
latwin = [(stimonset_t-0.0005):0.0001:(stimonset_t+0.0005)];
%  a = filtesweeps(expt,0,'latency',[0.04:0.0001:0.05],'time',[90:0.0001:139]);
artifactwin = [stimonset_samp: stimonset_samp + 35] ; %[1500:1535];%
baselinewin = [1:20]; %[1400:1500];%
spikeswin = [artifactwin(end):artifactwin(end) + 0.05/expt.meta.dt];

nsamps = size(expt.wc.Vm,2);
% datamat = expt.wc.Vm;% - median(expt.wc.Vm(:,baselinewin),2);

Irange = [79]; %-47; 
a = filtesweeps(expt,0,'latency',latwin,'global',G,'local',Obj);
if ~isempty(timerange)
  a = filtesweeps(a,0,'time',timerange);
end
if ~isempty(Irange)
  a = filtesweeps(a,0,'current',Irange);
end
datamat = a.wc.Vm - median(a.wc.Vm(:,baselinewin),2);
nsweeps = size(a.wc.Vm,1);

xtime = [1:size(a.wc.Vm,2)]*expt.meta.dt*1000;
figure;line(xtime,datamat','color','k');

spikelatency = [];
 for isweep = 1:nsweeps
            findspk = find(a.wc.Spikes(isweep,spikeswin));
            if ~isempty(findspk) %there was a spike on this trial
                spikelatency(isweep) =  (min(findspk) + spikeswin(1)) * expt.meta.dt *1000;
            end
             if isempty(findspk) 
                 spikelatency(isweep) = stimonset_t * 1000;
             end
 end
 
 
figure;
scatter(a.sweeps.position,spikelatency)
ylabel('spike latency')