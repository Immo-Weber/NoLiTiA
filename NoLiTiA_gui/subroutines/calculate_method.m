function [ handles ] = calculate_method( handles )
%%Sub-routine for Nolitia_gui%%

if handles.method==11
    axes(handles.axes4);
    prompt = {'Min/Max Neighbourhood-Sizes:','Number of Query Points','Theiler-Window:','Number of Points to Use for Local Slope Estimation:'};
    titlevar = 'Parameters';
    dims = [1 35];
    definput = {'[1 100]','10','0','2'};
    answer = inputdlg(prompt,titlevar,dims,definput);
    cfg.ens=str2num(answer{1});
    cfg.nr=str2num(answer{2});
    cfg.th=str2num(answer{3});
    cfg.resl=str2num(answer{4});
    cfg.dim=handles.dim(1);
    cfg.tau=handles.tau(1);
    f = msgbox('Calculating!','Please wait....','warn');
    [results]=nta_corrdim(handles.data(:,1),cfg);
    close(f)
    plot(results.logE_logC(1:cfg.resl:length(results.diff_logC)*cfg.resl-1,1),results.diff_logC,'linewidth',3,'color','r');
    axis square
    xlabel('Log E [arb.]','fontsize',12)
    ylabel('Dim [arb.]','fontsize',12)
    Data=[results.Dtakens];
    set(handles.results_table,'data',Data,'ColumnName',{'Taken''s Estimator'});
    handles.results.corrdim=results;
    if handles.recordstate==1
        handles.record{length(handles.record)+1}=['cfg=[];'];
        handles.record{length(handles.record)+1}=['cfg.ens='  answer{1} ';'];
        handles.record{length(handles.record)+1}=['cfg.nr=' answer{2} ';'];
        handles.record{length(handles.record)+1}=['cfg.th=' answer{3} ';'];
        handles.record{length(handles.record)+1}=['cfg.resl=' answer{4} ';'];
        handles.record{length(handles.record)+1}=['cfg.dim=' num2str(handles.dim(1))  ';'];
        handles.record{length(handles.record)+1}=['cfg.tau=' num2str(handles.tau(1)) ';'];
        handles.record{length(handles.record)+1}='[results]=nta_corrdim(data(:,1),cfg);';
    end
