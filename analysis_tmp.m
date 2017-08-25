exptname = '20170824_007';

load(['C:\Users\kperks\spikedata\matdata\' exptname '\' exptname '.mat'])
%%
expt = ImportExpt_Spike7('C:\Users\kperks\spikedata\matdata\',exptname,0.16)
%%
stimonset_t = 0.075;
stimonset_samp = round(stimonset_t/expt.meta.dt);
latwin = [(stimonset_t-0.0005):0.0001:(stimonset_t+0.0005)];
%  a = filtesweeps(expt,0,'latency',[0.04:0.0001:0.05],'time',[90:0.0001:139]);
artifactwin = [stimonset_samp: stimonset_samp + 35] ; %[1500:1535];%
baselinewin = [1:20]; %[1400:1500];%
spikeswin = [artifactwin(end):artifactwin(end) + 0.05/expt.meta.dt];

nsweeps = size(expt.wc.Vm,1);

datamat = expt.wc.Vm - median(expt.wc.Vm(:,baselinewin),2);
xtime = [1:size(datamat,2)]*expt.meta.dt*1000;
% figure;plot(xtime,datamat')

%%
a = filtesweeps(expt,0,'latency',latwin,'time',[190:0.0001:260]);
datamat = a.wc.Vm - median(a.wc.Vm(:,baselinewin),2);
figure;plot(xtime,datamat(1,:)')
%% spikes with change in object position
% for i = 1:size(Objall,1)
% close all
G = 500;%Globall(i); %
Obj = -30;%Objall(i); %

a = filtesweeps(expt,0,'latency',latwin,'global',G,'local',Obj);
% a = filtesweeps(expt,0,'latency',latwin);
datamat = a.wc.Vm - median(a.wc.Vm(:,baselinewin),2);
nsweeps = size(a.wc.Vm,1);

spikelatency = NaN(nsweeps,1);
spikecount = zeros(nsweeps,1);
for isweep = 1:nsweeps
    thisdata = datamat(isweep,:);

   findspk = find(a.wc.Spikes(isweep,spikeswin));
   if ~isempty(findspk) %there was a spike on this trial
      
       spikelatency(isweep) =  (min(findspk) + spikeswin(1)) * expt.meta.dt *1000;
         spikecount(isweep) = size(findspk,2);
    end
end
%%
figure;
hold on
subplot(1,3,1); hold on
scatter(spikelatency- stimonset_t*1000 + 0.0045*1000,a.sweeps.position)
ylabel('position')
xlabel('FSL msec')
title(['global:' num2str(G) '; Obj:' num2str(Obj)])
% set(gca,'XLim',[(stimonset_t+0.002)*1000, (stimonset_t+0.008)*1000] )
set(gca,'XLim',[(0.0045)*1000, (0.015)*1000] )

% set(gca,'XLim',[77,83])
subplot(1,3,2); hold on
scatter(spikecount,a.sweeps.position)
ylabel('position')
xlabel('spike count')
set(gca,'XTick',[1:max(spikecount)],'XLim',[0,max(spikecount)+1])
set(gcf,'Position', [ 132         553        1440         420]); %[ 1275         553         297         420])
title(['global:' num2str(G) '; Obj:' num2str(Obj)])
% figure;scatter(spikecount,spikelatency)
% xlabel('spike count')
% ylabel('FSL msec')


 subplot(1,3,3);
% figure;
hold on
for isweep = 1:nsweeps
    thisdata = datamat(isweep,:);

   findspk = find(a.wc.Spikes(isweep,:));
%     if isempty(findspk)
       stimdata = thisdata(stimonset_samp:stimonset_samp+600);
         line(xtime- stimonset_t*1000 + 0.0045*1000,thisdata+(a.sweeps.position(isweep)*50),'color','k');
%    end
end
axis tight
% set(gca,'XLim',[(stimonset_t+0.002)*1000, (stimonset_t+0.008)*1000] )
set(gca,'XLim',[(0.0045)*1000, (0.015)*1000] )
% end
%% spikes with graded global
a = filtesweeps(expt,0,'latency',latwin,'time', [600:0.001: 780]);%]); 

nsweeps = size(a.wc.Vm,1);

datamat = a.wc.Vm - median(a.wc.Vm(:,baselinewin),2);
xtime = [1:size(datamat,2)]*expt.meta.dt*1000;

stimamp = NaN(nsweeps,1);
spikelatency = NaN(nsweeps,1);
spikecount = NaN(nsweeps,1);
for isweep = 1:nsweeps
    thisdata = datamat(isweep,:);
    
    stimamp(isweep) = max(thisdata(artifactwin)) - min(thisdata(artifactwin));

   findspk = find(a.wc.Spikes(isweep,spikeswin));
   if ~isempty(findspk) %there was a spike on this trial
      
       spikelatency(isweep) =  (min(findspk) + spikeswin(1)) * expt.meta.dt *1000;
         spikecount(isweep) = size(findspk,2);
    end
end

figure;scatter(spikelatency,stimamp)
ylabel('artifact')
xlabel('FSL msec')
axis tight
% set(gca,'XLim',[77,83])
set(gca,'XLim',[(stimonset_t+0.002)*1000, (stimonset_t+0.008)*1000] )

figure;scatter(spikecount,stimamp)
ylabel('artifact')
xlabel('spike count')
axis tight
set(gca,'XTick',[1:max(spikecount)],'XLim',[0,max(spikecount)+1])
set(gcf,'Position', [ 1275         553         297         420])


figure;hold on
for isweep = 1:nsweeps
    thisdata = datamat(isweep,:);
    
    stimamp(isweep) = max(thisdata(artifactwin)) - min(thisdata(artifactwin));

   findspk = find(a.wc.Spikes(isweep,:));
%     if isempty(findspk)
       stimdata = thisdata(artifactwin(end):artifactwin(end)+600);
         line(xtime,thisdata+(stimamp(isweep)*5),'color','k');
%    end
end
axis tight

figure;hold on
for isweep = 1:nsweeps
    thisdata = datamat(isweep,:);
    
    stimamp(isweep) = max(thisdata(artifactwin)) - min(thisdata(artifactwin));

   findspk = find(a.wc.Spikes(isweep,:));
    if isempty(findspk)
       stimdata = thisdata(artifactwin(end):artifactwin(end)+600);
         line(xtime,thisdata+(stimamp(isweep)*5),'color','k');
   end
end
axis tight

figure;line(xtime,datamat')
% figure;scatter(spikecount,spikelatency)
% xlabel('spike count')
% ylabel('FSL msec')

%%
% figure;hold on
stimamp = nan(nsweeps,1);
peakval = nan(nsweeps,1);
peaklat = nan(nsweeps,1);
onsetlat= nan(nsweeps,1);
dvdt = nan(nsweeps,1);
halfwidth = nan(nsweeps,1);
for isweep = 1:nsweeps
    thisdata = datamat(isweep,:);
    
    stimamp(isweep) = max(thisdata(artifactwin)) - min(thisdata(artifactwin));

   findspk = find(a.wc.Spikes(isweep,:));
   if isempty(findspk)
       stimdata = thisdata(artifactwin(end):artifactwin(end)+600);
       searchind = find(stimdata == max(stimdata));
       peakval(isweep) = max(stimdata);
       peaklat(isweep) = searchind;
       onsetlat(isweep) = max(find(stimdata ==min(stimdata(1:searchind))));
       dvdt(isweep) = (peakval(isweep) - stimdata(onsetlat(isweep)))/(peaklat(isweep) - onsetlat(isweep))*expt.meta.dt;
       halfheight = stimdata(peaklat(isweep)) - (stimdata(peaklat(isweep))-stimdata(onsetlat(isweep)))/2; 
       halfwidth(isweep) = (max(find(stimdata<halfheight)) - min(find(stimdata>halfheight)))*expt.meta.dt*1000;
       %    line(xtime,thisdata+(stimamp(isweep)*2),'color','k');
   end
end
peaklat = (peaklat+(artifactwin(end)-artifactwin(1)))*expt.meta.dt*1000;
onsetlat = (onsetlat+(artifactwin(end)-artifactwin(1)))*expt.meta.dt*1000;

figure;hold on
for isweep = 1:nsweeps
    thisdata = datamat(isweep,:);
    
    stimamp(isweep) = max(thisdata(artifactwin)) - min(thisdata(artifactwin));

   findspk = find(a.wc.Spikes(isweep,:));
%    if isempty(findspk)
       stimdata = thisdata(artifactwin(end):artifactwin(end)+600);
         line(xtime,thisdata+(stimamp(isweep)*5),'color','k');
%    end
end
axis tight

figure;
line(xtime,(datamat'))

nospkind = ~isnan(onsetlat);
figure;
scatter(stimamp(nospkind),onsetlat(nospkind))
ylabel('onset latency msec')

figure;
scatter(stimamp(nospkind),halfwidth(nospkind))
ylabel('width at halfheight msec')

figure;
scatter(stimamp(nospkind),peaklat(nospkind))
ylabel('peak latency msec')

figure;
scatter(onsetlat(nospkind),peaklat(nospkind))
ylabel('peak latency msec');xlabel('onset latency')

figure;
scatter(stimamp(nospkind),peakval(nospkind))
ylabel('peak value mV')

figure;
scatter(stimamp(nospkind),dvdt(nospkind))
ylabel('dvdt mV/ms')
%%


figure;hold on
for isweep = 1:nsweeps
    thisdata = datamat(isweep,:);
    
    stimamp(isweep) = max(thisdata(artifactwin)) - min(thisdata(artifactwin));

   findspk = find(a.wc.Spikes(isweep,:));
%     if isempty(findspk)
       stimdata = thisdata(artifactwin(end):artifactwin(end)+600);
         line(xtime,thisdata+(stimamp(isweep)*5),'color','k');
%    end
end
axis tight
%%
a = filtesweeps(expt,0,'time', [146.52:0.001: 158.61]);%]); 
b = filtesweeps(expt,0,'time', [161.47:0.001: 178.87]);%]); 
c = filtesweeps(expt,0,'time', [180.17:0.001: 198.15]);%]); 
d = filtesweeps(expt,0,'time', [200.89:0.001: 238.83]);%]); 

