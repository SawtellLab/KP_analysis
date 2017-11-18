%%
exptname = '20171027_000';
expt = ImportExpt_Spike7('C:\Users\kperks\spikedata\matdata\',exptname,0.16,1)
%%
exptname ='20171102_000';
load(['C:\Users\kperks\spikedata\matdata\' exptname '\' exptname '.mat'])
%% import _Istep mat file exported from Spike to analyze negative current pulses for Rin, Tau and Cap
sweeps_dur = 0.3;

exptdir = 'C:\Users\kperks\spikedata\matdata\';
exptfoldername =[exptname];
exptfoldername = [exptfoldername '\'];
% expt.name = exptfoldername(1:end-1);
cd([exptdir exptfoldername(1:end-1)])
load([exptfoldername(1:end-1) '_Istep.mat']);


rate = round(1/lowgain.interval);
dt = lowgain.interval;


sweeps_samps = sweeps_dur * rate;

%%%%%%%%%%%%%%%%%%
% event channels
sweeps_trig = find(trigevt.values);
nsweeps = size(sweeps_trig,1);

SweepsMat = MakeSweeps(lowgain.values',sweeps_trig,sweeps_samps);
Vm = SweepsMat;
Vstep = median(Vm);

SweepsMat = MakeSweeps(current.values',sweeps_trig,sweeps_samps);
% expt.wc.I = SweepsMat;
Istep = mean(SweepsMat,1);
deltaI = round(median(Istep(1200:4000)) - median(Istep(1:1000)));

startt = 0.05 /dt;
stopt = startt + 0.1/dt;
stepresponse = median(Vm(:,startt:stopt),1);
stepresponse = stepresponse - min(stepresponse);
% stepresponse = stepresponse / max(stepresponse);
xt = ([startt:stopt]-startt)*dt;
f = fit(xt',stepresponse','exp2');
y = feval(f,xt);
figure;
hold on
line(xt,stepresponse,'color','k','LineWidth',3)
line(xt,y,'color','r','LineWidth',3)

y1 = f.a*exp(f.b*xt);
line(xt,y1 + y(1)-y1(1),'color','m','LineWidth',3)
y2 = f.c*exp(f.d*xt);
line(xt,y2 + y(1)-y2(1),'color','c','LineWidth',3)

% (min(y2)-max(y2))/deltaI
% (min(y1)-max(y1))/deltaI

taus = [f.b,f.d];
scales = [f.a,f.c];
tau_grc = min(taus);
ind = find(taus == min(taus));
y_anal = scales(ind)*exp(taus(ind)*xt);
r = (min(y_anal) - max(y_anal))*1000/deltaI;

%%

timerange = [];%[763.5:0.0001:815.72];%
Irange = []; %-47;

G = 450;%Globall(i); %
Obj = 20;%Objall(i); % 

stimonset_t = 0.0045;

stimonset_samp = round(stimonset_t/expt.meta.dt);
latwin = [(stimonset_t-0.0005):0.0001:(stimonset_t+0.0005)];
%  a = filtesweeps(expt,0,'latency',[0.04:0.0001:0.05],'time',[90:0.0001:139]);
artifactwin = [stimonset_samp: stimonset_samp + 35] ; %[1500:1535];%
baselinewin = [1:20]; %[1400:1500];%
spikeswin = [artifactwin(end):artifactwin(end) + 0.05/expt.meta.dt];

nsweeps = size(expt.wc.Vm,1);
nsamps = size(expt.wc.Vm,2);
% datamat = expt.wc.Vm;% - median(expt.wc.Vm(:,baselinewin),2);


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

%%
plotwin =[artifactwin(end):artifactwin(end)+round(0.05/expt.meta.dt)];
figure;hold on
for i = 1:size(datamat,1)
    
    scaley = 10;
    offset = (a.sweeps.position(i))*scaley;
   line(xtime(plotwin)+offset,datamat(i,plotwin),'color','k')
end
%% linear sum global on cmd
datamat = a.wc.Vm - median(a.wc.Vm(:,baselinewin),2);

sumonset_t = 0.0045;
sumonset_samp = round(sumonset_t/expt.meta.dt);

g = datamat(:,stimonset_samp:end);
pad_on = zeros(nsweeps,sumonset_samp-1);
pad_off = zeros(nsweeps,nsamps - (size(pad_on,2)+size(g,2)));

addon = ([pad_on,g,pad_off]);

figure;line(xtime,(datamat + addon)','color','k')

linearsum = datamat+addon;
%%
grcsum = a.wc.Vm - median(a.wc.Vm(:,baselinewin),2);
figure;line(xtime,grcsum','color','k');
figure;line(xtime,(mean(grcsum,1) - mean(linearsum,1))');
%%
figure;
line(xtime,datamat','color','k')
title(['global:' num2str(G) '; Obj:' num2str(Obj)])

peakval = NaN(nsweeps,1);
peaktime = NaN(nsweeps,1);
for isweep = 1:nsweeps
    thisdata = datamat(isweep,:);
    
    peakval(isweep) =  max(thisdata(:,artifactwin(end):end));
    peaktime(isweep) = min(find(thisdata == peakval(isweep))) * expt.meta.dt *1000;
end

[i,x] = sort(a.sweeps.position);
figure;imagesc(i,xtime,datamat(x,:)')
[gradI,im] = colorGradient([0 0 1],[1 1 1],100);
[gradE,im] = colorGradient([1 1 1],[1 0 0],100);
grad = [gradI;gradE];
colormap(grad)
caxis([-1,1])
colorbar
title(['global:' num2str(G) '; Obj:' num2str(Obj)])

%% lfp bin by position, avergage and plot by color
centers = [2:0.1:3];
step = 0.2;
posbin = [];
for i = 1:size(centers,2)
posbin(i,:) = [centers(i)-step:0.001:centers(i)+step];
end

figure;hold on
for i = 1:size(centers,2)
    t = filtesweeps(a,0,'position',posbin(i,:));
 
    line(xtime,mean(t.wc.Vm)+centers(i)*2);
%     set(gca,'YLim',[-6,-4],'XLim',[76,90])
%     title(['position' num2str(centers(i))])
end
%%
figure;scatter(a.sweeps.position,peakval)
xlabel('position')
ylabel('peak val')
title(['global:' num2str(G) '; Obj:' num2str(Obj)])

figure;scatter(a.sweeps.position,peaktime)
xlabel('position')
ylabel('peak time')
title(['global:' num2str(G) '; Obj:' num2str(Obj)])

%%
G = 450;%Globall(i); %
Obj = 30;%Objall(i); %
stimonset_t = 0.0045;

stimonset_samp = round(stimonset_t/expt.meta.dt);
latwin = [(stimonset_t-0.0005):0.0001:(stimonset_t+0.0005)];
artifactwin = [stimonset_samp: stimonset_samp + 35] ; %[1500:1535];%
baselinewin = [1:20]; %[1400:1500];%
spikeswin = [artifactwin(end):artifactwin(end) + 0.05/expt.meta.dt];



a = filtesweeps(expt,0,'latency',latwin,'global',G,'local',Obj);
% a = filtesweeps(expt,0,'latency',latwin);
datamat = a.wc.Vm - median(a.wc.Vm(:,baselinewin),2);
nsweeps = size(a.wc.Vm,1);

figure;
line(xtime,datamat','color','k')
title(['global:' num2str(G) '; Obj:' num2str(Obj)])

peakval = NaN(nsweeps,1);
peaktime = NaN(nsweeps,1);
for isweep = 1:nsweeps
    thisdata = datamat(isweep,:);
    
    peakval(isweep) =  max(thisdata(:,artifactwin(end):end));
    peaktime(isweep) = min(find(thisdata == peakval(isweep))) * expt.meta.dt *1000;
end

figure;scatter(a.sweeps.position,peakval)
xlabel('position')
ylabel('peak val')
title(['global:' num2str(G) '; Obj:' num2str(Obj)])

figure;scatter(a.sweeps.position,peaktime)
xlabel('position')
ylabel('peak time')
title(['global:' num2str(G) '; Obj:' num2str(Obj)])
%%
stimonset_t = 0.0045;
stimonset_samp = round(stimonset_t/expt.meta.dt);
latwin = [(stimonset_t-0.0005):0.0001:(stimonset_t+0.0005)];
%  a = filtesweeps(expt,0,'latency',[0.04:0.0001:0.05],'time',[90:0.0001:139]);
artifactwin = [stimonset_samp: stimonset_samp + 35] ; %[1500:1535];%
baselinewin = [1:20]; %[1400:1500];%
spikeswin = [artifactwin(end):artifactwin(end) + 0.05/expt.meta.dt];

nsweeps = size(expt.wc.Vm,1);

datamat = expt.wc.Vm - median(expt.wc.Vm(:,baselinewin),2);
xtime = [1:size(datamat,2)]*expt.meta.dt*1000;

G = 450;%Globall(i); %
Obj = 30;%Objall(i); %

a = filtesweeps(expt,0,'latency',latwin,'global',G,'local',Obj);
% a = filtesweeps(expt,0,'latency',latwin);
datamat = a.wc.Vm - median(a.wc.Vm(:,baselinewin),2);
nsweeps = size(a.wc.Vm,1);

figure;
line(xtime,datamat')


%% psp inject

timerange = [1683:0.00001:1747];
Irange = []; %-47;
stimonset_t = []; %0.0045;

latwin = [];
if ~isempty(stimonset_t);
stimonset_samp = round(stimonset_t  /expt.meta.dt);
latwin = [(stimonset_t-0.0005):0.0001:(stimonset_t+0.0005)];
artifactwin = [stimonset_samp: stimonset_samp + 35] ; %[1500:1535];%
baselinewin = [1:20]; %[1400:1500];%
spikeswin = [artifactwin(end):artifactwin(end) + 0.05/expt.meta.dt];
end

xtime = [1:size(expt.wc.Vm,2)]*expt.meta.dt*1000;

if ~isempty(latwin)
a = filtesweeps(expt,0,'latency',latwin);
end
if ~isempty(timerange)
  a = filtesweeps(expt,0,'time',timerange);
end
if ~isempty(Irange)
  a = filtesweeps(expt,0,'current',Irange);
end

datamat = a.wc.Vm - median(a.wc.Vm(:,baselinewin),2);
nsweeps = size(a.wc.Vm,1);
nsamps = size(a.wc.Vm,2);

% figure;line(xtime,datamat(:,:)','color','k')

t = (sum(a.wc.dac1,2));
edges = [floor(min(t)):0.1:ceil(max(t))];
x = histc(t,edges);
figure;
stairs(edges,x);
ind = find(t>500);

onset_t = [7,8,9,10,11,12,15];
thisdata = datamat(ind,:);
pspwavs = a.wc.dac1(ind,:);
psponset = zeros(size(thisdata,1),1);
for isweep = 1:size(thisdata,1)
    if ~isempty(find(pspwavs(isweep,:)>1))
    psponset(isweep) = 1000*expt.meta.dt*min(find(pspwavs(isweep,:)>1));  
    end
end

%%%%% build mat of grc sum at each latency
grcsum_mat = [];
for t = 1:size(onset_t,2)
    thislat = [];
    for isweep = 1:size(thisdata,1)
        if onset_t(t)-0.5<psponset(isweep) && psponset(isweep)<onset_t(t)+0.5
            thislat = [thislat; thisdata(isweep,:)];
        end
    end
    grcsum_mat{t} = thislat;
end

%%%%% build mat of linear sum at each latency
linearsum_mat = [];
longdelay = 75; %msec
ld_mat = [];
for isweep = 1:size(thisdata,1)
        if longdelay-0.5<psponset(isweep) && psponset(isweep)<longdelay+0.5
            ld_mat = [ld_mat; thisdata(isweep,:)];
        end
end
nsweeps = size(ld_mat,1);
for t = 1:size(onset_t,2)
sumonset_t = onset_t(t)/1000;
sumonset_samp = round(sumonset_t/expt.meta.dt);
ldonset_samp = round(longdelay/1000/expt.meta.dt);
g = ld_mat(:,ldonset_samp:end);
pad_on = zeros(nsweeps,sumonset_samp-1);
pad_off = zeros(nsweeps,nsamps - (size(pad_on,2)+size(g,2)));

addon = ([pad_on,g,pad_off]);
linearsum_mat{t} = ld_mat+addon;
end

errorsum = [];
for t = 1:size(onset_t,2)
    errorsum(t,:) = mean(grcsum_mat{t},1) - mean(linearsum_mat{t},1);
    figure;hold on
    line(xtime,mean(grcsum_mat{t},1)','color','k')
    line(xtime,mean(linearsum_mat{t},1)','color','r')
end
figure;line(xtime,errorsum','color','k')

figure;hold on
for t = 1:size(onset_t,2)
    line(xtime,(grcsum_mat{t})','color','k')
end
figure;line(xtime,datamat(ind,:)','color','k')
figure;line(xtime,a.wc.dac1(ind,:)','color','k')