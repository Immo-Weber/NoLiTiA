function varargout = plot_batch_gui(varargin)
% PLOT_BATCH_GUI MATLAB code for plot_batch_gui.fig
%      PLOT_BATCH_GUI, by itself, creates a new PLOT_BATCH_GUI or raises the existing
%      singleton*.
%
%      H = PLOT_BATCH_GUI returns the handle to a new PLOT_BATCH_GUI or the handle to
%      the existing singleton*.
%
%      PLOT_BATCH_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLOT_BATCH_GUI.M with the given input arguments.
%
%      PLOT_BATCH_GUI('Property','Value',...) creates a new PLOT_BATCH_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before plot_batch_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to plot_batch_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help plot_batch_gui

% Last Modified by GUIDE v2.5 04-Sep-2019 21:43:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @plot_batch_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @plot_batch_gui_OutputFcn, ...
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


% --- Executes just before plot_batch_gui is made visible.
function plot_batch_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user files (see GUIDATA)
% varargin   command line arguments to plot_batch_gui (see VARARGIN)

% Choose default command line output for plot_batch_gui
handles.output = hObject;
handles.fileind=1;
handles.trialind=1;
handles.methodind=1;
handles.hold=0;
handles.showlabel=0;
handles.colorbarmin=0;
root = uitreenode('v0', 'Methods', 'Methods', [], false);
if isempty(getappdata(0,'results'))==0
    handles.results=getappdata(0,'results');
ind=find(ismember({handles.results.methods.methodnames},'nta_jointrecurrenceplot')==0,1,'first');
if isempty(ind)==1
    ind=1;
end
     set(handles.files,'string',1:length(handles.results.methods(ind).results{handles.trialind}));
     set(handles.Trials,'string',1:length(handles.results.methods(ind).results));

  [ handles,root ] = NoLiTiA_plot_tree(handles);


end
mtree = uitree('v0',handles.figure1, 'Root', root);
%set(mtree,'pos',[837,443,140,60]);
set(mtree,'pos',[841,479,135,120]);
handles.mtree = mtree;
guidata(hObject, handles);