elseif handles.method==12
    axes(handles.axes4);
    prompt = {'Method:','Neighbourhood-Size:','Number of Query Points','Theiler-Window:','Number of Iterations:','Number of Points to Use for Local Slope Estimation:'};
    titlevar = 'Parameters';
    dims = [1 35];
    definput = {'Kantz','5','500','0','100','2'};
    answer = inputdlg(prompt,titlevar,dims,definput);
    cfg.method=answer{1};
    cfg.en=str2num(answer{2});
    cfg.numran=str2num(answer{3});
    cfg.th=str2num(answer{4});
    cfg.it=str2num(answer{5});
    cfg.resl=str2num(answer{6});
    cfg.dim=handles.dim(1);
    cfg.tau=handles.tau(1);
    f = msgbox('Calculating!','Please wait....','warn');
    [results]=nta_lya(handles.data(:,1),cfg);
    close(f)
    plot(0:cfg.resl:cfg.it-(cfg.resl-1),results.diffloglya,'linewidth',3,'color','r');
    xlabel('Iterations [arb.]','fontsize',12)
    ylabel('LLE [arb.]','fontsize',12)
    Data=[results.lle];
    set(handles.results_table,'data',Data,'ColumnName',{'LLE'});
    handles.results.lya=results;
    if handles.recordstate==1
        handles.record{length(handles.record)+1}=['cfg=[];'];
        handles.record{length(handles.record)+1}=['cfg.method=' '''' answer{1} ''';'];
        handles.record{length(handles.record)+1}=['cfg.en=' answer{2} ';'];
        handles.record{length(handles.record)+1}=['cfg.numran=' answer{3} ';'];
        handles.record{length(handles.record)+1}=['cfg.th=' answer{4} ';'];
        handles.record{length(handles.record)+1}=['cfg.it=' answer{5} ';'];
        handles.record{length(handles.record)+1}=['cfg.resl=' answer{6} ';'];
        handles.record{length(handles.record)+1}=['cfg.dim=' num2str(handles.dim(1))  ';'];
        handles.record{length(handles.record)+1}=['cfg.tau=' num2str(handles.tau(1)) ';'];
        handles.record{length(handles.record)+1}='[results]=nta_lya(data(:,1),cfg);';
    end
elseif handles.method==13
    axes(handles.axes4);
    prompt = {'Threshold Rtol:','Threshold Atol:','Threshold Minimum:'};
    titlevar = 'Parameters';
    dims = [1 35];
    definput = {'10','2','1'};
    answer = inputdlg(prompt,titlevar,dims,definput);
    cfg.Rtol=str2num(answer{1});
    cfg.Atol=str2num(answer{2});
    cfg.thr=str2num(answer{3});
    cfg.plt=0;
    cfg.tau=handles.tau(1);
    cfg.dim=handles.dim;
    f = msgbox('Calculating!','Please wait....','warn');
    [results]=nta_fnn(handles.data(:,1),cfg);
    close(f)
    plot(results.fnn(2,:),results.fnn(1,:))
    xlabel('Embedding dimension [arb.]')
    ylabel('False nearest neighbours [%]')
    Data=[results.firstmin];
    set(handles.results_table,'data',Data,'ColumnName',{'1. Min.'});
    handles.results.fnn=results;
    if handles.recordstate==1
        handles.record{length(handles.record)+1}=['cfg=[];'];
        handles.record{length(handles.record)+1}=['cfg.Rtol=' answer{1} ';'];
        handles.record{length(handles.record)+1}=['cfg.Atol=' answer{2} ';'];
        handles.record{length(handles.record)+1}=['cfg.thr=' answer{3} ';'];
        handles.record{length(handles.record)+1}=['cfg.dim=' num2str(handles.dim)  ';'];
        handles.record{length(handles.record)+1}=['cfg.tau=' num2str(handles.tau(1)) ';'];
        handles.record{length(handles.record)+1}='[results]=nta_fnn(data(:,1),cfg);';
    end
elseif handles.method==14
    axes(handles.axes4);
    prompt = {'Max. Number of Windows:'};
    titlevar = 'Parameters';
    dims = [1 35];
    definput = {'10'};
    answer = inputdlg(prompt,titlevar,dims,definput);
    cfg.scale=str2num(answer{1});
    cfg.plt=0;
    f = msgbox('Calculating!','Please wait....','warn');
    [results]=nta_hurst(handles.data(:,1),cfg);
    close(f)
    plot(results.lognges,results.logmeanrr)
    axis square
    xlabel('Log(N) [arb.]','fontsize',12)
    ylabel('Log(R/S) [arb.]','fontsize',12)
%     a                           =   get(gca,'XTickLabel');
%     set(gca,'XTickLabel',a,'FontName','Times','fontsize',18)
%     b                           =   get(gca,'YTickLabel');
%     set(gca,'YTickLabel',b,'FontName','Times','fontsize',18)
    Data=[results.expo];
    set(handles.results_table,'data',Data,'ColumnName',{'Exponent'});
    handles.results.hurst=results;
    if handles.recordstate==1
        handles.record{length(handles.record)+1}=['cfg=[];'];
        handles.record{length(handles.record)+1}=['cfg.scale=' answer{1} ';'];
        handles.record{length(handles.record)+1}='[results]=nta_hurst(data(:,1),cfg);';
    end
elseif handles.method==15
    axes(handles.axes4);
    prompt = {'Min/Max. Number of Windows:'};
    titlevar = 'Parameters';
    dims = [1 35];
    definput = {'[2 100]'};
    answer = inputdlg(prompt,titlevar,dims,definput);
    cfg.scales=str2num(answer{1});
    cfg.plt=0;
    f = msgbox('Calculating!','Please wait....','warn');
    [results]=nta_dfa(handles.data(:,1),cfg);
    close(f)
    plot(results.logbox,results.logF)
    axis square
    xlabel('Log(window length) [arb.]','fontsize',12)
    ylabel('Log(F) [arb.]','fontsize',12)  
%     a                       =   get(gca,'XTickLabel');
%     set(gca,'XTickLabel',a,'FontName','Times','fontsize',18)
%     b                       =   get(gca,'YTickLabel');
%     set(gca,'YTickLabel',b,'FontName','Times','fontsize',18)
    Data=[results.expo];
    set(handles.results_table,'data',Data,'ColumnName',{'Exponent'});
    handles.results.dfa=results;
    if handles.recordstate==1
        handles.record{length(handles.record)+1}=['cfg=[];'];
        handles.record{length(handles.record)+1}=['cfg.scale=' answer{1} ';'];
        handles.record{length(handles.record)+1}='[results]=nta_dfa(data(:,1),cfg);';
    end
elseif handles.method==16
    axes(handles.axes4);
    prompt = {'Mode:','Mass:','Prediction Horizon:','Distance Norm'};
    titlevar = 'Parameters';
    dims = [1 35];
    definput = {'multi','4','1','maximum'};
    answer = inputdlg(prompt,titlevar,dims,definput);
    cfg.mode=answer{1};
    cfg.mass=str2num(answer{2});
    cfg.hor=str2num(answer{3});
    cfg.metric=answer{4};
    cfg.plt=0;
    cfg.taus=handles.tau;
    cfg.dims=handles.dim;
    f = msgbox('Calculating!','Please wait....','warn');
    [results]=nta_ragwitz(handles.data(:,1),cfg);
    close(f)
    imagesc(results.tauvec,[cfg.dims(1):cfg.dims(2)],results.rmspe);
    axis square
    xlabel('Tau [samples]','fontsize',12)
    ylabel('Dimension [arb.]','fontsize',12)
    a                                       = get(gca,'XTickLabel');
    set(gca,'XTickLabel',a,'FontName','Times','fontsize',18)
    b                                       = get(gca,'YTickLabel');
    set(gca,'YTickLabel',b,'FontName','Times','fontsize',18)
    handles.results.ragwitz=results;
    set(handles.results_table,'data',[results.tauopt results.dimopt],'ColumnName',{'opt. tau','opt. dim'});
    if handles.recordstate==1
        handles.record{length(handles.record)+1}=['cfg=[];'];
        handles.record{length(handles.record)+1}=['cfg.mode=' '''' answer{1} ''';'];
        handles.record{length(handles.record)+1}=['cfg.mass=' answer{2} ';'];
        handles.record{length(handles.record)+1}=['cfg.hor=' answer{3} ';'];
        handles.record{length(handles.record)+1}=['cfg.metric=' '''' answer{4} ''';'];
        handles.record{length(handles.record)+1}=['cfg.dims=[' num2str(handles.dim)  '];'];
        handles.record{length(handles.record)+1}=['cfg.taus=[' num2str(handles.tau) '];'];
        handles.record{length(handles.record)+1}='[results]=nta_ragwitz(data(:,1),cfg);';
    end
elseif handles.method==17
    axes(handles.axes4);
    prompt = {'Number of Classes:','Maximum Temporal Distance:','Distance Norm'};
    titlevar = 'Parameters';
    dims = [1 35];
    definput = {'4','100','maximum'};
    answer = inputdlg(prompt,titlevar,dims,definput);
    cfg.nr=str2num(answer{1});
    cfg.maxlag=str2num(answer{2});
    cfg.metric=answer{3};
    cfg.plt=0;
    cfg.tau=handles.tau(1);
    cfg.dim=handles.dim(1);
    f = msgbox('Calculating!','Please wait....','warn');
    [results]=nta_spacetimesep(handles.data(:,1),cfg);
    close(f)
    contour(results.lagvector,results.classvector,results.hto,cfg.nr,'ShowText','on')
    xlabel('dt [samples]','fontsize',12)
    ylabel('dE [arb.]','fontsize',12)
    handles.results.spacetimesep=results;
    if handles.recordstate==1
        handles.record{length(handles.record)+1}=['cfg=[];'];
        handles.record{length(handles.record)+1}=['cfg.nr='  answer{1} ';'];
        handles.record{length(handles.record)+1}=['cfg.maxlag=' answer{2} ';'];
        handles.record{length(handles.record)+1}=['cfg.metric=' '''' answer{3} ''';'];
        handles.record{length(handles.record)+1}=['cfg.dim=' num2str(handles.dim(1))  ';'];
        handles.record{length(handles.record)+1}=['cfg.tau=' num2str(handles.tau(1)) ';'];
        handles.record{length(handles.record)+1}='[results]=nta_spacetimesep(data(:,1),cfg);';
    end
elseif handles.method==18
    axes(handles.axes4);
    prompt = {'Lag:','Number of Surrogates:','Surrogate Mode:'};
    titlevar = 'Parameters';
    dims = [1 35];
    definput = {'1','100','2'};
    answer = inputdlg(prompt,titlevar,dims,definput);
    cfg.lag=str2num(answer{1});
    cfg.numsurr=str2num(answer{2});
    cfg.surrmode=str2num(answer{3});
    f = msgbox('Calculating!','Please wait....','warn');
    [results]=nta_timerev(handles.data(:,1),cfg);
    close(f)
    Data=[results.zstat,results.sig];
    set(handles.results_table,'data',Data,'ColumnName',{'Z','Sig.'});
    handles.results.timerev=results;
    if handles.recordstate==1
        handles.record{length(handles.record)+1}=['cfg=[];'];
        handles.record{length(handles.record)+1}=['cfg.lag='  answer{1} ';'];
        handles.record{length(handles.record)+1}=['cfg.numsurr=' answer{2} ';'];
        handles.record{length(handles.record)+1}=['cfg.surrmode=' num2str(handles.dim)  ';'];
        handles.record{length(handles.record)+1}='[results]=nta_timerev(data(:,1),cfg);';
    end
elseif handles.method==19
    axes(handles.axes4);
    prompt = {'Number of Iterations:','Number of Bins:','Number of Surrogates:','Surrogate Mode:'};
    titlevar = 'Parameters';
    dims = [1 35];
    definput = {'100','[100 100]','0','2'};
    answer = inputdlg(prompt,titlevar,dims,definput);
    cfg.numit=str2num(answer{1});
    cfg.bins=str2num(answer{2});
    cfg.numsurr=str2num(answer{3});
    cfg.surrmode=str2num(answer{4});
    cfg.tau=handles.tau(1);
    f = msgbox('Calculating!','Please wait....','warn');
    [results] = nta_upo( handles.data(:,1),cfg );
    close(f)
    handles.results.upo=results;
    if handles.recordstate==1
        handles.record{length(handles.record)+1}=['cfg=[];'];
        handles.record{length(handles.record)+1}=['cfg.numit='  answer{1} ';'];
        handles.record{length(handles.record)+1}=['cfg.bins=' answer{2} ';'];
        handles.record{length(handles.record)+1}=['cfg.numsurr=' answer{3} ';'];
        handles.record{length(handles.record)+1}=['cfg.surrmode=' answer{4} ';'];
        handles.record{length(handles.record)+1}=['cfg.tau=' num2str(handles.tau(1)) ';'];
        handles.record{length(handles.record)+1}='[results] = nta_upo( handles.data(:,1),cfg );';
    end
elseif handles.method==31
    axes(handles.axes4);
    prompt = {'Neighbourhood-Size:','Recurrence Rate:','Min-Lenght of Diag. Lines(DET):','Min-Lenght of Vert. Lines(LAM):','Min/Max of Recurrence Periods:','Only next Neighbour?:' 'Normalize  Recurrence Periods?:','Distance Norm'};
    titlevar = 'Parameters';
    dims = [1 35];
    definput = {'0','5','0','0','[1 500]','1','0','maximum'};
    answer = inputdlg(prompt,titlevar,dims,definput);
    cfg.en=str2num(answer{1});
    cfg.rr=str2num(answer{2});
    cfg.minlengthdet=str2num(answer{3});
    cfg.minlengthlam=str2num(answer{4});
    cfg.minmaxRecPD=str2num(answer{5});
    cfg.singlenei=str2num(answer{6});
    cfg.norm=str2num(answer{7});
    cfg.metric=answer{8};
    cfg.dim=handles.dim(1);
    cfg.tau=handles.tau(1);
    f = msgbox('Calculating!','Please wait....','warn');
    [ results ] = nta_recurrenceplot( handles.data(:,1),cfg );
    close(f)
    axes(handles.axes4);
    [r,c]                           =   size(results.sumdist);
    imagesc((1:c),(1:r),results.sumdist);
    colormap(gray);    
    set(gca,'XTick',0:floor((c+1)/10)+1:(c+1),'YTick',0:floor((c+1)/10)+1:(r+1),...
        'XLim',[0 c+1],'YLim',[0 c+1],'YDir','normal');
    xlabel('State i [samples]','fontsize',12)
    ylabel('State j [samples]','fontsize',12)
    Data=[results.rr,results.rpde,results.det,results.lam,results.ratio];
    set(handles.results_table,'data',Data,'ColumnName',{'RR','RPDE','DET','LAM','RATIO'});
    handles.results.recurrenceplot=results;
    if handles.recordstate==1
        handles.record{length(handles.record)+1}=['cfg=[];'];
        handles.record{length(handles.record)+1}=['cfg.en=' answer{1} ';'];
        handles.record{length(handles.record)+1}=['cfg.rr=' answer{2} ';'];
        handles.record{length(handles.record)+1}=['cfg.minlengthdet=' answer{3} ';'];
        handles.record{length(handles.record)+1}=['cfg.minlengthlam=' answer{4} ';'];
        handles.record{length(handles.record)+1}=['cfg.minmaxRecPD=' answer{5} ';'];
        handles.record{length(handles.record)+1}=['cfg.singlenei=' answer{6} ';'];
        handles.record{length(handles.record)+1}=['cfg.norm=' answer{7} ';'];
         handles.record{length(handles.record)+1}=['cfg.metric=' '''' answer{8} ''';'];
        handles.record{length(handles.record)+1}=['cfg.dim=' num2str(handles.dim(1))  ';'];
        handles.record{length(handles.record)+1}=['cfg.tau=' num2str(handles.tau(1)) ';'];
        handles.record{length(handles.record)+1}='[ results ] = nta_recurrenceplot( data(:,1),cfg );';
    end
elseif handles.method==32
    axes(handles.axes4);
    prompt = {'Range of Neighbourhood-Sizes:','Min/Max of Recurrence Periods:','Only next Neighbour?:' 'Normalize  Recurrence Periods?:','Distance Norm'};
    titlevar = 'Parameters';
    dims = [1 35];
    definput = {'[1 1 101]','[1 500]','1','0','maximum'};
    answer = inputdlg(prompt,titlevar,dims,definput);
    cfg.ens=str2num(answer{1});
    cfg.minmaxRecPD=str2num(answer{2});
    cfg.singlenei=str2num(answer{3});
    cfg.norm=str2num(answer{4});
    cfg.metric=answer{5};
    cfg.dim=handles.dim(1);
    cfg.tau=handles.tau(1);
    cfg.plt=0;
    f = msgbox('Calculating!','Please wait....','warn');
    [ results ] = nta_recfreq_en_scan( handles.data(:,1),cfg );
    close(f)
    pcolor(1:size(results.loght,2),cfg.ens(1):cfg.ens(2):cfg.ens(3),results.loght)
    shading interp
    colormap jet
    set(gca, 'XScale', 'log')
    view(180,-90)
    xlabel('Recurrence period [samples]','fontsize',12)
    ylabel('Scale [%]','fontsize',12)
    set(gca,'TickDir','out')
    box off
    axis tight
    h=colorbar
    ylabel(h,'log10(P(t)) [arb.]','fontsize',12)
    Data=[results.rr,results.rpde];
    set(handles.results_table,'data',Data,'ColumnName',{'RR','RPDE'});
    handles.results.recfreq_en_scan=results;
    if handles.recordstate==1
        handles.record{length(handles.record)+1}=['cfg=[];'];
        handles.record{length(handles.record)+1}=['cfg.ens=' answer{1} ';'];
        handles.record{length(handles.record)+1}=['cfg.minmaxRecPD=' answer{2} ';'];
        handles.record{length(handles.record)+1}=['cfg.singlenei=' answer{3} ';'];
        handles.record{length(handles.record)+1}=['cfg.norm=' answer{4} ';'];
        handles.record{length(handles.record)+1}=['cfg.metric=' '''' answer{5} ''';'];
        handles.record{length(handles.record)+1}=['cfg.dim=' num2str(handles.dim(1))  ';'];
        handles.record{length(handles.record)+1}=['cfg.tau=' num2str(handles.tau(1)) ';'];
        handles.record{length(handles.record)+1}='[ results ] = nta_recurrenceplot(data(:,1),cfg );';
    end
    
elseif handles.method==33
    axes(handles.axes4);
    prompt = {'Neighbourhood-Size:','Min/Max of Recurrence Periods:','Only next Neighbour?:' 'Normalize  Recurrence Periods?:','Window-Size:','Distance Norm','Min-Lenght of Diag. Lines(DET):','Min-Lenght of Vert. Lines(LAM):'};
    titlevar = 'Parameters';
    dims = [1 35];
    definput = {'30','[1 100]','1','0','200','maximum','0','0'};
    answer = inputdlg(prompt,titlevar,dims,definput);
    cfg.en=str2num(answer{1});
    cfg.minmaxRecPD=str2num(answer{2});
    cfg.singlenei=str2num(answer{3});
    cfg.norm=str2num(answer{4});
    cfg.window=str2num(answer{5});
    cfg.metric=answer{6};
    cfg.minlengthdet=str2num(answer{7});
    cfg.minlengthlam=str2num(answer{8});
    cfg.dim=handles.dim(1);
    cfg.tau=handles.tau(1);
    cfg.plt=0;
    f = msgbox('Calculating!','Please wait....','warn');
    [ results ] = nta_wind_recfreq( handles.data(:,1),cfg );
    close(f)
    axes(handles.axes4);
    surf(results.time,[cfg.minmaxRecPD(1):cfg.minmaxRecPD(2)],results.resht);
    ylabel('Recurrence period [samples]','fontsize',12)
    xlabel('Time [samples]','fontsize',12);    
    axis tight
    shading interp;
    view([0 90])    
    colormap('jet')
    h=colorbar
    ylabel(h,'Amplitude [arb.]','fontsize',12)
    
    figure
    subplot(5,1,1)
    plot(handles.data(end-length(results.time)+1:end,1),'linewidth',3,'color','r')
    xlabel('Time [samples]','fontsize',12)
    title('Data') 
    subplot(5,1,2)
    plot(results.time,results.rr,'linewidth',3,'color','b')
    xlabel('Time [samples]','fontsize',12)
    title('RR') 
    subplot(5,1,3)
    plot(results.time,results.det,'linewidth',3,'color','b')
    xlabel('Time [samples]','fontsize',12)
    title('DET') 
    subplot(5,1,4)
    plot(results.time,results.lam,'linewidth',3,'color','b')
    xlabel('Time [samples]','fontsize',12)
    title('LAM') 
    subplot(5,1,5)
    plot(results.time,results.ratio,'linewidth',3,'color','b')
    xlabel('Time [samples]','fontsize',12)
    title('RATIO') 
    handles.results.wind_recfreq=results;
    if handles.recordstate==1
        handles.record{length(handles.record)+1}=['cfg=[];'];
        handles.record{length(handles.record)+1}=['cfg.en=' answer{1} ';'];
        handles.record{length(handles.record)+1}=['cfg.minmaxRecPD=' answer{2} ';'];
        handles.record{length(handles.record)+1}=['cfg.singlenei=' answer{3} ';'];
        handles.record{length(handles.record)+1}=['cfg.norm=' answer{4} ';'];
        handles.record{length(handles.record)+1}=['cfg.window=' answer{5} ';'];
        handles.record{length(handles.record)+1}=['cfg.metric=' '''' answer{6} ''';'];
        handles.record{length(handles.record)+1}=['cfg.minlengthdet=' answer{7} ';'];
        handles.record{length(handles.record)+1}=['cfg.minlengthlam=' answer{8} ';'];
        handles.record{length(handles.record)+1}=['cfg.dim=' num2str(handles.dim(1))  ';'];
        handles.record{length(handles.record)+1}=['cfg.tau=' num2str(handles.tau(1)) ';'];
        handles.record{length(handles.record)+1}='[ results ] = nta_wind_recfreq(data(:,1),cfg );';
    end
    
elseif handles.method==34
    axes(handles.axes4);
    prompt = {'Neighbourhood-Sizes:','Recurrence Rates:','Min-Lenght of Diag. Lines(DET):','Min-Lenght of Vert. Lines(LAM):','Min/Max of Recurrence Periods:','Only next Neighbour?:' 'Normalize  Recurrence Periods?:','Distance Norm'};
    titlevar = 'Parameters';
    dims = [1 35];
    definput = {'[0 0]','[5 5]','0','0','[1 500]','1','0','maximum'};
    answer = inputdlg(prompt,titlevar,dims,definput);
    cfg.ens=str2num(answer{1});
    cfg.rrs=str2num(answer{2});
    cfg.minlengthdet=str2num(answer{3});
    cfg.minlengthlam=str2num(answer{4});
    cfg.minmaxRecPD=str2num(answer{5});
    cfg.singlenei=str2num(answer{6});
    cfg.norm=str2num(answer{7});
    cfg.metric=answer{8};
    cfg.dims=handles.dim;
    cfg.taus=handles.tau;
    f = msgbox('Calculating!','Please wait....','warn');
    [ results ] = nta_jointrecurrenceplot( handles.data(:,1),handles.data(:,2),cfg );
    close(f)
    axes(handles.axes4);
    [r,c]                           =   size(results.sumdist);
    imagesc((1:c),(1:r),results.sumdist);
    colormap(gray);    
    set(gca,'XTick',0:floor((c+1)/10)+1:(c+1),'YTick',0:floor((c+1)/10)+1:(r+1),...
        'XLim',[0 c+1],'YLim',[0 c+1],'YDir','normal');
    xlabel('State i [samples]','fontsize',12)
    ylabel('State j [samples]','fontsize',12)
    Data=[results.rr,results.rpde,results.det,results.lam,results.ratio];
    set(handles.results_table,'data',Data,'ColumnName',{'RR','RPDE','DET','LAM','RATIO'});
    handles.results.jointrecurrenceplot=results;
    if handles.recordstate==1
        handles.record{length(handles.record)+1}=['cfg=[];'];
        handles.record{length(handles.record)+1}=['cfg.ens=' answer{1} ';'];
        handles.record{length(handles.record)+1}=['cfg.rrs=' answer{2} ';'];
        handles.record{length(handles.record)+1}=['cfg.minlengthdet=' answer{3} ';'];
        handles.record{length(handles.record)+1}=['cfg.minlengthlam=' answer{4} ';'];
        handles.record{length(handles.record)+1}=['cfg.minmaxRecPD=' answer{5} ';'];
        handles.record{length(handles.record)+1}=['cfg.singlenei=' answer{6} ';'];
        handles.record{length(handles.record)+1}=['cfg.norm=' answer{7} ';'];
        handles.record{length(handles.record)+1}=['cfg.metric=' '''' answer{8} ''';'];
        handles.record{length(handles.record)+1}=['cfg.dims=[' num2str(handles.dim)  '];'];
        handles.record{length(handles.record)+1}=['cfg.taus=[' num2str(handles.tau) '];'];
        handles.record{length(handles.record)+1}='[ results ] = nta_jointrecurrenceplot( data(:,1),data(:,2),cfg );';
    end
elseif handles.method==35
    axes(handles.axes4);
    prompt = {'Neighbourhood-Size:','Recurrence Rate:','Min-Lenght of Diag. Lines(DET):','Min-Lenght of Vert. Lines(LAM):','Min/Max of Recurrence Periods:','Only next Neighbour?:' 'Normalize  Recurrence Periods?:'};
    titlevar = 'Parameters';
    dims = [1 35];
    definput = {'0','5','0','0','[1 500]','1','0'};
    answer = inputdlg(prompt,titlevar,dims,definput);
    cfg.en=str2num(answer{1});
    cfg.rr=str2num(answer{2});
    cfg.minlengthdet=str2num(answer{3});
    cfg.minlengthlam=str2num(answer{4});
    cfg.minmaxRecPD=str2num(answer{5});
    cfg.singlenei=str2num(answer{6});
    cfg.norm=str2num(answer{7});
    cfg.dim=handles.dim(1);
    cfg.tau=handles.tau(1);
    f = msgbox('Calculating!','Please wait....','warn');
    [ results ] = nta_crossrecurrenceplot( handles.data(:,1),handles.data(:,2),cfg );
    close(f)
    axes(handles.axes4);
    [r,c]                           =   size(results.sumdist);
    imagesc((1:c),(1:r),results.sumdist);
    colormap(gray);    
    set(gca,'XTick',0:floor((c+1)/10)+1:(c+1),'YTick',0:floor((c+1)/10)+1:(r+1),...
        'XLim',[0 c+1],'YLim',[0 c+1],'YDir','normal');
    xlabel('State i [samples]','fontsize',12)
    ylabel('State j [samples]','fontsize',12)
    Data=[results.rr,results.rpde,results.det,results.lam,results.ratio];
    set(handles.results_table,'data',Data,'ColumnName',{'RR','RPDE','DET','LAM','RATIO'});
    handles.results.crossrecurrenceplot=results;
    if handles.recordstate==1
        handles.record{length(handles.record)+1}=['cfg=[];'];
        handles.record{length(handles.record)+1}=['cfg.en=' answer{1} ';'];
        handles.record{length(handles.record)+1}=['cfg.rr=' answer{2} ';'];
        handles.record{length(handles.record)+1}=['cfg.minlengthdet=' answer{3} ';'];
        handles.record{length(handles.record)+1}=['cfg.minlengthlam=' answer{4} ';'];
        handles.record{length(handles.record)+1}=['cfg.minmaxRecPD=' answer{5} ';'];
        handles.record{length(handles.record)+1}=['cfg.singlenei=' answer{6} ';'];
        handles.record{length(handles.record)+1}=['cfg.norm=' answer{7} ';'];
        handles.record{length(handles.record)+1}=['cfg.dim=' num2str(handles.dim(1))  ';'];
        handles.record{length(handles.record)+1}=['cfg.tau=' num2str(handles.tau(1)) ';'];
        handles.record{length(handles.record)+1}='[ results ] = nta_crossrecurrenceplot(data(:,1),data(:,2),cfg );';
    end
elseif handles.method==51
    axes(handles.axes4);
    prompt = {'Number of bins:'};
    titlevar = 'Parameters';
    dims = [1 35];
    definput = {'0'};
    answer = inputdlg(prompt,titlevar,dims,definput);
    cfg.numbin=str2num(answer{1});
    f = msgbox('Calculating!','Please wait....','warn');
    [ results ] = nta_entropybin( handles.data(:,1),cfg );
    close(f)
    bar(results.dist)
    xlabel('X [arb]','fontsize',12);
    ylabel('P(X) [arb.]','fontsize',12);
    Data=[results.Hx];
    set(handles.results_table,'data',Data,'ColumnName',{'Entropy'});
    handles.results.entropybin=results;
    if handles.recordstate==1
        handles.record{length(handles.record)+1}=['cfg=[];'];
        handles.record{length(handles.record)+1}=['cfg.numbin=' answer{1} ';'];
        handles.record{length(handles.record)+1}='[ results ] = nta_entropybin(data(:,1),cfg );';
    end
elseif handles.method==52
    axes(handles.axes4);
    prompt = {'Mass:','Distance Norm'};
    titlevar = 'Parameters';
    dims = [1 35];
    definput = {'4','maximum'};
    answer = inputdlg(prompt,titlevar,dims,definput);
    cfg.mass=str2num(answer{1});
    cfg.metric=answer{2};
    cfg.dim=handles.dim(1);
    cfg.tau=handles.tau(1);
    f = msgbox('Calculating!','Please wait....','warn');
    [ results ] = nta_entropykozachenko( handles.data(:,1),cfg );
    close(f)
    Data=[results.Hx];
    set(handles.results_table,'data',Data,'ColumnName',{'Entropy'});
    handles.results.entropybin=results;
    if handles.recordstate==1
        handles.record{length(handles.record)+1}=['cfg=[];'];
        handles.record{length(handles.record)+1}=['cfg.mass=' answer{1} ';'];
        handles.record{length(handles.record)+1}=['cfg.metric=' '''' answer{2} ''';'];
        handles.record{length(handles.record)+1}=['cfg.dim=' num2str(handles.dim(1))  ';'];
        handles.record{length(handles.record)+1}=['cfg.tau=' num2str(handles.tau(1)) ';'];
        handles.record{length(handles.record)+1}='[ results ] = nta_entropykozachenko(data(:,1),cfg );';
    end
elseif handles.method==53
    axes(handles.axes4);
    prompt = {'Number of bins:'};
    titlevar = 'Parameters';
    dims = [1 35];
    definput = {'0'};
    answer = inputdlg(prompt,titlevar,dims,definput);
    cfg.numbin=str2num(answer{1});
    f = msgbox('Calculating!','Please wait....','warn');
    [ results ] = nta_MIbin( handles.data(:,1),handles.data(:,2),cfg );
    close(f)
    imagesc(results.jp);
    Data=[results.MI];
    set(handles.results_table,'data',Data,'ColumnName',{'MI'});
    handles.results.MIbin=results;
    if handles.recordstate==1
        handles.record{length(handles.record)+1}=['cfg=[];'];
        handles.record{length(handles.record)+1}=['cfg.numbin=' answer{1} ';'];
        handles.record{length(handles.record)+1}=' [ results ] = nta_MIbin(data(:,1),data(:,2),cfg );';
    end
elseif handles.method==54
    axes(handles.axes4);
    prompt = {'mass:','Dimensions:','Taus:','Distance Norm:'};
    titlevar = 'Parameters';
    dims = [1 35];
    definput = {'4','3 3', '10 10','maximum'};
    answer = inputdlg(prompt,titlevar,dims,definput);
    cfg.mass=str2num(answer{1});
    cfg.dims=str2num(answer{2});
    cfg.taus=str2num(answer{3});
    cfg.metric=answer{4};
    f = msgbox('Calculating!','Please wait....','warn');
    [ results ] = nta_MIkraskov( handles.data(:,1),handles.data(:,2),cfg );
    close(f)
    Data=[results.MI];
    set(handles.results_table,'data',Data,'ColumnName',{'MI'});
    handles.results.MIkraskov=results;
    if handles.recordstate==1
        handles.record{length(handles.record)+1}=['cfg=[];'];
        handles.record{length(handles.record)+1}=['cfg.mass=' answer{1} ';'];
        handles.record{length(handles.record)+1}=['cfg.dims=[' answer{2}  '];'];
        handles.record{length(handles.record)+1}=['cfg.taus=[' answer{3} '];'];
        handles.record{length(handles.record)+1}=['cfg.metric=' '''' answer{4} ''';'];
        handles.record{length(handles.record)+1}='[ results ] = nta_MIkraskov( data(:,1),ata(:,2),cfg );';
    end
elseif handles.method==55
    axes(handles.axes4);
    prompt = {'Number of bins:','Maximum lag?:'};
    titlevar = 'Parameters';
    dims = [1 35];
    definput = {'10','100'};
    answer = inputdlg(prompt,titlevar,dims,definput);
    cfg.numbin=str2num(answer{1});
    cfg.maxlag=str2num(answer{2});
    cfg.plt=0;
    f = msgbox('Calculating!','Please wait....','warn');
    [ results ] = nta_amutibin( handles.data(:,1),cfg );
    close(f)
    plot(results.ami,'linewidth',3,'color','r')
    xlabel('Delay [samples]','fontsize',12)
    ylabel('Auto-mutual information [bits]','fontsize',12)
    Data=[results.firstmin];
    set(handles.results_table,'data',Data,'ColumnName',{'First Min.'});
    handles.results.amutibin=results;
    if handles.recordstate==1
        handles.record{length(handles.record)+1}=['cfg=[];'];
        handles.record{length(handles.record)+1}=['cfg.numbin=' answer{1} ';'];
        handles.record{length(handles.record)+1}=['cfg.maxlag=' answer{2} ';'];
        handles.record{length(handles.record)+1}='[ results ] = nta_amutibin(data(:,1),cfg );;';
    end
elseif handles.method==56
    axes(handles.axes4);
    prompt = {'Mass:','Maximum lag?:','Distance Norm:'};
    titlevar = 'Parameters';
    dims = [1 35];
    definput = {'4','100','maximum'};
    answer = inputdlg(prompt,titlevar,dims,definput);
    cfg.mass=str2num(answer{1});
    cfg.maxlag=str2num(answer{2});
    cfg.metric=answer{3};
    cfg.dim=handles.dim(1);
    cfg.tau=handles.tau(1);
    cfg.plt=0;
    f = msgbox('Calculating!','Please wait....','warn');
    [ results ] = nta_amutiembknn( handles.data(:,1),cfg );
    close(f)
    plot(results.embAMI,'linewidth',3,'color','r')
    xlabel('Delay [samples]','fontsize',12)
    ylabel('Auto-mutual information [nats]','fontsize',12)
    Data=[results.firstmin,results.AIS];
    set(handles.results_table,'data',Data,'ColumnName',{'First Min.','AIS'});
    handles.results.amutibin=results;
    if handles.recordstate==1
        handles.record{length(handles.record)+1}=['cfg=[];'];
        handles.record{length(handles.record)+1}=['cfg.mass=' answer{1} ';'];
        handles.record{length(handles.record)+1}=['cfg.maxlag=' answer{2} ';'];
        handles.record{length(handles.record)+1}=['cfg.metric=' '''' answer{3} ''';'];
        handles.record{length(handles.record)+1}=['cfg.dim=[' num2str(handles.dim(1))  '];'];
        handles.record{length(handles.record)+1}=['cfg.tau=[' num2str(handles.tau(1)) '];'];
        handles.record{length(handles.record)+1}='[ results ] = nta_amutiembknn(data(:,1),cfg );';
    end
 elseif handles.method==57
    axes(handles.axes4);
    prompt = {'Mass:','Distance Norm:'};
    titlevar = 'Parameters';
    dims = [1 35];
    definput = {'4','maximum'};
    answer = inputdlg(prompt,titlevar,dims,definput);
    cfg.mass=str2num(answer{1});   
    cfg.metric=answer{2};
    cfg.dim=handles.dim(1);
    cfg.tau=handles.tau(1);
    cfg.plt=0;
    f = msgbox('Calculating!','Please wait....','warn');
    [ results ] = nta_AIS( handles.data(:,1),cfg);
    close(f)
    plot(results.lAIS )
    xlabel('Time [samples]','fontsize',12)
    ylabel('lAIS [nats]','fontsize',12)
    Data=[results.AIS];
    set(handles.results_table,'data',Data,'ColumnName',{'AIS'});
    handles.results.AIS=results;
    if handles.recordstate==1
        handles.record{length(handles.record)+1}=['cfg=[];'];
        handles.record{length(handles.record)+1}=['cfg.mass=' answer{1} ';'];       
        handles.record{length(handles.record)+1}=['cfg.metric=' '''' answer{3} ''';'];
        handles.record{length(handles.record)+1}=['cfg.dim=[' num2str(handles.dim(1))  '];'];
        handles.record{length(handles.record)+1}=['cfg.tau=[' num2str(handles.tau(1)) '];'];
        handles.record{length(handles.record)+1}='[ results ] = nta_AIS(data(:,1),cfg );';
    end
    
elseif handles.method==71
    cfg.tau=handles.tau(1);
    cfg.dim=handles.dim(1);
    axes(handles.axes4);
    f = msgbox('Calculating!','Please wait....','warn');
    [result]=nta_phasespace(handles.data(:,1),cfg);
    close(f)
    if cfg.dim==3
        plot3(result.embTS(:,1),result.embTS(:,2),result.embTS(:,3))
        xlabel('X-dim [samples]', 'fontsize',12);
        ylabel('Y-dim [samples]', 'fontsize',12);
        zlabel('Z-dim [samples]', 'fontsize',12);
    elseif cfg.dim==2
        plot(result.embTS(:,1),result.embTS(:,2))
        xlabel('X-dim [samples]', 'fontsize',12);
        xlabel('Y-dim [samples]', 'fontsize',12);
    end
    handles.results.embedding=result;
    if handles.recordstate==1
        handles.record{length(handles.record)+1}=['cfg=[];'];
        handles.record{length(handles.record)+1}=['cfg.dim=' num2str(handles.dim(1))  ';'];
        handles.record{length(handles.record)+1}=['cfg.tau=' num2str(handles.tau(1)) ';'];
        handles.record{length(handles.record)+1}='[result]=nta_phasespace(data(:,1),cfg);';
    end
elseif handles.method==72
    axes(handles.axes4);
    prompt = {'Distance Norm:'};
    titlevar = 'Parameters';
    dims = [1 35];
    definput = {'maximum'};
    answer = inputdlg(prompt,titlevar,dims,definput);
    if strcmp(answer{1},'maximum')==1
        v=2;
    elseif strcmp(answer{1},'euclidean')==1
        v=1;
    end
    f = msgbox('Calculating!','Please wait....','warn');
    neighnum=nta_neighsearch( handles.results.embedding.embTS,[1:length(handles.results.embedding.embTS)]',v);
    close(f)
    imagesc(flipud(neighnum))
    if handles.recordstate==1
        handles.record{length(handles.record)+1}=['cfg=[];'];
        handles.record{length(handles.record)+1}=['neighnum=nta_neighsearch( result.embTS,[1:length(result.embTS)]'',' num2str(v) ');'];
        handles.record{length(handles.record)+1}=['imagesc(flipud(neighnum))'];
    end
elseif handles.method==73
    f = msgbox('Calculating!','Please wait....','warn');
    [ Rmm] = nta_autocorr( handles.data(:,1),round(length(handles.data)./2));
    close(f)
    axes(handles.axes4);
    plot(Rmm,'linewidth',3,'color','r');
    xlabel('Delay [samples]','fontsize',12);
    ylabel('Auto-correlation [arb.]','fontsize',12);
    axis tight
    Data=find(Rmm<0,1,'first');
    set(handles.results_table,'data',Data,'ColumnName',{'1. Zero cross.'});
    handles.results.autocorr=Rmm;
    if handles.recordstate==1
        handles.record{length(handles.record)+1}=['cfg=[];'];
        handles.record{length(handles.record)+1}=['[ Rmm,~,~ ] = nta_autocorr(data(:,1),round(length(data(:,1))./2));'];
        handles.record{length(handles.record)+1}=['plot(Rmm);'];
    end
end

end

