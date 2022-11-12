function varargout = batch_gui(varargin)
% BATCH_GUI MATLAB code for batch_gui.fig
%      BATCH_GUI, by itself, creates a new BATCH_GUI or raises the existing
%      singleton*.
%
%      H = BATCH_GUI returns the handle to a new BATCH_GUI or the handle to
%      the existing singleton*.
%
%      BATCH_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BATCH_GUI.M with the given input arguments.
%
%      BATCH_GUI('Property','Value',...) creates a new BATCH_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before batch_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to batch_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help batch_gui

% Last Modified by GUIDE v2.5 29-Jun-2021 13:35:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @batch_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @batch_gui_OutputFcn, ...
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


% --- Executes just before batch_gui is made visible.
function batch_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to batch_gui (see VARARGIN)

% Choose default command line output for batch_gui
handles.output = hObject;
currentfolder=pwd;
d=dir([currentfolder '/*.mat']);
Datafold={d([d.isdir]).name}';
set(handles.folder,'data',Datafold,'ColumnName',{});
Data={d([d.isdir]==0).name}';
set(handles.datatab,'data',Data,'ColumnName',{});
handles.Data={};
handles.Datanames={};
handles.methodnames={};
handles.dim=[];
handles.tau=[];
Datamethods={'nta_corrdim';'nta_lya';'nta_hurst';'nta_dfa';'nta_fnn';'nta_ragwitz';'nta_spacetimesep';'nta_timerev';'nta_upo';'nta_recurrenceplot';'nta_recfreq_en_scan';'nta_wind_recfreq';'nta_crossrecurrenceplot';'nta_jointrecurrenceplot';'nta_entropybin';'nta_entropykozachenko';'nta_MIbin';'nta_MIkraskov';'nta_amutibin';'nta_amutiembknn';'nta_AIS';'nta_waveform_shape'};
set(handles.avmethods,'data',Datamethods,'ColumnName',{});
set(handles.Optimize,'Enable','off');
set(handles.enter_dim,'Enable','off');
set(handles.enter_tau,'Enable','off');
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes batch_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = batch_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in dataright.
function dataright_Callback(hObject, eventdata, handles)
% hObject    handle to dataright (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'reg')==1
    