% UIWAIT makes plot_batch_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = plot_batch_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user files (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in files.
function files_Callback(hObject, eventdata, handles)
% hObject    handle to files (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user files (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns files contents as cell array
%        contents{get(hObject,'Value')} returns selected item from files
handles.fileind=get(hObject,'Value');
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function files_CreateFcn(hObject, eventdata, handles)
% hObject    handle to files (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Load.
function Load_Callback(hObject, eventdata, handles)
% hObject    handle to Load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user files (see GUIDATA)
[file,path] = uigetfile;
if ischar(file)==1 & ischar(path)==1
temp=load([path '\' file]);
handles = setfield(handles,'results',temp.results);
[ handles ] = NoLiTiA_plot_tree( handles );

ind=find(ismember({temp.results.methods.methodnames},{'nta_jointrecurrenceplot','nta_crossrecurrenceplot','nta_MIbin','nta_MIkraskov'})==0,1,'first');
if isempty(ind)==1
    ind=1;
end
     set(handles.files,'string',1:length(temp.results.methods(ind).results));
end
guidata(hObject, handles);


% --- Executes on button press in Plot.
function Plot_Callback(hObject, eventdata, handles)
% hObject    handle to Plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user files (see GUIDATA)

try
mtree = handles.mtree;
nodename=mtree.SelectedNodes;
nName = nodename(1);

parent=char(nName.getParent.getName);
name = char(nName.getName());
idx = find(ismember(handles.methodIDs(:,2), parent));
if isempty(idx)==0
    data=handles.results.methods(handles.methodIDs{idx,1}).results{handles.trialind}{handles.fileind};
    
    if handles.hold==1
        axes(handles.axes1);
        hold all
    else
        axes(handles.axes1);
        hold off
    end
    if strcmp(name,'diff_logC')==1
        plot(data.logE_logC(1:data.cfg.resl:length(data.diff_logC)*data.cfg.resl-1,1),data.diff_logC,'linewidth',3,'color','r');
        axis square
        xlabel('Log E','fontsize',12)
        ylabel('Dim','fontsize',12)
        title([parent ': ' name])
    elseif strcmp(name,'logE_logC')==1
        plot(data.logE_logC(:,1),data.logE_logC(:,2),'linewidth',3,'color','r')
        axis square
        xlabel('Log E','fontsize',12)
        ylabel('Log Correlation Sum','fontsize',12)
        title([parent ': ' name])
    elseif strcmp(name,'diffloglya')==1
        plot(0:data.cfg.resl:data.cfg.it-(data.cfg.resl-1),data.diffloglya,'linewidth',3,'color','r');
        xlabel('Iterations')
        ylabel('LLE')
        title([parent ': ' name])
    elseif strcmp(name,'loglya')==1
        plot(data.it,data.loglya(1:end),'linewidth',3,'color','r')
        xlabel('Iterations')
        ylabel('ln Mean Distance')
        title([parent ': ' name])
    elseif strcmp(name,'logmeanrr')==1 %Hurst
        plot(data.lognges,data.logmeanrr,'linewidth',3,'color','r')
        axis square
        xlabel('log(N)','fontsize',12)
        ylabel('log(R/S)','fontsize',12)
        a = get(gca,'XTickLabel');
        set(gca,'XTickLabel',a,'FontName','Times','fontsize',18)
        b = get(gca,'YTickLabel');
        set(gca,'YTickLabel',b,'FontName','Times','fontsize',18)
        title([parent ': ' name])
    elseif strcmp(name,'logF')==1   %DFA
        plot(data.logbox,data.logF,'linewidth',3,'color','r')
        axis square
        xlabel('log(window length)','fontsize',12)
        ylabel('log(F)','fontsize',12)
        a = get(gca,'XTickLabel');
        set(gca,'XTickLabel',a,'FontName','Times','fontsize',18)
        b = get(gca,'YTickLabel');
        set(gca,'YTickLabel',b,'FontName','Times','fontsize',18)
        title([parent ': ' name])
    elseif strcmp(name,'fnn')==1
        plot(data.fnn(2,:),data.fnn(1,:),'linewidth',3,'color','r')
        axis square
        xlabel('Dimension','fontsize',12);
        ylabel('false nearest neighbours [%]','fontsize',12);
        a = get(gca,'XTickLabel');
        set(gca,'XTickLabel',a,'FontName','Times','fontsize',18)
        b = get(gca,'YTickLabel');
        set(gca,'YTickLabel',b,'FontName','Times','fontsize',18)
        title([parent ': ' name])
    elseif strcmp(name,'rmspe')==1
        imagesc(data.cfg.taus,data.cfg.dims,data.rmspe);
        axis square
        xlabel('Tau','fontsize',12)
        ylabel('Dimension','fontsize',12)
        a = get(gca,'XTickLabel');
        set(gca,'XTickLabel',a,'FontName','Times','fontsize',18)
        b = get(gca,'YTickLabel');
        set(gca,'YTickLabel',b,'FontName','Times','fontsize',18)
        title([parent ': ' name])
    elseif strcmp(name,'hto')==1
        contour(data.hto,data.cfg.nr,'ShowText','on')
        xlabel('dt')
        ylabel('dE')
        title([parent ': ' name])
    elseif strcmp(name,'countorig')==1 %UPO
        surf(data.cfg.mid2{1,1}(:),data.cfg.mid2{1,2}(:),data.countorig,'EdgeAlpha',0);
        view(0,90)
        shading interp
        xlabel('X-Axis','fontsize',12)
        ylabel('Y-Axis','fontsize',12)
        title([parent ': ' name])
    elseif strcmp(name,'counttrans')==1 %UPO
        surf(data.cfg.mid2{1,1}(:),data.cfg.mid2{1,2}(:),data.counttrans,'EdgeAlpha',0);
        view(0,90)
        shading interp
        xlabel('X-Axis','fontsize',12)
        ylabel('Y-Axis','fontsize',12)
        title([parent ': ' name])
    elseif strcmp(name,'countsurr')==1 %UPO
        surf(data.cfg.mid2{1,1}(:),data.cfg.mid2{1,2}(:),mean(data.countsurr,3),'EdgeAlpha',0);
        view(0,90)
        shading interp
        xlabel('X-Axis','fontsize',12)
        ylabel('Y-Axis','fontsize',12)
        title([parent ': ' name])
    elseif strcmp(name,'statcount')==1 %UPO
        surf(data.cfg.mid2{1,1}(:),data.cfg.mid2{1,2}(:),data.statcount,'EdgeAlpha',0);
        view(0,90)
        shading interp
        xlabel('X-Axis','fontsize',12)
        ylabel('Y-Axis','fontsize',12)
        title([parent ': ' name])
    elseif strcmp(name,'histdiag')==1 %UPO
        plot(data.cfg.mid2{1,1}(:),data.histdiag(:,1),'linewidth',2)
        hold on
        plot(data.cfg.mid2{1,1}(:),data.histdiag(:,2),'r','linewidth',2)
        legend('original','transformed')
        xlabel('x','fontsize',12)
        ylabel('p(x)','fontsize',12)
        title([parent ': ' name])
   elseif strcmp(name,'histdiagzscores')==1 %UPO
        sig=find(data.histdiagzscores>1.96);
        plot(data.cfg.mid2{1,1}(:),data.histdiagzscores,'linewidth',2)
        hold on
        plot(data.cfg.mid2{1,1}(sig),data.histdiagzscores(sig),'r','linewidth',2)
        legend('zscores','sign.')
        hold off
        xlabel('x','fontsize',12)
        ylabel('zscore','fontsize',12)       
        title([parent ': ' name])     
        
    elseif strcmp(name,'ht')==1 & strcmp(parent,'nta_recurrenceplot')==1 %recurrenceplot
        plot(data.cfg.minmaxRecPD(1):data.cfg.minmaxRecPD(2),data.ht);
        axis square
        set(gca,'XTick',0:floor(size(data.ht,2)/10)+1:size(data.ht,2))
        xlabel('T [samples]');
        ylabel('P(T)');
        title([parent ': ' name])
    elseif strcmp(name,'sumdist')==1 %recurrenceplot
        imagesc((1:data.N),(1:data.N),data.sumdist);
        colormap(gca,gray);
        axis square
        set(gca,'XTick',0:floor((data.N+1)/10)+1:(data.N+1),'YTick',0:floor((data.N+1)/10)+1:(data.N+1),...
            'XLim',[0 data.N+1],'YLim',[0 data.N+1],'YDir','normal');
        xlabel('state i','fontsize',12);
        ylabel('state j','fontsize',12);
        title([parent ': ' name])
    elseif strcmp(name,'gaco')==1 & (strcmp(parent,'nta_recurrenceplot')==1 | strcmp(parent,'nta_jointrecurrenceplot')==1 | strcmp(parent,'nta_crossrecurrenceplot')==1)%recurrenceplot
        plot(data.gaco,'linewidth',3,'color','r')
        axis square
        xlabel('lag [samples]','fontsize',12);
        ylabel('generalized autocorrelation','fontsize',12);
        title([parent ': ' name])
    elseif strcmp(name,'loght')==1 & strcmp(parent,'nta_recfreq_en_scan')==1
        pcolor(1:size(data.loght,2),data.ens,data.loght)
        shading interp
        set(gca, 'XScale', 'log')
        view(180,-90)
        xlabel('Recurrence period (samples)','fontsize',12)
        ylabel('scale (%)','fontsize',12)
        set(gca,'TickDir','out')
        box off
        title([parent ': ' name])
        set(handles.Colorbarslider,'min',min(min(data.loght(isinf(data.loght)==0)))-10^(-20),'max',10^(-10)+max(max(data.loght)),'Value',10^(-10)+max(max(data.loght)));
        set(handles.Colorbarslider_min,'min',min(min(data.loght(isinf(data.loght)==0)))-10^(-10),'max',1.0*max(max(data.loght)),'Value',min(min(data.loght(isinf(data.loght)==0)))-10^(-10));
        handles.colorbarmin=min(min(data.loght(isinf(data.loght)==0)))-10^(-10);
        handles.colorbar=10^(-10)+max(max(data.loght));
        caxis([handles.colorbarmin handles.colorbar]);
        elseif strcmp(name,'gaco')==1 & strcmp(parent,'nta_recfreq_en_scan')==1
        pcolor(1:size(data.gaco,2),data.ens,data.gaco)
        shading interp
        set(gca, 'XScale', 'log')
        view(180,-90)
        xlabel('Lag (samples)','fontsize',12)
        ylabel('scale (%)','fontsize',12)
        set(gca,'TickDir','out')
        box off
        title([parent ': ' name])
        set(handles.Colorbarslider,'min',min(min(data.gaco(isinf(data.gaco)==0)))-10^(-20),'max',10^(-10)+max(max(data.gaco)),'Value',10^(-10)+max(max(data.gaco)));
        set(handles.Colorbarslider_min,'min',min(min(data.gaco(isinf(data.gaco)==0)))-10^(-10),'max',1.0*max(max(data.gaco)),'Value',min(min(data.gaco(isinf(data.gaco)==0)))-10^(-10));
        handles.colorbarmin=min(min(data.gaco(isinf(data.gaco)==0)))-10^(-10);
        handles.colorbar=10^(-10)+max(max(data.gaco));
        caxis([handles.colorbarmin handles.colorbar]);
    elseif strcmp(name,'rpde')==1 & strcmp(parent,'nta_recfreq_en_scan')==1
        plot(data.ens,data.rpde,'linewidth',3,'color','r')
        axis square
        xlabel('scale (%)','fontsize',12);
        ylabel('RPDE','fontsize',12);
        a = get(gca,'XTickLabel');
        set(gca,'XTickLabel',a,'FontName','Times','fontsize',18)
        b = get(gca,'YTickLabel');
        set(gca,'YTickLabel',b,'FontName','Times','fontsize',18)
        title([parent ': ' name])
    elseif strcmp(name,'rr')==1 & strcmp(parent,'nta_recfreq_en_scan')==1
        plot(data.ens,data.rr,'linewidth',3,'color','r')
        axis square
        xlabel('scale (%)','fontsize',12);
        ylabel('RR','fontsize',12);
        a = get(gca,'XTickLabel');
        set(gca,'XTickLabel',a,'FontName','Times','fontsize',18)
        b = get(gca,'YTickLabel');
        set(gca,'YTickLabel',b,'FontName','Times','fontsize',18)
        title([parent ': ' name])
    elseif strcmp(name,'rr')==1 & strcmp(parent,'nta_wind_recfreq')==1
        plot(data.time,data.rr,'linewidth',3,'color','r')
        axis square
        xlabel('time','fontsize',12);
        ylabel('RR','fontsize',12);
        a = get(gca,'XTickLabel');
        set(gca,'XTickLabel',a,'FontName','Times','fontsize',18)
        b = get(gca,'YTickLabel');
        set(gca,'YTickLabel',b,'FontName','Times','fontsize',18)
        title([parent ': ' name])
    elseif strcmp(name,'det')==1 & strcmp(parent,'nta_wind_recfreq')==1
        plot(data.time,data.det,'linewidth',3,'color','r')
        axis square
        xlabel('time','fontsize',12);
        ylabel('DET','fontsize',12);
        a = get(gca,'XTickLabel');
        set(gca,'XTickLabel',a,'FontName','Times','fontsize',18)
        b = get(gca,'YTickLabel');
        set(gca,'YTickLabel',b,'FontName','Times','fontsize',18)
        title([parent ': ' name])
    elseif strcmp(name,'lam')==1 & strcmp(parent,'nta_wind_recfreq')==1
        plot(data.time,data.lam,'linewidth',3,'color','r')
        axis square
        xlabel('time','fontsize',12);
        ylabel('LAM','fontsize',12);
        a = get(gca,'XTickLabel');
        set(gca,'XTickLabel',a,'FontName','Times','fontsize',18)
        b = get(gca,'YTickLabel');
        set(gca,'YTickLabel',b,'FontName','Times','fontsize',18)
        title([parent ': ' name])
    elseif strcmp(name,'ratio')==1 & strcmp(parent,'nta_wind_recfreq')==1
        plot(data.time,data.ratio,'linewidth',3,'color','r')
        axis square
        xlabel('time','fontsize',12);
        ylabel('RATIO','fontsize',12);
        a = get(gca,'XTickLabel');
        set(gca,'XTickLabel',a,'FontName','Times','fontsize',18)
        b = get(gca,'YTickLabel');
        set(gca,'YTickLabel',b,'FontName','Times','fontsize',18)
        title([parent ': ' name])
    elseif strcmp(name,'resht')==1 & strcmp(parent,'nta_wind_recfreq')==1
        surf(data.time,data.cfg.minmaxRecPD(1):data.cfg.minmaxRecPD(2),data.resht);
        shading interp;
        view([0 90])
        xlabel('time [samples]','fontsize',12);
        ylabel('recurrence period [samples]','fontsize',12)
        colormap('jet')
        set(handles.Colorbarslider,'min',min(min(data.resht))-10^(-20),'max',10^(-10)+max(max(data.resht)),'Value',10^(-10)+max(max(data.resht)));
        set(handles.Colorbarslider_min,'min',min(min(data.resht))-10^(-10),'max',1.0*max(max(data.resht)),'Value',min(min(data.resht))-10^(-10));
        handles.colorbarmin=min(min(data.resht))-10^(-10);
        handles.colorbar=10^(-10)+max(max(data.resht));
        try
        caxis([handles.colorbarmin handles.colorbar]);
        end
    elseif strcmp(name,'Hx')==1
        bar(data.dist)
        text(0.8, 0.8, ['H = ' num2str(data.Hx)],'Color','red','FontSize',14,'Units','normalized');
        xlabel('Bin Number','fontsize',12)
        ylabel('P(x)','fontsize',12)
        a = get(gca,'XTickLabel');
        set(gca,'XTickLabel',a,'FontName','Times','fontsize',18)
        b = get(gca,'YTickLabel');
        set(gca,'YTickLabel',b,'FontName','Times','fontsize',18)
        title([parent ': ' name])
    elseif strcmp(name,'SI')==1
        plot(data.SI,'linewidth',3,'color','r')
        xlabel('Time [samples]','fontsize',12)
        ylabel('Shannon Information','fontsize',12)
        a = get(gca,'XTickLabel');
        set(gca,'XTickLabel',a,'FontName','Times','fontsize',18)
        b = get(gca,'YTickLabel');
        set(gca,'YTickLabel',b,'FontName','Times','fontsize',18)
        title([parent ': ' name])
    elseif strcmp(name,'ami')==1
        plot(data.ami,'linewidth',3,'color','r')
        axis square
        xlabel('lag [samples]','fontsize',12);
        ylabel('MI','fontsize',12)
        a = get(gca,'XTickLabel');
        set(gca,'XTickLabel',a,'FontName','Times','fontsize',18)
        b = get(gca,'YTickLabel');
        set(gca,'YTickLabel',b,'FontName','Times','fontsize',18)
        title([parent ': ' name])
    elseif strcmp(name,'lAIS')==1
        plot(data.lAIS,'color','r','linewidth',3)
        axis square
        xlabel('time','fontsize',12);
        ylabel('lAIS','fontsize',12)
        a = get(gca,'XTickLabel');
        set(gca,'XTickLabel',a,'FontName','Times','fontsize',18)
        b = get(gca,'YTickLabel');
        set(gca,'YTickLabel',b,'FontName','Times','fontsize',18)
        title([parent ': ' name])
    end
end
catch
    warndlg('No Method selected','Error')
end
guidata(hObject, handles);

% --- Executes on selection change in methods.
function methods_Callback(hObject, eventdata, handles)
% hObject    handle to methods (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user files (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns methods contents as cell array
%        contents{get(hObject,'Value')} returns selected item from methods
temp=cellstr(get(hObject,'String'));
handles.method=temp{get(hObject,'Value')};
handles.methodind=get(hObject,'Value');
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function methods_CreateFcn(hObject, eventdata, handles)
% hObject    handle to methods (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Clear.
function Clear_Callback(hObject, eventdata, handles)
% hObject    handle to Clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user files (see GUIDATA)
cla(handles.axes1,'reset')
guidata(hObject, handles);


% --- Executes on button press in hold_plot.
function hold_plot_Callback(hObject, eventdata, handles)
% hObject    handle to hold_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user files (see GUIDATA)
handles.hold=get(hObject,'Value');
guidata(hObject, handles);

% Hint: get(hObject,'Value') returns toggle state of hold_plot


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes on button press in Topo_Plot.
function Topo_Plot_Callback(hObject, eventdata, handles)
% hObject    handle to Topo_Plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Load the mtree handle
try
hold off
if isfield(handles,'channels')==1
delete(findall(gcf,'Type','light'))
handles.topodata=[];
mtree = handles.mtree;
% a=mtree.getSelectedNodes;
nodename=mtree.SelectedNodes;
nName = nodename(1);
%value =nName.getValue(); % Currently, may ignore this.
% Get a selected node name
parent=char(nName.getParent.getName);
name = char(nName.getName());
handles.name=name;
handles.pa=parent;
idx = find(ismember(handles.methodIDs(:,2), parent));

N=eval(['length(handles.results.methods(idx).results{handles.trialind}{handles.channels(1)}.' name ')']);
for i=1:length(handles.channels)
    handles.topodata(i,1:N)=eval(['handles.results.methods(idx).results{handles.trialind}{handles.channels(i)}.' name]);
end

[results] = topo( handles.topodata(:,1),handles.cap,handles.channels,0,name);
axes(handles.axes1);
h = trisurf(results.k,results.tri.Points(:,1),results.tri.Points(:,2),results.tri.Points(:,3),handles.topodata(:,1)) ;
title( [parent ': ' name]);
axis equal
light
lighting phong
shading interp
axis off
view([0 90])
% caxis(handles.lim)
hold on
maxy=max(results.cart3(:,2));
miny=min(results.cart3(:,2));
minx=min(results.cart3(:,1));
line([0,0], [maxy, maxy+(maxy-miny)/10], 'Color', 'r');
line([minx/5,0], [maxy, maxy+(maxy-miny)/10], 'Color', 'r');
line([-minx/5,0], [maxy, maxy+(maxy-miny)/10], 'Color', 'r');
% line([-0.02,0], [0.08, 0.09], 'Color', 'r');
% line([0.02,0], [0.08, 0.09], 'Color', 'r');
if handles.showlabel==1
scatter3(results.cart3(:,1),results.cart3(:,2),results.cart3(:,3),'.')
text(results.cart3(:,1)-0.005,results.cart3(:,2),results.cart3(:,3)+0.01,results.channelnames);
end
set(handles.Colorbarslider,'min',min(handles.topodata(:,1)-10^(-20)),'max',10^(-10)+max(handles.topodata(:,1)),'Value',10^(-10)+max(handles.topodata(:,1)));
set(handles.Colorbarslider_min,'min',min(handles.topodata(:,1))-10^(-10),'max',1.0*max(handles.topodata(:,1)),'Value',min(handles.topodata(:,1)-10^(-10)));
handles.colorbarmin=min(handles.topodata(:,1))-10^(-10);
handles.colorbar=10^(-10)+max(handles.topodata(:,1));
caxis([handles.colorbarmin handles.colorbar]);
set(handles.timepoint,'min',1,'max',N,'Value',1);
set(handles.timeindex,'String','0s');
end
catch
    warndlg('No Method selected','Error')
end
guidata(hObject, handles);


% --- Executes on button press in Topo_Param.
function Topo_Param_Callback(hObject, eventdata, handles)
% hObject    handle to Topo_Param (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file,path] = uigetfile('*.sfp');
cfg.capfile=[path '\' file];
[handles.cap]=loadcap(cfg);
prompt = {'Channels: ','Fs: '};
titlep = 'Parameters: Topography';
dims = [1 50];
definput = {'1:128','1000'};
answer = inputdlg(prompt,titlep,dims,definput);
handles.channels=str2num(answer{1});
handles.fs=str2num(answer{2});
set(handles.files,'string',handles.cap{1});
set(handles.Topo_Param,'BackgroundColor','green');
set(handles.Topo_Plot,'BackgroundColor','green');
guidata(hObject, handles);    


% --- Executes on slider movement.
function Colorbarslider_Callback(hObject, eventdata, handles)
% hObject    handle to Colorbarslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.colorbar=get(hObject,'Value');
caxis([handles.colorbarmin handles.colorbar]);
guidata(hObject, handles);    


% --- Executes during object creation, after setting all properties.
function Colorbarslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Colorbarslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function Colorbarslider_min_Callback(hObject, eventdata, handles)
% hObject    handle to Colorbarslider_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.colorbarmin=get(hObject,'Value');
caxis([handles.colorbarmin handles.colorbar]);
guidata(hObject, handles);    


% --- Executes during object creation, after setting all properties.
function Colorbarslider_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Colorbarslider_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function uipanel5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on slider movement.
function timepoint_Callback(hObject, eventdata, handles)
% hObject    handle to timepoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
[az,el] = view;
hold off
time=round(get(hObject,'Value'));
if isfield(handles,'topodata')==1 & size(handles.topodata,2)>1
set(handles.timeindex,'String',[num2str(time/handles.fs) 's']);
[results] = topo( handles.topodata(:,time),handles.cap,handles.channels,0,handles.name);
axes(handles.axes1);
h = trisurf(results.k,results.tri.Points(:,1),results.tri.Points(:,2),results.tri.Points(:,3),handles.topodata(:,time)) ;
title( [handles.pa ': ' handles.name]);
axis equal
light
lighting phong
shading interp
axis off
view([az,el])
% caxis(handles.lim)
hold on
maxy=max(results.cart3(:,2));
miny=min(results.cart3(:,2));
minx=min(results.cart3(:,1));
line([0,0], [maxy, maxy+(maxy-miny)/10], 'Color', 'r');
line([minx/5,0], [maxy, maxy+(maxy-miny)/10], 'Color', 'r');
line([-minx/5,0], [maxy, maxy+(maxy-miny)/10], 'Color', 'r');
if handles.showlabel==1
scatter3(results.cart3(:,1),results.cart3(:,2),results.cart3(:,3),'.')
text(results.cart3(:,1)-0.005,results.cart3(:,2),results.cart3(:,3)+0.01,results.channelnames);
end
caxis([handles.colorbarmin handles.colorbar]);
end
guidata(hObject, handles);

   

% --- Executes during object creation, after setting all properties.
function timepoint_CreateFcn(hObject, eventdata, handles)
% hObject    handle to timepoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function timeindex_CreateFcn(hObject, eventdata, handles)
% hObject    handle to timeindex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in label.
function label_Callback(hObject, eventdata, handles)
% hObject    handle to label (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of label
handles.showlabel=get(hObject,'Value');  
guidata(hObject, handles);


% --- Executes on button press in save_fig.
function save_fig_Callback(hObject, eventdata, handles)
% hObject    handle to save_fig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fignew = figure('Visible','off'); % Invisible figure
newAxes = copyobj(handles.axes1,fignew); % Copy the appropriate axes
set(newAxes, 'units', 'normalized', 'position', [0.13 0.17 0.775 0.75]);
set(fignew,'CreateFcn','set(gcbf,''Visible'',''on'')'); % Make it visible upon loading
[file,path] = uiputfile;
saveas(fignew,[path '\' file(1:end-4) '.png']);
delete(fignew)


% --- Executes on selection change in Trials.
function Trials_Callback(hObject, eventdata, handles)
% hObject    handle to Trials (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Trials contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Trials
handles.trialind=get(hObject,'Value');
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function Trials_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Trials (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
