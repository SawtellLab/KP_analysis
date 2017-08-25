
exptname = '20170815_013';
load(['C:\Users\kperks\spikedata\matdata\' exptname '\' exptname '.mat'])
baselinewin = [1:20]; %[1400:1500];%
datamat = expt.wc.Vm - median(expt.wc.Vm(:,baselinewin),2);
% jxlspike = expt.wc.Vm(10,:) -  median(expt.wc.Vm(:,baselinewin),2);
latwin = [(stimonset_t-0.0005):0.0001:(stimonset_t+0.0005)];
baselinewin = [1:20]; %[1400:1500];%
spikeswin = [1: 0.01/expt.meta.dt];
nsweeps = size(datamat,1);
spikelatency = NaN(nsweeps,1);
for isweep = 1:nsweeps
    thisdata = datamat(isweep,:);
   findspk = find(expt.wc.Spikes(isweep,spikeswin));
   if ~isempty(findspk) %there was a spike on this trial
       spikelatency(isweep) =  (min(findspk) + spikeswin(1)) * expt.meta.dt *1000;
    end
end
edges = xtime;
njxl = histc(spikelatency,edges);

exptname = '20170815_009';
load(['C:\Users\kperks\spikedata\matdata\' exptname '\' exptname '.mat'])
baselinewin = [1:20]; %[1400:1500];%
a = filtesweeps(expt,0,'time',[582:0.0001:658]);
datamat = a.wc.Vm - median(a.wc.Vm(:,baselinewin),2);
nsweeps = size(datamat,1);
affavg = mean(datamat,1);
pad1 = zeros(1,round(0.0065/expt.meta.dt));
cutind = round(0.047/expt.meta.dt);
tmp = [pad1, affavg(cutind:end)];
pad2 = zeros(1,size(jxlspike,2)-size(tmp,2));
tmp = [tmp, pad2];
affavgoffset = tmp;
stimonset_t = 0.045;
stimonset_samp = round(stimonset_t/expt.meta.dt);
latwin = [(stimonset_t-0.0005):0.0001:(stimonset_t+0.0005)];
%  a = filtesweeps(expt,0,'latency',[0.04:0.0001:0.05],'time',[90:0.0001:139]);
artifactwin = [stimonset_samp: stimonset_samp + 35] ; %[1500:1535];%
baselinewin = [1:20]; %[1400:1500];%
spikeswin = [artifactwin(end):artifactwin(end) + 0.05/expt.meta.dt];
stimamp = NaN(nsweeps,1);
spikelatency = NaN(nsweeps,1);
for isweep = 1:nsweeps
    thisdata = datamat(isweep,:);
    stimamp(isweep) = max(thisdata(artifactwin)) - min(thisdata(artifactwin));
   findspk = find(a.wc.Spikes(isweep,spikeswin));
   if ~isempty(findspk) %there was a spike on this trial
       spikelatency(isweep) =  (min(findspk) + spikeswin(1)) * expt.meta.dt *1000;
    end
end
normlat = (spikelatency-45+4.5);
edges = xtime;
nlat = histc(normlat,edges);

exptname = '20170815_029';
load(['C:\Users\kperks\spikedata\matdata\' exptname '\' exptname '.mat'])
stimonset_t = 0.075;
stimonset_samp = round(stimonset_t/expt.meta.dt);
latwin = [(stimonset_t-0.0005):0.0001:(stimonset_t+0.0005)];
artifactwin = [stimonset_samp: stimonset_samp + 35] ; %[1500:1535];%
baselinewin = [1:20]; %[1400:1500];%
spikeswin = [artifactwin(end):artifactwin(end) + 0.05/expt.meta.dt];
a = filtesweeps(expt,0,'latency',latwin);
datamat = a.wc.Vm - median(a.wc.Vm(:,baselinewin),2);
eocd1 = datamat(50,:);

exptname = '20170815_029';
load(['C:\Users\kperks\spikedata\matdata\' exptname '\' exptname '.mat'])
stimonset_t = 0.075;
stimonset_samp = round(stimonset_t/expt.meta.dt);
latwin = [(stimonset_t-0.0005):0.0001:(stimonset_t+0.0005)];
artifactwin = [stimonset_samp: stimonset_samp + 35] ; %[1500:1535];%
baselinewin = [1:20]; %[1400:1500];%
spikeswin = [artifactwin(end):artifactwin(end) + 0.05/expt.meta.dt];
a = filtesweeps(expt,0,'latency',latwin,'time',[190:0.0001:260]);
datamat = a.wc.Vm - median(a.wc.Vm(:,baselinewin),2);
eocd2 = datamat(1,:);

exptname = '20170815_0056';
load(['C:\Users\kperks\spikedata\matdata\' exptname '\' exptname '.mat'])
stimonset_t = 0.045;
stimonset_samp = round(stimonset_t/expt.meta.dt);
latwin = [(stimonset_t-0.0005):0.0001:(stimonset_t+0.0005)];
artifactwin = [stimonset_samp: stimonset_samp + 35] ; %[1500:1535];%
baselinewin = [1:20]; %[1400:1500];%
spikeswin = [artifactwin(end):artifactwin(end) + 0.05/expt.meta.dt];
a = filtesweeps(expt,0,'latency',latwin,'time',[1:0.0001:113]);
datamat = a.wc.Vm - median(a.wc.Vm(:,baselinewin),2);
eocd3 = datamat(1,:);

exptname = '20170509_012';
load(['C:\Users\kperks\spikedata\matdata\' exptname '\' exptname '.mat'])
a = filtesweeps(expt,0,'time',[391:0.0001:399]);
stimonset_t = 0.0045;
stimonset_samp = round(stimonset_t/expt.meta.dt);
baselinewin = [1:20]; %[1400:1500];%
datamat = a.wc.Vm - median(a.wc.Vm(:,baselinewin),2);
grcEOCD1 = mean(datamat,1);

a = filtesweeps(expt,0,'global',0,'local',-60,'cmdtrig',1);
nsweeps = size(a.sweeps.trial,1);
bins = find(diff(a.sweeps.trial)>100);
bins = a.sweeps.trial(bins);
bins = [1;bins;nsweeps];
for ibin = 1:size(bins,1)-1
    binexpt = filtesweeps(a,0,'trial',[bins(ibin):bins(ibin+1)]);
    nsweeps = size(binexpt.sweeps.trial,1);
    figure;hold on
    for isweep = 1:nsweeps
        thisdata = binexpt.wc.Vm(isweep,:);
        stimdata = thisdata(stimonset_samp:stimonset_samp+600);
        line(xtime,thisdata+(binexpt.sweeps.position(isweep)*200),'color','k');
    end
    axis tight
    set(gca,'XLim',[(stimonset_t)*1000, (stimonset_t+0.04)*1000] )
end

exptname = '20170228_000';
load(['C:\Users\kperks\spikedata\matdata\' exptname '\' exptname '.mat'])
a = filtesweeps(expt,0,'time',[182:0.0001:182.25]);
baselinewin = [1:20]; %[1400:1500];%
datamat = a.wc.Vm - median(a.wc.Vm(:,baselinewin),2);
grcEOCD2 = mean(datamat,1);

xtime = [1:size(datamat,2)]*expt.meta.dt*1000;

datawin = round([1,40]/1000/expt.meta.dt);
figure;
hold on
% line(xtime,affavgoffset/abs(max(affavgoffset(datawin(1):datawin(2)))),'color','g')
stairs(xtime,nlat/max(nlat),'color','g','LineWidth',3)
line(xtime,grcEOCD1/abs(min(grcEOCD1(datawin(1):datawin(2)))),'color','k','LineWidth',3)
line(xtime,grcEOCD2/abs(max(grcEOCD2(datawin(1):datawin(2)))),'color','k','LineWidth',3)
% line(xtime,jxlspike/max(jxlspike(datawin(1):datawin(2))),'color','m','LineWidth',3)
stairs(xtime,njxl/max(njxl),'color','m','LineWidth',3)
line(xtime,eocd1/max(eocd1(datawin(1):datawin(2))),'color',[0.6,0.6,0.6],'LineWidth',3)
line(xtime,eocd2/max(eocd2(datawin(1):datawin(2))),'color',[0.6,0.6,0.6],'LineWidth',3)
line(xtime,eocd3/max(eocd3(datawin(1):datawin(2))),'color',[0.6,0.6,0.6],'LineWidth',3)



