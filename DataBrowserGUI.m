function varargout = DataBrowserGUI(varargin)
% DATABROWSER MATLAB code for DataBrowser.fig
%      DATABROWSER, by itself, creates a new DATABROWSER or raises the existing
%      singleton*.
%
%      H = DATABROWSER returns the handle to a new DATABROWSER or the handle to
%      the existing singleton*.
%
%      DATABROWSER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DATABROWSER.M with the given input arguments.
%
%      DATABROWSER('Property','Value',...) creates a new DATABROWSER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DataBrowser_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DataBrowser_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DataBrowser

% Last Modified by GUIDE v2.5 18-Nov-2017 13:41:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DataBrowserGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @DataBrowserGUI_OutputFcn, ...
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

% --- Executes just before DataBrowser is made visible.
function DataBrowser_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DataBrowser (see VARARGIN)

% Choose default command line output for DataBrowser
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DataBrowser wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DataBrowser_OutputFcn(hObject, eventdata, handles) 
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

% --- Executes on button press in LOAD.
function LOAD_Callback(hObject, eventdata, handles)
% hObject    handle to LOAD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filepath = get(handles.filepath,'String');
exptname = get(handles.exptname,'String');
load([filepath exptname '/' exptname '.mat'])

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


% --- Executes on button press in filterNew.
function filterNew_Callback(hObject, eventdata, handles)
% hObject    handle to filterNew (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function sweepnum_Callback(hObject, eventdata, handles)
% hObject    handle to sweepnum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sweepnum as text
%        str2double(get(hObject,'String')) returns contents of sweepnum as a double


% --- Executes during object creation, after setting all properties.
function sweepnum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sweepnum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function trialrange_Callback(hObject, eventdata, handles)
% hObject    handle to trialrange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

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