%     handles.Datanames=vertcat(handles.Datanames,{handles.datatab.Data{handles.chosen(1)}}');
    temp=(load(handles.datatab.Data{handles.chosen(1)}));
    if iscell(eval(['temp' handles.reg]))==0          
    data{1}{1}=eval(['temp' handles.reg]);
    else
       data{1}=eval(['temp' handles.reg]); 
    end
   
    try
        handles.Data=horzcat(handles.Data,data);
        %handles.Data=horzcat(handles.Data,eval(['temp' handles.reg]));
        
        handles.Datanames=vertcat(handles.Datanames,{handles.datatab.Data{handles.chosen(1)}}');
        set(handles.chosendata,'data',handles.Datanames,'ColumnName',{});
         
    catch ME
        switch ME.identifier
            case 'MATLAB:nonExistentField'
                msgbox('Field not found!','Error');
                handles.Data=handles.Data;
            case 'MATLAB:badsubscript'
                msgbox('Indexing error!','Error');
                handles.Data=handles.Data;
        end
    end
    
    
else
    msgbox('No regular expression defined!','Error');
end
guidata(hObject, handles);


% --- Executes on button press in dataleft.
function dataleft_Callback(hObject, eventdata, handles)
% hObject    handle to dataleft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Datanames(handles.deleted(1))=[];
handles.Data(handles.deleted(1))=[];
set(handles.chosendata,'data',handles.Datanames,'ColumnName',{});
guidata(hObject, handles);

% --- Executes on button press in methodright.
function methodright_Callback(hObject, eventdata, handles)
% hObject    handle to methodright (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.methodnames=vertcat(handles.methodnames,{handles.avmethods.Data{handles.chosenmethods(1)}}');
set(handles.chmethods,'data',handles.methodnames,'ColumnName',{});
if sum(handles.chosenmethods(1)==[1 2 5 6 7 9 10 11 12 13 14 16 18 20 21])==1
set(handles.Optimize,'Enable','on');
set(handles.enter_dim,'Enable','on');
set(handles.enter_tau,'Enable','on');
end
guidata(hObject, handles);


% --- Executes on button press in methodleft.
function methodleft_Callback(hObject, eventdata, handles)
% hObject    handle to methodleft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.methodnames(handles.deletedmethods(1))=[];
set(handles.chmethods,'data',handles.methodnames,'ColumnName',{});
if sum(ismember(handles.methodnames,{'nta_corrdim' 'nta_lya' 'nta_fnn' 'nta_ragwitz' 'nta_spacetimesep' 'nta_upo' 'nta_recurrenceplot' 'nta_recfreq_en_scan' 'nta_wind_recfreq'  'nta_crossrecurrenceplot' 'nta_jointrecurrenceplot' 'nta_entropykozachenko' 'nta_MIkraskov' 'nta_amutiembknn' 'nta_AIS'}))==0
set(handles.Optimize,'Enable','off');
set(handles.enter_dim,'Enable','off');
set(handles.enter_tau,'Enable','off');
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function folder_CreateFcn(hObject, eventdata, handles)
% hObject    handle to folder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



% --- Executes during object creation, after setting all properties.
function datatab_CreateFcn(hObject, eventdata, handles)
% hObject    handle to datatab (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function chosendata_CreateFcn(hObject, eventdata, handles)
% hObject    handle to chosendata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function avmethods_CreateFcn(hObject, eventdata, handles)
% hObject    handle to avmethods (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function chmethods_CreateFcn(hObject, eventdata, handles)
% hObject    handle to chmethods (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes when selected cell(s) is changed in folder.
function folder_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to folder (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
if isempty(eventdata.Indices)==0
cd(cell2mat(handles.folder.Data(eventdata.Indices(1))));
d=dir;
Data={d([d.isdir]).name}';
set(handles.folder,'data',Data,'ColumnName',{});
Data={d([d.isdir]==0).name}';
set(handles.datatab,'data',Data,'ColumnName',{});
end



% --- Executes on key press with focus on folder and none of its controls.
function folder_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to folder (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function folder_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to folder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when selected cell(s) is changed in datatab.
function datatab_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to datatab (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
if isempty(eventdata.Indices)==0
handles.chosen=eventdata.Indices(1);
end
guidata(hObject, handles);


% --- Executes when selected cell(s) is changed in chosendata.
function chosendata_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to chosendata (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
if isempty(eventdata.Indices)==0
handles.deleted=eventdata.Indices(1);
end
guidata(hObject, handles);


% --- Executes when selected cell(s) is changed in avmethods.
function avmethods_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to avmethods (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
if isempty(eventdata.Indices)==0
handles.chosenmethods=eventdata.Indices(1);
end
guidata(hObject, handles);


% --- Executes when selected cell(s) is changed in chmethods.
function chmethods_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to chmethods (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
if isempty(eventdata.Indices)==0
handles.deletedmethods=eventdata.Indices(1);
end
guidata(hObject, handles);


% --- Executes on button press in Calculate.
function Calculate_Callback(hObject, eventdata, handles)
% hObject    handle to Calculate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[ handles ] = batch_wrapper( handles )
guidata(hObject, handles);

% --- Executes on button press in Parameters.
    function Parameters_Callback(hObject, eventdata, handles)
        % hObject    handle to Parameters (see GCBO)
        % eventdata  reserved - to be defined in a future version of MATLAB
        % handles    structure with handles and user data (see GUIDATA)
        if isempty(handles.methodnames)==0
        [handles]=generate_cfg(handles);
        set(handles.Parameters,'BackgroundColor','green');
        else
            msgbox('No methods selected!','Error');
        end
        guidata(hObject, handles);



function regular_expression_Callback(hObject, eventdata, handles)
% hObject    handle to regular_expression (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of regular_expression as text
%        str2double(get(hObject,'String')) returns contents of regular_expression as a double
handles.reg=['.' get(hObject,'String')];
set(handles.regular_expression,'BackgroundColor','green');
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function regular_expression_CreateFcn(hObject, eventdata, handles)
% hObject    handle to regular_expression (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Optimize.
function Optimize_Callback(hObject, eventdata, handles)
% hObject    handle to Optimize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% if isempty(handles.Data)==0
% prompt = {'Optimization Mode:','Max Dimension:','Threshold Rtol:','Threshold Atol:','Threshold Minimum:','Number of Bins:','Range of Taus', 'Mass:','Prediction Horizon:','Mode:'};
% title = 'Preprocessing Parameters';
% dims = [1 35];
% definput = {'deterministic','9','10','2','1','0','10:10:100','4','1','multi'};
% answer = inputdlg(prompt,title,dims,definput);
% cfg.optimization=answer{1};
% cfg.dim=str2num(answer{2});
% 
% cfg.Rtol=str2num(answer{3});
% cfg.Atol=str2num(answer{4});
% cfg.thr=str2num(answer{5});
% cfg.numbin=str2num(answer{6});
% cfg.taus=str2num(answer{7});
% cfg.mass=str2num(answer{8});
% cfg.hor=str2num(answer{9});
% cfg.mode=answer{10};
% cfg.verbose=0;
% h=waitbar(0,'Optimizing....');
% for i=1:length(handles.Data)
% [ optimize_batch{i} ]=batch_nolitia('optimize_embedding',cfg,handles.Data{i});
% for j=1:length(handles.Data{i})
% temp=cell2mat(optimize_batch{i}{j});
% handles.tau{i}(j,:)=[temp.opttau];
% handles.dim{i}(j,:)=[temp.optdim];
% end
% waitbar(i/length(handles.Data),h)
% % temp=cell2mat(optimize_batch{i});
% % handles.tau(i,:)=[temp.opttau];
% % handles.dim(i,:)=[temp.optdim];
% end
% close(h)
% %optimize_batch=cell2mat(optimize_batch);
% % handles.tau=[optimize_batch.opttau];
% % handles.dim=[optimize_batch.optdim];
% set(handles.Optimize,'BackgroundColor','green');
% else
%     msgbox('No data selected!','Error');
% end
[ handles ] = optimize_wrapper( handles );
guidata(hObject, handles);


% --- Executes on button press in Save.
function Save_Callback(hObject, eventdata, handles)
% hObject    handle to Save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selpath = uigetdir;
for i=1:length(handles.Data)
% if length(handles.Data)==1 & size(handles.Data{1},2)>1
    results=handles.results(i);
    save([selpath '\' handles.results(i).files{1}(1:end-4) '_NoLiTiA_results.mat'],'results');
end
% else
% for i=1:length(handles.results.methods(1).results)
%     results=[];
%     for j=1:length(handles.results.methods)
%         results.methods(j).results{1}=handles.results.methods(j).results{i};
% %         results.methods(j).name=handles.results.methods(j).methodnames;
%         results.methods(j).methodnames=handles.results.methods(j).methodnames;
%     end
%     results.variable=handles.results.variable;
%     results.filename=handles.results.files{i};
%     if isfield(handles.results,'prepare')==1
%     results.prepare=handles.results.prepare;
%     end
%     save([selpath '\' handles.results.files{i}(1:end-4) '_NoLiTiA_results.mat'],'results')
% end
% end
set(handles.Save,'BackgroundColor','green');
guidata(hObject, handles);


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over regular_expression.
function regular_expression_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to regular_expression (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject, 'Enable', 'On');
uicontrol(handles.regular_expression);
guidata(hObject, handles);


% --- Executes on button press in CD.
function CD_Callback(hObject, eventdata, handles)
% hObject    handle to CD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selpath = uigetdir;
cd(selpath)
d=dir([selpath '/*.mat']);
Datafold={d([d.isdir]).name}';
set(handles.folder,'data',Datafold,'ColumnName',{});
Data={d([d.isdir]==0).name}';
set(handles.datatab,'data',Data,'ColumnName',{});


% --- Executes on button press in prepare.
function prepare_Callback(hObject, eventdata, handles)
% hObject    handle to prepare (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[ handles ] = prepare_wrapper( handles );
guidata(hObject, handles);



function enter_dim_Callback(hObject, eventdata, handles)
% hObject    handle to enter_dim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of enter_dim as text
%        str2double(get(hObject,'String')) returns contents of enter_dim as a double
%for i=1:length(handles.Data)
    %for j=1:size(handles.Data{1},2)
%handles.dim(i,j)=str2num(get(hObject,'String'));
handles.dim=str2num(get(hObject,'String'));
    %end
%end
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
%for i=1:length(handles.Data)
    %for j=1:size(handles.Data{1},2)
%handles.tau(i,j)=str2num(get(hObject,'String'));
handles.tau=str2num(get(hObject,'String'));
    %end
%end
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


% --- Executes on button press in Clear.
function Clear_Callback(hObject, eventdata, handles)
% hObject    handle to Clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(gcbf)
batch_gui


% --- Executes on button press in Plot.
function Plot_Callback(hObject, eventdata, handles)
% hObject    handle to Plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'results')==1
    results=handles.results(1);
    setappdata(0,'results',results);
end
plot_batch_gui


% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
nolitia_statistics_gui