function varargout = nolitia_statistics_gui(varargin)
% nolitia_statistics_gui MATLAB code for nolitia_statistics_gui.fig
%      nolitia_statistics_gui, by itself, creates a new nolitia_statistics_gui or raises the existing
%      singleton*.
%
%      H = nolitia_statistics_gui returns the handle to a new nolitia_statistics_gui or the handle to
%      the existing singleton*.
%
%      nolitia_statistics_gui('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in nolitia_statistics_gui.M with the given input arguments.
%
%      nolitia_statistics_gui('Property','Value',...) creates a new nolitia_statistics_gui or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before nolitia_statistics_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to nolitia_statistics_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help nolitia_statistics_gui

% Last Modified by GUIDE v2.5 29-Jun-2021 17:21:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @nolitia_statistics_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @nolitia_statistics_gui_OutputFcn, ...
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


% --- Executes just before nolitia_statistics_gui is made visible.
function nolitia_statistics_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to nolitia_statistics_gui (see VARARGIN)

% Choose default command line output for nolitia_statistics_gui
handles.output = hObject;
% handles.data1.file{1}=[];
% handles.data1.path{1}=[];
% handles.data2.file{1}=[];
% handles.data2.path{1}=[];
% Update handles structure
handles.clustervalue=0;
handles.montecarlovalue=0;
handles.lastpath=pwd;
guidata(hObject, handles);

% UIWAIT makes nolitia_statistics_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = nolitia_statistics_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stat=handles.statresults;
uisave('stat','data_stat.mat')


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1
handles.ListBoxValue = get(handles.listbox1,'Value');
load([handles.data1.path{handles.ListBoxValue} handles.data1.file{handles.ListBoxValue}])
handles.results=results;
set(handles.listbox3,'string',{handles.results.methods.methodnames});
guidata(hObject, handles);

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


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in right.
function right_Callback(hObject, eventdata, handles)
% hObject    handle to right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp=get(handles.listbox1,'Value');
if isfield(handles,'data2')==1
handles.data2.file=squeeze(horzcat(handles.data2.file,handles.data1.file(temp)));
handles.data2.path=squeeze(horzcat(handles.data2.path,handles.data1.path(temp)));

else
   handles.data2.file(1)=handles.data1.file(temp);
   handles.data2.path(1)=handles.data1.path(temp);

end   
handles.data1.file(temp)=[];
handles.data1.path(temp)=[];
set(handles.listbox2,'String',handles.data2.file);
set(handles.listbox1,'String',handles.data1.file);
set(handles.listbox2,'Value',1);
set(handles.listbox1,'Value',1);
guidata(hObject, handles);

% --- Executes on button press in left.
function left_Callback(hObject, eventdata, handles)
% hObject    handle to left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp=get(handles.listbox2,'Value');
handles.data1.file=squeeze(horzcat(handles.data1.file,handles.data2.file(temp)));
handles.data1.path=squeeze(horzcat(handles.data1.path,handles.data2.path(temp)));
handles.data2.file(temp)=[];
handles.data2.path(temp)=[];
set(handles.listbox2,'String',handles.data2.file);
set(handles.listbox1,'String',handles.data1.file);
set(handles.listbox2,'Value',1);
set(handles.listbox1,'Value',1);
guidata(hObject, handles);


% --- Executes on button press in cd.
function cd_Callback(hObject, eventdata, handles)
% hObject    handle to cd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[file,handles.lastpath]=uigetfile(handles.lastpath);
if isfield(handles,'data1')==1    
handles.data1.file=squeeze(horzcat(handles.data1.file,file));
handles.data1.path=squeeze(horzcat(handles.data1.path,handles.lastpath));
else
   handles.data1.file{1}=file;
   handles.data1.path{1}=handles.lastpath;
end

set(handles.listbox1,'String',handles.data1.file);

guidata(hObject, handles);


% --- Executes on button press in remove.
function remove_Callback(hObject, eventdata, handles)
% hObject    handle to remove (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp=get(handles.listbox1,'Value');
handles.data1.file(temp)=[];
handles.data1.path(temp)=[];
set(handles.listbox1,'String',handles.data1.file);
guidata(hObject, handles);


% --- Executes on button press in compute.
function compute_Callback(hObject, eventdata, handles)
% hObject    handle to compute (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
for i=1:length(handles.data1.file)
    load([handles.data1.path{i} handles.data1.file{i}])
    cfg_a1.results(i).methods=results.methods;    
end
cfg_a1.methodnames={results.methods.methodnames};

for i=1:length(handles.data2.file)
    load([handles.data2.path{i} handles.data2.file{i}])
    cfg_a2.results(i).methods=results.methods;
end
cfg_a2.methodnames={results.methods.methodnames};

cfg=[];
cfg.method=handles.method;
cfg.outputvar=handles.variable;
cfg.numperm=1000;
% cfg.vars=1:3;
cfg.maxcluster='sumt';
cfg.clustalpha=0.05;
cfg.plt=1;

[data1,data2] = fetch_data(cfg,cfg_a1,cfg_a2);
if handles.clustervalue==1
handles.statresults.cbpa=nta_nolitia_cbpa(data1,data2,cfg);
% set(handles.results_table,'data',[handles.statresults.monte.sig handles.statresults.monte.p],'ColumnName',{'Sig.', 'p'});
% figure
% minval=min(min(handles.statresults.cbpa.averages));
% maxval=max(max(handles.statresults.cbpa.averages));
% plot(handles.statresults.cbpa.averages(:,1),'r');
% hold on
% plot(handles.statresults.cbpa.averages(:,2),'g');
% xlabel('Time [samples]','Fontsize',12)
% ylabel('Variable','Fontsize',12)
% title('Cluster-statistics')
% legend('group 1', 'group 2')
if isfield(handles.statresults.cbpa,'pos_cluster')==1
%     sigind=find(handles.statresults.cbpa.pos_cluster.sig==1);
%     for i=1:length(sigind)
%         patch([handles.statresults.cbpa.pos_cluster.ids{sigind(i)}(1) handles.statresults.cbpa.pos_cluster.ids{sigind(i)}(end) handles.statresults.cbpa.pos_cluster.ids{sigind(i)}(end) handles.statresults.cbpa.pos_cluster.ids{sigind(i)}(1)],[minval minval maxval maxval],'g','FaceAlpha',.3)
%         text(handles.statresults.cbpa.pos_cluster.ids{sigind(i)}(1),maxval,['pos. cluster ' num2str(i) ': p=' num2str(handles.statresults.cbpa.pos_cluster.p(sigind(i)))] )
%     end
set(handles.results_table,'data',num2cell([handles.statresults.cbpa.pos_cluster.p]),'RowName',{'p-values: pos. cluster'},'ColumnName',num2cell(1:length(handles.statresults.cbpa.pos_cluster.p)));    
end

if isfield(handles.statresults.cbpa,'neg_cluster')==1
%     sigind=find(handles.statresults.cbpa.neg_cluster.sig==1);
%     for i=1:length(sigind)
%         patch([handles.statresults.cbpa.neg_cluster.ids{sigind(i)}(1) handles.statresults.cbpa.neg_cluster.ids{sigind(i)}(end) handles.statresults.cbpa.neg_cluster.ids{sigind(i)}(end) handles.statresults.cbpa.neg_cluster.ids{sigind(i)}(1)],[minval minval maxval maxval],'r','FaceAlpha',.3)
%         text(handles.statresults.cbpa.neg_cluster.ids{sigind(i)}(1),maxval,['neg. cluster ' num2str(i) ': p=' num2str(handles.statresults.cbpa.neg_cluster.p(sigind(i)))] )
%     end
    MatData = get(handles.results_table,'data');
    for i=1:length(handles.statresults.cbpa.neg_cluster.p)
    MatData{2,i}=handles.statresults.cbpa.neg_cluster.p(i);
    end
    set(handles.results_table,'data',MatData,'RowName',{'p-values: pos. cluster','p-values: neg. cluster'});    
end
    
%patch([400 500 500 400],[-3 -3 4 4],'r','FaceAlpha',.3)
elseif handles.montecarlovalue==1
handles.statresults.monte=nta_nolitia_monte(data1,data2,cfg);

set(handles.results_table,'data',[handles.statresults.monte.sig handles.statresults.monte.p],'ColumnName',{'Sig.', 'p'});
end


guidata(hObject, handles);


% --- Executes on selection change in listbox3.
function listbox3_Callback(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox3
handles.ListBox3Value = get(handles.listbox3,'Value');
handles.method=handles.listbox3.String{handles.ListBox3Value};
set(handles.listbox4,'string',fieldnames(handles.results.methods(handles.ListBox3Value).results{1}{1}));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function listbox3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox4.
function listbox4_Callback(hObject, eventdata, handles)
% hObject    handle to listbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox4
handles.ListBox4Value = get(handles.listbox4,'Value');
handles.variable=handles.listbox4.String{handles.ListBox4Value};
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function listbox4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in montecarlo.
function montecarlo_Callback(hObject, eventdata, handles)
% hObject    handle to montecarlo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of montecarlo
handles.montecarlovalue = get(handles.montecarlo,'Value');
handles.clustervalue=0;
guidata(hObject, handles);

% --- Executes on button press in Cluster.
function Cluster_Callback(hObject, eventdata, handles)
% hObject    handle to Cluster (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Cluster
handles.clustervalue = get(handles.Cluster,'Value');
handles.montecarlovalue=0;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function results_table_CreateFcn(hObject, eventdata, handles)
% hObject    handle to results_table (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


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