nsweeps = size(a.wc.Vm,1);

datamatA = a.wc.Vm - median(a.wc.Vm(:,baselinewin),2);
xtime = [1:size(datamatA,2)]*expt.meta.dt*1000;
datamatB = b.wc.Vm - median(b.wc.Vm(:,baselinewin),2);
datamatC = c.wc.Vm - median(c.wc.Vm(:,baselinewin),2);
datamatD = d.wc.Vm - median(d.wc.Vm(:,baselinewin),2);

figure;hold on
line(xtime,datamatA','color','k')
line(xtime,datamatB','color','k')
axis tight
set(gca,'YLim',[-5,50])
title('SD')

figure;hold on
line(xtime,datamatC','color','k')
line(xtime,datamatD','color','k')
axis tight
title('LD')
set(gca,'YLim',[-5,50])

a = filtesweeps(expt,0,'time', [325.01:0.001: 337.76]);%]); 
datamatA = a.wc.Vm - median(a.wc.Vm(:,baselinewin),2);
b = filtesweeps(expt,0,'time', [343.17:0.001: 372.87]);%]); 
datamatB = b.wc.Vm - median(b.wc.Vm(:,baselinewin),2);
figure;hold on
line(xtime,datamatA','color','k')
line(xtime,datamatB','color','k')
axis tight
set(gca,'YLim',[-5,50])
title('SD not hyperpol')
% 325.01	337.76
% 343.17	372.87

a = filtesweeps(expt,0,'time', [384.69:0.001: 418.96]);%]); 
datamatA = a.wc.Vm - median(a.wc.Vm(:,baselinewin),2);
b = filtesweeps(expt,0,'time', [422.31:0.001: 469.63]);%]); 
datamatB = b.wc.Vm - median(b.wc.Vm(:,baselinewin),2);
figure;hold on
line(xtime,datamatA','color','k')
line(xtime,datamatB','color','k')
axis tight
set(gca,'YLim',[-5,50])
title('SD hyperpol again and 30um?')
% 384.69	418.96
% 422.31	469.63




% 
% figure;hold on
% for isweep = 1:nsweeps
%     thisdata = datamat(isweep,:);
%     
%    
%        stimdata = thisdata(artifactwin(end):artifactwin(end)+600);
%          line(xtime,thisdata+(a.sweeps.position(isweep)*100),'color','k');
% end
%%
figure;hold on
for isweep = 1:nsweeps
    thisdata = datamat(isweep,:);
    
    stimamp(isweep) = max(thisdata(artifactwin)) - min(thisdata(artifactwin));

       stimdata = thisdata(artifactwin(end):artifactwin(end)+600);
         line(xtime,thisdata+(stimamp(isweep)*5),'color','k');

end
axis tight

figure;line(xtime,datamat')
% figure;scatter(spikecount,spikelatency)
% xlabel('spike count')
% ylabel('FSL msec')

