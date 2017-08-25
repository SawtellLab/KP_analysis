
Iinject = 0;

Gepsp = 0;
Gipsp = 0;
Gleak = 1;
Gtotal = Gepsp + Gipsp + Gleak;

Eepsp = 10;
Eipsp = -80;
Eleak = -70;

Enet = -[-[Gleak/Gtotal * Eleak] - [Gipsp/Gtotal * Eipsp] - [Gepsp/Gtotal * Eepsp]];
dV = Iinject * 1/Gtotal;

x = [1:30];
hfig = figure;
hold on
set(gca,'YLim',[-90,-30]);
y = nan(30,1);
y(1:10) = Enet;
y(11:20) = Enet+dV;
y(21:30) = Enet;
h = scatter(x,y,200,'k','fill');
% set(h,'XDataSource','x');
set(h,'YDataSource','y');

%%
inject_current = 1;
Iinject = 5;
Ginject = 1;
Einject = -10;

doDiff = 0;

Gepsp = 0.5;
Gipsp = 0;
Gleak = 1;
Gtotal = Gepsp + Gipsp + Gleak;

Eepsp = -10;
Eipsp = -80;
Eleak = -70;

% y = -[Gleak * (Vm - Eleak)] - [Gipsp * (Vm - Eipsp)] - [Gepsp * (Vm - Eepsp)] ;

Enet = -[-[Gleak/Gtotal * Eleak] - [Gipsp/Gtotal * Eipsp] - [Gepsp/Gtotal * Eepsp]];
if inject_current ==1
dV = Iinject * 1/Gtotal;
else
    Gnetstep = Gtotal + Ginject;
dV = -[Ginject/Gnetstep * Einject];    
end

y = nan(30,1);
if doDiff ==1
y(1:10) = Enet-Enet;
y(11:20) = Enet+dV-Enet;
y(21:30) = Enet-Enet;
set(gca,'YLim',[-20,30]);
else
        y(1:10) = Enet;
y(11:20) = Enet+dV;
y(21:30) = Enet;
set(gca,'YLim',[-90,-10]);
end
% y = Vm - [Gtotal * (Vm - Enet)];
refreshdata

