function varargout = nolitia_gui(varargin)
% nolitia_gui MATLAB code for nolitia_gui.fig
%      nolitia_gui, by itself, creates a new nolitia_gui or raises the existing
%      singleton*.
%
%      H = nolitia_gui returns the handle to a new nolitia_gui or the handle to
%      the existing singleton*.
%
%      nolitia_gui('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in nolitia_gui.M with the given input arguments.
%
%      nolitia_gui('Property','Value',...) creates a new nolitia_gui or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before nolitia_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to nolitia_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help nolitia_gui

% Last Modified by GUIDE v2.5 01-Oct-2021 13:14:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @nolitia_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @nolitia_gui_OutputFcn, ...
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


% --- Executes just before nolitia_gui is made visible.
function nolitia_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to nolitia_gui (see VARARGIN)

% Choose default command line output for nolitia_gui
handles.output = hObject;
set(gcf,{'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'},{'w','w','w'})
axes(handles.logo);
logo=imread('logo.jpg');
f=image(logo);
axis off
axis image

set(handles.logo,'ButtonDownFcn',@(~,~) web('www.clinicalsystemsneuroscience.de'),...
    'PickableParts','all')
set(f,'ButtonDownFcn',@(~,~) web('www.clinicalsystemsneuroscience.de'),...
    'PickableParts','all')

set(handles.axes5,'YTickLabel',[]);
set(handles.axes5,'XTickLabel',[]);

axes(handles.nolitia_logo);
% fi = [fileparts(which('mandelbrot_log2.gif')) '\mandelbrot_log2.gif'] ;
% [gifImage, cmap1] = imread(fi, 'Frames', 'all');
load('gifmat.mat');
for i=1:size(gifImage,4)
imshow(gifImage(:,:,:,i),cmap1);
drawnow
end
% nlogo=imread('nolitia_logo.png');
% f=image(nlogo);
axis off
axis image

handles.record{1}='%%Automatically generated script with NoLiTiA GUI%%';
handles.record{2}=['%%Generation Date: ' date '%%'];
handles.recordstate=0;
handles.surrstate=0;
set(handles.uipanel1,'Visible','on');
set(handles.uipanel2,'Visible','on');
set(handles.uipanel4,'Visible','on');
set(handles.uipanel5,'Visible','on');
set(handles.uipanel7,'Visible','on');
set(handles.axes3,'Visible','on');
set(handles.axes4,'Visible','on');
set(handles.enter_dim,'Enable','off');
set(handles.enter_tau,'Enable','off');
set(handles.optimize,'Enable','off');
% set(handles.axes5,'YTickLabel','auto','YTick','auto');
% set(handles.axes5,'XTickLabel','auto','XTick','auto');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes nolitia_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = nolitia_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in calculate.
function calculate_Callback(hObject, eventdata, handles)
% hObject    handle to calculate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
if handles.hold==1
    axes(handles.axes3);
    hold all
    axes(handles.axes4);
    hold all
else
    axes(handles.axes3);
    hold off
    axes(handles.axes4);
    hold off
end
axes(handles.axes3);
plot(handles.data(:,1));
xlabel('Time [samples]');
[ handles ] = calculate_method( handles );
catch
    warning('Could not calculate! Check data and parameters.')
    msgbox('Could not calculate! Check data and parameters.','Error','error')
end
guidata(hObject, handles);

% --- Executes on button press in clear.
function clear_Callback(hObject, eventdata, handles)
% hObject    handle to clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.axes3,'reset')
cla(handles.axes4,'reset')
Data=[];
set(handles.results_table,'data',Data,'ColumnName',{'', ''});
guidata(hObject, handles);


function enter_variable_Callback(hObject, eventdata, handles)
% hObject    handle to enter_variable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of enter_variable as text
%        str2double(get(hObject,'String')) returns contents of enter_variable as a double
temp=get(hObject,'String');
try
handles.data= evalin('base',temp);

if size(handles.data,1)==1
    handles.data=handles.data';
