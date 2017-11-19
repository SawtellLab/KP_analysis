function varargout = AnalysisBrowser(varargin)
% ANALYSISBROWSER MATLAB code for AnalysisBrowser.fig
%      ANALYSISBROWSER, by itself, creates a new ANALYSISBROWSER or raises the existing
%      singleton*.
%
%      H = ANALYSISBROWSER returns the handle to a new ANALYSISBROWSER or the handle to
%      the existing singleton*.
%
%      ANALYSISBROWSER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ANALYSISBROWSER.M with the given input arguments.
%
%      ANALYSISBROWSER('Property','Value',...) creates a new ANALYSISBROWSER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before AnalysisBrowser_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AnalysisBrowser_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AnalysisBrowser

% Last Modified by GUIDE v2.5 18-Nov-2017 19:01:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AnalysisBrowser_OpeningFcn, ...
                   'gui_OutputFcn',  @AnalysisBrowser_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before AnalysisBrowser is made visible.
function AnalysisBrowser_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AnalysisBrowser (see VARARGIN)

% Choose default command line output for AnalysisBrowser
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes AnalysisBrowser wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = AnalysisBrowser_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function filepath_Callback(hObject, eventdata, handles)
% hObject    handle to filepath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.filepath = get(hObject,'String');
% Hints: get(hObject,'String') returns contents of filepath as text
%        str2double(get(hObject,'String')) returns contents of filepath as a double


% --- Executes during object creation, after setting all properties.
function filepath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filepath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function exptname_Callback(hObject, eventdata, handles)
% hObject    handle to exptname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.exptname = get(hObject,'String');
% Hints: get(hObject,'String') returns contents of exptname as text
%        str2double(get(hObject,'String')) returns contents of exptname as a double


% --- Executes during object creation, after setting all properties.
function exptname_CreateFcn(hObject, eventdata, handles)
% hObject    handle to exptname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in LoadData.
function LoadData_Callback(hObject, eventdata, handles)
% hObject    handle to LoadData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filepath = get(handles.filepath,'String');
exptname = get(handles.exptname,'String');
load([filepath exptname '/' exptname '.mat'])

handles.allsweeps = expt.wc.Vm;
handles.dt = expt.meta.dt;

alldata = [];
allcommand = [];
alldac0 = [];

triallen = size(expt.wc.Vm,2);

for i = 1:size(expt.sweeps.time,1)
    alldata = [alldata,expt.wc.Vm(i,:)];
    allcommand = [allcommand,expt.wc.command(i,:)];
    alldac0 = [alldac0,expt.wc.dac0(i,:)];
end

xtime = [1:size(alldata,2)]/triallen;

axes(handles.Vm)
line(xtime,alldata)

axes(handles.command)
line(xtime,allcommand)

axes(handles.dac0)
line(xtime,alldac0)

axes(handles.stimonset)
scatter(expt.sweeps.trial,expt.sweeps.latency)

axes(handles.current)
scatter(expt.sweeps.trial,expt.sweeps.current)

xtime = [1:size(expt.wc.Vm,2)]*expt.meta.dt;
axes(handles.this_sweep)
line(xtime,expt.wc.Vm(1,:));


% --- Executes on button press in SaveNewFiltered.
function SaveNewFiltered_Callback(hObject, eventdata, handles)
% hObject    handle to SaveNewFiltered (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filepath = get(handles.filepath,'String');
exptname = get(handles.exptname,'String');
load([filepath exptname '/' exptname '.mat'])

filterfield = 'trial';
s = ['thisexpt = filtesweeps(' expt ',0',filterfield ',' trialrangestr ');'];
eval(s)
save(thisexpt,[filepath exptname '/' exptname '_filtered.mat'])


function trialrange_Callback(hObject, eventdata, handles)
% hObject    handle to trialrange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
trialrangestr = get(hObject,'String');

filepath = get(handles.filepath,'String');
exptname = get(handles.exptname,'String');
load([filepath exptname '/' exptname '.mat'])

filterfield = 'trial';
s = ['thisexpt = filtesweeps(expt,0,filterfield,' trialrangestr ');'];
eval(s)
savestr = [filepath expt.name '/' expt.name '_filtered.mat'];
save(savestr,'thisexpt')

% Hints: get(hObject,'String') returns contents of trialrange as text
%        str2double(get(hObject,'String')) returns contents of trialrange as a double


% --- Executes during object creation, after setting all properties.
function trialrange_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trialrange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sweep_Callback(hObject, eventdata, handles)
% hObject    handle to sweep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
sweepstr = get(hObject,'string');
isweep = str2num(sweepstr);
set(handles.SweepsSlider,'Value',isweep);

filepath = get(handles.filepath,'String');
exptname = get(handles.exptname,'String');
load([filepath exptname '/' exptname '.mat'])

allsweeps = expt.wc.Vm; %get(handles.allsweeps,'Value');
dt = expt.meta.dt; %handles.dt;
xtime = [1:size(allsweeps,2)]*dt;

axes(handles.this_sweep)
cla reset
ymin = str2num(get(handles.ymin,'String'));
ymax = str2num(get(handles.ymax,'String'));
set(gca,'YLim',[ymin,ymax])
line(xtime,allsweeps(isweep,:));
% Hints: get(hObject,'String') returns contents of sweep as text
%        str2double(get(hObject,'String')) returns contents of sweep as a double


% --- Executes during object creation, after setting all properties.
function sweep_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sweep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function SweepsSlider_Callback(hObject, eventdata, handles)
% hObject    handle to SweepsSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
isweep = get(hObject,'Value');
isweep = round(isweep);
set(handles.sweep,'String',num2str(isweep));

filepath = get(handles.filepath,'String');
exptname = get(handles.exptname,'String');
load([filepath exptname '/' exptname '.mat'])

nsweeps = size(expt.wc.Vm,1);
set(hObject,'Max',nsweeps);
set(hObject, 'SliderStep', [1/nsweeps , 10/nsweeps ]);

allsweeps = expt.wc.Vm; %get(handles.allsweeps,'Value');
dt = expt.meta.dt; %handles.dt;
xtime = [1:size(allsweeps,2)]*dt;

axes(handles.this_sweep)
cla reset
ymin = str2num(get(handles.ymin,'String'));
ymax = str2num(get(handles.ymax,'String'));
set(gca,'YLim',[ymin,ymax])
line(xtime,allsweeps(isweep,:));
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function SweepsSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SweepsSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function ymax_Callback(hObject, eventdata, handles)
% hObject    handle to ymax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.this_sweep)
ylims = get(gca,'YLim');
ymax = get(hObject,'String');
ymax = str2num(ymax);
ylims(2) = ymax;
set(gca,'YLim',ylims);
handles.ylims = ylims;
set(hObject,'String',num2str(ymax))
% Hints: get(hObject,'String') returns contents of ymax as text
%        str2double(get(hObject,'String')) returns contents of ymax as a double


% --- Executes during object creation, after setting all properties.
function ymax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ymax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ymin_Callback(hObject, eventdata, handles)
% hObject    handle to ymin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.this_sweep)
ylims = get(gca,'YLim');
ymin = get(hObject,'String');
ymin = str2num(ymin);
ylims(1) = ymin;
set(gca,'YLim',ylims);
handles.ylims = ylims;
set(hObject,'String',num2str(ymin))
% Hints: get(hObject,'String') returns contents of ymin as text
%        str2double(get(hObject,'String')) returns contents of ymin as a double


% --- Executes during object creation, after setting all properties.
function ymin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ymin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