end
handles.results.varname=temp;
Data={temp};
set(handles.show_data,'data',Data,'ColumnName',{'Variable'});
axes(handles.axes5);
r = rectangle('Position',[0 0 1 1]');
r.FaceColor = [0 1 0];
if handles.recordstate==1
    handles.record{length(handles.record)+1}=['data=' temp ';'];
    handles.record{length(handles.record)+1}=['if size(data,1)==1'];
    handles.record{length(handles.record)+1}=['data=data'''];
    handles.record{length(handles.record)+1}=['end'];
end
catch
    warning('Variable not found!')
    msgbox('Variable not found!','Error')
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function enter_variable_CreateFcn(hObject, eventdata, handles)
% hObject    handle to enter_variable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in selectdata.
function selectdata_Callback(hObject, eventdata, handles)
% hObject    handle to selectdata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
[file,path] = uigetfile;
temp=load([path '\' file]);
Data=fieldnames(temp);
set(handles.show_data,'data',Data,'ColumnName',{'Variable'});
temp=struct2cell(temp);
handles.data=temp{1};
axes(handles.axes5);
r = rectangle('Position',[0 0 1 1]');
r.FaceColor = [0 1 0];
handles.results.dataname=[path '\' file];
if handles.recordstate==1
    handles.record{length(handles.record)+1}=['data=cell2mat(struct2cell(load([' path '\' file '])));'];
    handles.record{length(handles.record)+1}=['if size(data,1)==1'];
    handles.record{length(handles.record)+1}=['data=data'''];
    handles.record{length(handles.record)+1}=['end'];
end
catch
    warning('Data not compatible!')
    msgbox('Data not compatible!','Error')
end
guidata(hObject, handles);

% --- Executes on button press in testdata.
function testdata_Callback(hObject, eventdata, handles)
% hObject    handle to testdata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load('gui_testdata.mat');
handles.data=gui_testdata;
Data={'x,y'};
set(handles.show_data,'data',Data,'ColumnName',{'Variable'});
axes(handles.axes5);
r = rectangle('Position',[0 0 1 1]');
r.FaceColor = [0 1 0];
handles.results.dataname='gui_testdata.mat';
if handles.recordstate==1
    handles.record{length(handles.record)+1}='data=cell2mat(struct2cell(load(''gui_testdata.mat'')));';
end
guidata(hObject, handles);


function enter_dim_Callback(hObject, eventdata, handles)
% hObject    handle to enter_dim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of enter_dim as text
%        str2double(get(hObject,'String')) returns contents of enter_dim as a double

[temp,flag]=str2num(get(hObject,'String'));
if flag==1
    handles.dim=temp;
else
    msgbox('Enter Integer!','Error')
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function enter_dim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to enter_dim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function enter_tau_Callback(hObject, eventdata, handles)
% hObject    handle to enter_tau (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of enter_tau as text
%        str2double(get(hObject,'String')) returns contents of enter_tau as a double

[temp,flag]=str2num(get(hObject,'String'));
if flag==1
handles.tau=temp;
else
    msgbox('Enter Integer!','Error')
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function enter_tau_CreateFcn(hObject, eventdata, handles)
% hObject    handle to enter_tau (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in optimize.
function optimize_Callback(hObject, eventdata, handles)
% hObject    handle to optimize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
prompt = {'Optimization Mode:','Max Dimension:','Threshold Rtol:','Threshold Atol:','Threshold Minimum:','Number of Bins:','Range of Taus', 'Mass:','Prediction Horizon:','Mode:'};
title = 'Preprocessing Parameters';
dims = [1 35];
definput = {'deterministic','9','10','2','1','0','10:10:100','4','1','multi'};
answer = inputdlg(prompt,title,dims,definput);
cfg.optimization=answer{1};
cfg.dim=str2num(answer{2});
cfg.Rtol=str2num(answer{3});
cfg.Atol=str2num(answer{4});
cfg.thr=str2num(answer{5});
cfg.numbin=str2num(answer{6});
cfg.taus=str2num(answer{7});
cfg.mass=str2num(answer{8});
cfg.hor=str2num(answer{9});
cfg.mode=answer{10};
f = msgbox('Optimizing!','Please wait....','warn');
for i=1:size(handles.data,2)
[ results{i} ] = nta_optimize_embedding( handles.data(:,i),cfg );
handles.tau(i)=results{i}.opttau;
handles.dim(i)=results{i}.optdim;
Data=[results{i}.opttau,results{i}.optdim];
end
close(f)

set(handles.results_table,'data',Data,'ColumnName',{'Opt. Tau', 'Opt. Dim.'});
set(handles.optimize,'BackgroundColor','green');
if handles.recordstate==1
    handles.record{length(handles.record)+1}=['cfg.optimization=' '''' answer{1} ''';'];
    handles.record{length(handles.record)+1}=['cfg.dim=' answer{2} ';'];
    handles.record{length(handles.record)+1}=['cfg.Rtol=' answer{3} ';'];
    handles.record{length(handles.record)+1}=['cfg.Atol=' answer{4} ';'];
    handles.record{length(handles.record)+1}=['cfg.thr=' answer{5} ';'];
    handles.record{length(handles.record)+1}=['cfg.numbin=' answer{6} ';'];
    handles.record{length(handles.record)+1}=['cfg.taus=' answer{7}  ';'];
    handles.record{length(handles.record)+1}=['cfg.mass=' answer{8} ';'];
    handles.record{length(handles.record)+1}=['cfg.hor=' answer{9} ';'];
    handles.record{length(handles.record)+1}=['cfg.mode=' '''' answer{10} ''';'];
    handles.record{length(handles.record)+1}=['for i=1:size(data,2)'];
    handles.record{length(handles.record)+1}='[ results ] = nta_optimize_embedding( data(:,i),cfg);';
    handles.record{length(handles.record)+1}='end';
end
guidata(hObject, handles);

% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
batch_gui

% --- Executes on button press in prepare.
function prepare_Callback(hObject, eventdata, handles)
% hObject    handle to prepare (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
prompt = {'Time of interest:','Normalize?:','Detrend?:','Filter?','Lowpass-Freq.:','Highpass-Freq.:','Causal Filter?:','Sampling-Freq:'};
title = 'Preprocessing Parameters';
dims = [1 35];
definput = {'1:1000','1','1','0','0','0','1','1000'};
answer = inputdlg(prompt,title,dims,definput);
cfg.toi=str2num(answer{1});
cfg.normalize=str2num(answer{2});
cfg.detrend=str2num(answer{3});
cfg.filter=str2num(answer{4});
cfg.lpfreq=str2num(answer{5});
cfg.hpfreq=str2num(answer{6});
cfg.causal=str2num(answer{7});
cfg.fs=str2num(answer{8});
for i=1:size(handles.data,2)
[ prep_data(:,i) ] = nta_prepare_data(handles.data(:,i),cfg );
end
handles.data=prep_data;
set(handles.prepare,'BackgroundColor','green');
if handles.recordstate==1
    handles.record{length(handles.record)+1}=['cfg.toi=' answer{1} ';'];
    handles.record{length(handles.record)+1}=['cfg.normalize=' answer{2} ';'];
    handles.record{length(handles.record)+1}=['cfg.detrend=' answer{3} ';'];
    handles.record{length(handles.record)+1}=['cfg.filter=' answer{4} ';'];
    handles.record{length(handles.record)+1}=['cfg.lpfreq=' answer{5} ';'];
    handles.record{length(handles.record)+1}=['cfg.hpfreq=' answer{6} ';'];
    handles.record{length(handles.record)+1}=['cfg.causal=' answer{7} ';'];
    handles.record{length(handles.record)+1}=['cfg.fs=' answer{8} ';'];
    handles.record{length(handles.record)+1}='for i=1:size(data,2)';
    handles.record{length(handles.record)+1}='[prep_data(:,i)] = nta_prepare_data(data(:,i),cfg);';
    handles.record{length(handles.record)+1}='end';
    handles.record{length(handles.record)+1}='data=prep_data;';
end
guidata(hObject, handles);


% --- Executes on selection change in information.
function information_Callback(hObject, eventdata, handles)
% hObject    handle to information (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns information contents as cell array
%        contents{get(hObject,'Value')} returns selected item from information
temp=get(hObject,'Value');
handles.method=50+temp;
if sum(temp==[2 4 6 7])==1
set(handles.enter_dim,'Enable','on');
set(handles.enter_tau,'Enable','on');
set(handles.optimize,'Enable','on');
else
set(handles.enter_dim,'Enable','off');
set(handles.enter_tau,'Enable','off');
set(handles.optimize,'Enable','off'); 
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function information_CreateFcn(hObject, eventdata, handles)
% hObject    handle to information (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in recurrence.
function recurrence_Callback(hObject, eventdata, handles)
% hObject    handle to recurrence (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns recurrence contents as cell array
%        contents{get(hObject,'Value')} returns selected item from recurrence
temp=get(hObject,'Value');
handles.method=30+temp;
if sum(temp==[1 2 3 4 5])==1
set(handles.enter_dim,'Enable','on');
set(handles.enter_tau,'Enable','on');
set(handles.optimize,'Enable','on');
else
set(handles.enter_dim,'Enable','off');
set(handles.enter_tau,'Enable','off');
set(handles.optimize,'Enable','off'); 
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function recurrence_CreateFcn(hObject, eventdata, handles)
% hObject    handle to recurrence (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in nonlinear_dynamics.
function nonlinear_dynamics_Callback(hObject, eventdata, handles)
% hObject    handle to nonlinear_dynamics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns nonlinear_dynamics contents as cell array
%        contents{get(hObject,'Value')} returns selected item from nonlinear_dynamics
temp=get(hObject,'Value');
handles.method=10+temp;
if sum(temp==[1 2 3 6 7 9])==1
set(handles.enter_dim,'Enable','on');
set(handles.enter_tau,'Enable','on');
set(handles.optimize,'Enable','on');
else
set(handles.enter_dim,'Enable','off');
set(handles.enter_tau,'Enable','off');
set(handles.optimize,'Enable','off'); 
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function nonlinear_dynamics_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nonlinear_dynamics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in hold.
function hold_Callback(hObject, eventdata, handles)
% hObject    handle to hold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of hold
handles.hold=get(hObject,'Value');
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function axes2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes2


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes on selection change in related.
function related_Callback(hObject, eventdata, handles)
% hObject    handle to related (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns related contents as cell array
%        contents{get(hObject,'Value')} returns selected item from related
temp=get(hObject,'Value');
handles.method=70+temp;
if sum(temp==[1 2])==1
set(handles.enter_dim,'Enable','on');
set(handles.enter_tau,'Enable','on');
set(handles.optimize,'Enable','on');
else
set(handles.enter_dim,'Enable','off');
set(handles.enter_tau,'Enable','off');
set(handles.optimize,'Enable','off'); 
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function related_CreateFcn(hObject, eventdata, handles)
% hObject    handle to related (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in surrogate.
function surrogate_Callback(hObject, eventdata, handles)
% hObject    handle to surrogate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.surrstate==1
    handles.data=handles.surrtemp;
    handles.surrstate=0;
    set(handles.surrogate,'BackgroundColor','red');
else
prompt = {'Mode:','Number of Iterations:'};
title = 'Preprocessing Parameters';
dims = [1 35];
definput = {'2','100'};
answer = inputdlg(prompt,title,dims,definput);
cfg.mode=str2num(answer{1});
cfg.numit=str2num(answer{2});
for i=1:size(handles.data,2)
[results]=nta_surrogates(handles.data(:,i),cfg);
temp(:,i)=results.surr;
end
handles.surrtemp=handles.data;
handles.data=temp(:,i);
handles.surrstate=1;
set(handles.surrogate,'BackgroundColor','green');
end
axes(handles.axes3);
plot(handles.data(:,1));
if handles.recordstate==1
    handles.record{length(handles.record)+1}=['cfg.mode=' answer{1}];
    handles.record{length(handles.record)+1}=['cfg.sumit=' answer{2}];
    handles.record{length(handles.record)+1}='for i=1:size(data,2)';
    handles.record{length(handles.record)+1}='[results]=nta_surrogates(data(:,i),cfg);';
    handles.record{length(handles.record)+1}='data(:,i)=results.surr;';
    handles.record{length(handles.record)+1}='end';
end
guidata(hObject, handles);

% --- Executes when entered data in editable cell(s) in results_table.
function results_table_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to results_table (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function results_table_CreateFcn(hObject, eventdata, handles)
% hObject    handle to results_table (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function axes3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes3


% --- Executes during object creation, after setting all properties.
function axes4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes4


% --- Executes during object creation, after setting all properties.
function show_data_CreateFcn(hObject, eventdata, handles)
% hObject    handle to show_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes when entered data in editable cell(s) in show_data.
function show_data_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to show_data (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function axes5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes5


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over enter_variable.
function enter_variable_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to enter_variable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject, 'Enable', 'On');
uicontrol(handles.enter_variable);
guidata(hObject, handles);


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over enter_dim.
function enter_dim_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to enter_dim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject, 'Enable', 'On');
uicontrol(handles.enter_dim);
guidata(hObject, handles);


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over enter_tau.
function enter_tau_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to enter_tau (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject, 'Enable', 'On');
uicontrol(handles.enter_tau);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function logo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to logo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate logo


% --- Executes on mouse press over axes background.
function logo_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to logo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
web('http://www.clinicalsystemsneuroscience.de/')


% --- Executes on button press in Save.
function Save_Callback(hObject, eventdata, handles)
% hObject    handle to Save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
results=handles.results;
uisave('results')
set(handles.Save,'BackgroundColor','green');
if handles.recordstate==1
    handles.record{length(handles.record)+1}=['save(''results_nolitia'' , ''results_final'');'];
end
guidata(hObject, handles);


% --- Executes on button press in record_toggle.
function record_toggle_Callback(hObject, eventdata, handles)
% hObject    handle to record_toggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of record_toggle
handles.recordstate=get(hObject,'Value');
guidata(hObject, handles);

% --- Executes on button press in save_record.
function save_record_Callback(hObject, eventdata, handles)
% hObject    handle to save_record (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file,path] = uiputfile;
fileID = fopen([path '\' file(1:end-4) '_GUI_record.m'],'w');
formatSpec = '%s\n';
[nrows,ncols] = size(handles.record);
for column = 1:ncols
    fprintf(fileID,formatSpec,handles.record{:,column});
end
fclose(fileID);
set(handles.save_record,'BackgroundColor','green');
guidata(hObject, handles);


% --- Executes on button press in clear_record.
function clear_record_Callback(hObject, eventdata, handles)
% hObject    handle to clear_record (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.record(3:end)=[];
guidata(hObject, handles);


% --- Executes on button press in reload_gui.
function reload_gui_Callback(hObject, eventdata, handles)
% hObject    handle to reload_gui (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(gcbf)
nolitia_gui


% --- Executes during object creation, after setting all properties.
function nolitia_logo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nolitia_logo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate nolitia_logo


% --- Executes on button press in Save_fig.
function Save_fig_Callback(hObject, eventdata, handles)
% hObject    handle to Save_fig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.axes3.Units = 'pixels';
pos1 = handles.axes3.Position;
ti1 = handles.axes3.TightInset;
rect1 = [-ti1(1), -ti1(2), pos1(3)+ti1(1)+ti1(3), pos1(4)+ti1(2)+ti1(4)];

F1 = getframe(handles.axes3,rect1);
Image1 = frame2im(F1);
[file1,path1] = uiputfile('figure1.jpg');
imwrite(Image1, [path1 file1]);



handles.axes4.Units = 'pixels';
pos2 = handles.axes4.Position;
ti2 = handles.axes4.TightInset;
rect2 = [-ti2(1), -ti2(2), pos2(3)+ti2(1)+ti2(3), pos2(4)+ti2(2)+ti2(4)];
F2 = getframe(handles.axes4,rect2);
Image2 = frame2im(F2);
[file2,path2] = uiputfile('figure2.jpg');
imwrite(Image2, [path2 file2]);
set(handles.Save_fig,'BackgroundColor','green');
