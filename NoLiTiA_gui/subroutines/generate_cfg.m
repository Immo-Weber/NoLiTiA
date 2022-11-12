function [handles]=generate_cfg(handles)
for i=1:length(handles.methodnames)
    cfg=[];
    cfg.verbose=0;
    if strcmp(handles.methodnames{i},'nta_corrdim')==1
        prompt = {'Min/Max Neighbourhood-Sizes:','Number of Query Points','Theiler-Window:','Number of Points to Use for Local Slope Estimation:'};
        title = 'Parameters: corrdim';
        dims = [1 50];
        definput = {'[1 100]','10','0','2'};
        answer = inputdlg(prompt,title,dims,definput);
        cfg.ens=str2num(answer{1});
        cfg.nr=str2num(answer{2});
        cfg.th=str2num(answer{3});
        cfg.resl=str2num(answer{4});
        cfg.plt=0;
        if isfield(handles,'dim')==1 & isfield(handles,'tau')==1
            cfg.dim=handles.dim;%(j,qq);
            cfg.tau=handles.tau;%(j,qq);
            
            for j=1:length(handles.Data)

                handles.cfg{i}{j}=cfg;%cfgcell;
            end
            
        else
            msgbox('No embedding parameters defined!','Error');
        end
    elseif strcmp(handles.methodnames{i},'nta_lya')==1
        prompt = {'Method:','Neighbourhood-Size:','Number of Query Points','Theiler-Window:','Number of Iterations:','Number of Points to Use for Local Slope Estimation:'};
        title = 'Parameters: lya';
        dims = [1 50];
        definput = {'Kantz','10','500','0','100','2'};
        answer = inputdlg(prompt,title,dims,definput);
        cfg.method=answer{1};
        cfg.en=str2num(answer{2});
        cfg.numran=str2num(answer{3});
        cfg.th=str2num(answer{4});
        cfg.it=str2num(answer{5});
        cfg.resl=str2num(answer{6});
        cfg.plt=0;
        if isfield(handles,'dim')==1 & isfield(handles,'tau')==1
            cfg.dim=handles.dim;
                    cfg.tau=handles.tau;
            
            for j=1:length(handles.Data)
                
                    
                
                handles.cfg{i}{j}=cfg;
            end
            
        else
            msgbox('No embedding parameters defined!','Error');
        end
    elseif strcmp(handles.methodnames{i},'nta_hurst')==1
        prompt = {'Max. Number of Windows:'};
        title = 'Parameters: hurst';
        dims = [1 50];
        definput = {'10'};
        answer = inputdlg(prompt,title,dims,definput);
        cfg.scale=str2num(answer{1});
        cfg.plt=0;
        for j=1:length(handles.Data)
%             cfgcell=cell(1,size(handles.Data{j},2));
%             [cfgcell{:}]=deal(cfg);
            handles.cfg{i}{j}=cfg;%cfgcell;
        end
    elseif strcmp(handles.methodnames{i},'nta_dfa')==1
        prompt = {'Min/Max. Number of Windows:'};
        title = 'Parameters: dfa';
        dims = [1 50];
        definput = {'[2 100]'};
        answer = inputdlg(prompt,title,dims,definput);
        cfg.scales=str2num(answer{1});
        cfg.plt=0;
        for j=1:length(handles.Data)

            handles.cfg{i}{j}=cfg;
        end
    elseif strcmp(handles.methodnames{i},'nta_fnn')==1
        prompt = {'Threshold Rtol:','Threshold Atol:','Threshold Minimum:'};
        title = 'Parameters: fnn';
        dims = [1 50];
        definput = {'10','2','1'};
        answer = inputdlg(prompt,title,dims,definput);
        cfg.Rtol=str2num(answer{1});
        cfg.Atol=str2num(answer{2});
        cfg.thr=str2num(answer{3});
        cfg.plt=0;
        if isfield(handles,'tau')==1
            cfg.tau=handles.tau;
            cfg.dim=handles.dim;
            
            for j=1:length(handles.Data)                
                
                  
                
                handles.cfg{i}{j}=cfg;
            end
            
        else
            msgbox('No embedding parameters defined!','Error');
        end
    elseif strcmp(handles.methodnames{i},'nta_ragwitz')==1
        prompt = {'Mode:','Mass:','Prediction Horizon:','Distance Norm:'};
        title = 'Parameters: ragwitz';
        dims = [1 50];
        definput = {'multi','4','1','maximum'};
        answer = inputdlg(prompt,title,dims,definput);
        cfg.mode=answer{1};
        cfg.mass=str2num(answer{2});
        cfg.hor=str2num(answer{3});
        cfg.metric=answer{4};
        cfg.taus=handles.tau;
        cfg.dims=handles.dim;
        cfg.plt=0;
        for j=1:length(handles.Data)
            
            handles.cfg{i}{j}=cfg;
        end
    elseif strcmp(handles.methodnames{i},'nta_spacetimesep')==1
        prompt = {'Number of Classes:','Maximum Temporal Distance:','Distance Norm:'};
        title = 'Parameters: spacetimesep';
        dims = [1 50];
        definput = {'4','100','maximum'};
        answer = inputdlg(prompt,title,dims,definput);
        cfg.nr=str2num(answer{1});
        cfg.maxlag=str2num(answer{2});
        cfg.metric=answer{3};
        cfg.plt=0;
        if isfield(handles,'dim')==1 & isfield(handles,'tau')==1
            cfg.dim=handles.dim;
             cfg.tau=handles.tau;
            
            for j=1:length(handles.Data)
                
                handles.cfg{i}{j}=cfg;
            end
            
        else
            msgbox('No embedding parameters defined!','Error');
        end
    elseif strcmp(handles.methodnames{i},'nta_timerev')==1
        prompt = {'Lag:','Number of Surrogates:','Surrogate Mode:'};
        title = 'Parameters: timerev';
        dims = [1 50];
        definput = {'1','100','2'};
        answer = inputdlg(prompt,title,dims,definput);
        cfg.lag=str2num(answer{1});
        cfg.numsurr=str2num(answer{2});
        cfg.surrmode=str2num(answer{3});
        cfg.plt=0;
        for j=1:length(handles.Data)

            handles.cfg{i}{j}=cfg;
        end
    elseif strcmp(handles.methodnames{i},'nta_upo')==1
        prompt = {'Number of Iterations:','Number of Bins:','Number of Surrogates:','Surrogate Mode:'};
        title = 'Parameters: upo';
        dims = [1 50];
        definput = {'100','[100 100]','0','2'};
        answer = inputdlg(prompt,title,dims,definput);
        cfg.numit=str2num(answer{1});
        cfg.bins=str2num(answer{2});
        cfg.numsurr=str2num(answer{3});
        cfg.surrmode=str2num(answer{4});
        cfg.plt=0;
        if isfield(handles,'tau')==1
            cfg.tau=handles.tau;
            
            for j=1:length(handles.Data)
                
                             
                handles.cfg{i}{j}=cfg;
            end
            
        else
            msgbox('No embedding parameters defined!','Error');
        end
    elseif strcmp(handles.methodnames{i},'nta_recurrenceplot')==1
        prompt = {'Neighbourhood-Size:','Recurrence Rate:','Min-Lenght of Diag. Lines(DET):','Min-Lenght of Vert. Lines(LAM):','Min/Max of Recurrence Periods:','Only next Neighbour?:' 'Normalize  Recurrence Periods?:','Distance Norm:'};
        title = 'Parameters: recurrenceplot';
        dims = [1 50];
        definput = {'0','5','0','0','[1 1000]','1','0','maximum'};
        answer = inputdlg(prompt,title,dims,definput);
        cfg.en=str2num(answer{1});
        cfg.rr=str2num(answer{2});
        cfg.minlengthdet=str2num(answer{3});
        cfg.minlengthlam=str2num(answer{4});
        cfg.minmaxRecPD=str2num(answer{5});
        cfg.singlenei=str2num(answer{6});
        cfg.norm=str2num(answer{7});
        cfg.metric=answer{8};
        cfg.plt=0;
        if isfield(handles,'dim')==1 & isfield(handles,'tau')==1
            cfg.dim=handles.dim;
                    cfg.tau=handles.tau;
            
            for j=1:length(handles.Data)
                
                handles.cfg{i}{j}=cfg;
            end
            
        else
            msgbox('No embedding parameters defined!','Error');
        end
    elseif strcmp(handles.methodnames{i},'nta_recfreq_en_scan')==1
        prompt = {'Range of Neighbourhood-Sizes:','Min/Max of Recurrence Periods:','Only next Neighbour?:' 'Normalize  Recurrence Periods?:','Distance Norm:'};
        title = 'Parameters: recfrec_en_scan';
        dims = [1 50];
        definput = {'[1 1 101]','[1 1000]','1','0','maximum'};
        answer = inputdlg(prompt,title,dims,definput);
        cfg.ens=str2num(answer{1});
        cfg.minmaxRecPD=str2num(answer{2});
        cfg.singlenei=str2num(answer{3});
        cfg.norm=str2num(answer{4});
        cfg.metric=answer{5};
        cfg.plt=0;
        if isfield(handles,'dim')==1 & isfield(handles,'tau')==1
            cfg.dim=handles.dim;
                    cfg.tau=handles.tau;
            
            for j=1:length(handles.Data)
                
                handles.cfg{i}{j}=cfg;
            end
            
        else
            msgbox('No embedding parameters defined!','Error');
        end
    elseif strcmp(handles.methodnames{i},'nta_wind_recfreq')==1
        prompt = {'Neighbourhood-Size:','Min/Max of Recurrence Periods:','Only next Neighbour?:' 'Normalize  Recurrence Periods?:','Window-Size:','Distance Norm:','Min-Lenght of Diag. Lines(DET):','Min-Lenght of Vert. Lines(LAM):','Sampling Frequency:'};
        title = 'Parameters: wind_recfreq';
        dims = [1 50];
        definput = {'30','[1 100]','1','0','200','maximum','0','0','20'};
        answer = inputdlg(prompt,title,dims,definput);
        cfg.en=str2num(answer{1});
        cfg.minmaxRecPD=str2num(answer{2});
        cfg.singlenei=str2num(answer{3});
        cfg.norm=str2num(answer{4});
        cfg.window=str2num(answer{5});
        cfg.metric=answer{6};
        cfg.minlengthdet=str2num(answer{7});
        cfg.minlengthlam=str2num(answer{8});
        cfg.fs=str2num(answer{9});
        cfg.plt=0;
        if isfield(handles,'dim')==1 & isfield(handles,'tau')==1
            cfg.dim=handles.dim;
                    cfg.tau=handles.tau;
            
            for j=1:length(handles.Data)
                
                handles.cfg{i}{j}=cfg;
            end
            
        else
            msgbox('No embedding parameters defined!','Error');
        end
    elseif strcmp(handles.methodnames{i},'nta_jointrecurrenceplot')==1
        prompt = {'Channels:','Neighbourhood-Sizes:','Recurrence Rates:','Min-Lenght of Diag. Lines(DET):','Min-Lenght of Vert. Lines(LAM):','Min/Max of Recurrence Periods:','Only next Neighbour?:' 'Normalize  Recurrence Periods?:','Distance Norm:'};
        title = 'Parameters: jointrecurrenceplot';
        dims = [1 50];
        definput = {'[1 2]','[0 0]','[5 5]','0','0','[1 1000]','1','0','maximum'};
        answer = inputdlg(prompt,title,dims,definput);
        cfg.channels=str2num(answer{1});
        if cfg.channels==0
            cfg.channels=nchoosek(1:size(handles.Data{1}{1},2),2);
        end
        cfg.ens=str2num(answer{2});
        cfg.rrs=str2num(answer{3});
        cfg.minlengthdet=str2num(answer{4});
        cfg.minlengthlam=str2num(answer{5});
        cfg.minmaxRecPD=str2num(answer{6});
        cfg.singlenei=str2num(answer{7});
        cfg.norm=str2num(answer{8});
        cfg.metric=answer{9};
        if isfield(handles,'dim')==0 & isfield(handles,'tau')==0
            msgbox('No embedding parameters defined!','Error');
        else
            cfg.taus=handles.tau;
            cfg.dims=handles.dim;
        end
        cfg.plt=0;
        for j=1:length(handles.Data)
        handles.cfg{i}{j}=cfg;
        end
        
    elseif strcmp(handles.methodnames{i},'nta_crossrecurrenceplot')==1
        prompt = {'Channels:','Neighbourhood-Size:','Recurrence Rate:','Min-Lenght of Diag. Lines(DET):','Min-Lenght of Vert. Lines(LAM):','Min/Max of Recurrence Periods:','Only next Neighbour?:' 'Normalize  Recurrence Periods?:'};
        title = 'Parameters: crossrecurrenceplot';
        dims = [1 50];
        definput = {'[1 2]','0','5','0','0','[1 1000]','1','0'};
        answer = inputdlg(prompt,title,dims,definput);
        cfg.channels=str2num(answer{1});
        if cfg.channels==0
            cfg.channels=nchoosek(1:size(handles.Data{1}{1},2),2);
        end
        cfg.en=str2num(answer{2});
        cfg.rr=str2num(answer{3});
        cfg.minlengthdet=str2num(answer{4});
        cfg.minlengthlam=str2num(answer{5});
        cfg.minmaxRecPD=str2num(answer{6});
        cfg.singlenei=str2num(answer{7});
        cfg.norm=str2num(answer{8});
        if isfield(handles,'dim')==0 & isfield(handles,'tau')==0
            msgbox('No embedding parameters defined!','Error');
        else
            cfg.tau=handles.tau;
            cfg.dim=handles.dim;
        end
        cfg.plt=0;
        for j=1:length(handles.Data)
        handles.cfg{i}{j}=cfg;
        end
    elseif strcmp(handles.methodnames{i},'nta_entropybin')==1
        prompt = {'Number of bins:'};
        title = 'Parameters: entropybin';
        dims = [1 50];
        definput = {'0'};
        answer = inputdlg(prompt,title,dims,definput);
        cfg.numbin=str2num(answer{1});
        cfg.plt=0;
        for j=1:length(handles.Data)

            handles.cfg{i}{j}=cfg;%cfgcell;
        end
    elseif strcmp(handles.methodnames{i},'nta_entropykozachenko')==1
        prompt = {'Mass:','Distance Norm:'};
        title = 'Parameters: entropykozachenko';
        dims = [1 50];
        definput = {'4','maximum'};
        answer = inputdlg(prompt,title,dims,definput);
        cfg.mass=str2num(answer{1});
        cfg.metric=answer{2};
        cfg.plt=0;
        if isfield(handles,'dim')==1 & isfield(handles,'tau')==1
            cfg.dim=handles.dim;
            cfg.tau=handles.tau;
            
            for j=1:length(handles.Data)
                
                handles.cfg{i}{j}=cfg;
            end
            
        else
            msgbox('No embedding parameters defined!','Error');
        end
    elseif strcmp(handles.methodnames{i},'nta_MIbin')==1
        prompt = {'Channels:','Number of bins:'};
        title = 'Parameters';
        dims = [1 50];
        definput = {'[1 2]','0'};
        answer = inputdlg(prompt,title,dims,definput);
        cfg.channels=str2num(answer{1});
        if cfg.channels==0
            cfg.channels=nchoosek(1:size(handles.Data{1}{1},2),2);
        end
        cfg.numbin=str2num(answer{2});
        cfg.plt=0;
        for j=1:length(handles.Data)
        handles.cfg{i}{j}=cfg;
        end
    elseif strcmp(handles.methodnames{i},'nta_amutibin')==1
        prompt = {'Number of bins:','Maximum lag?:'};
        title = 'Parameters: amutibin';
        dims = [1 50];
        definput = {'10','100'};
        answer = inputdlg(prompt,title,dims,definput);
        cfg.numbin=str2num(answer{1});
        cfg.maxlag=str2num(answer{2});
        cfg.plt=0;
        for j=1:length(handles.Data)

            handles.cfg{i}{j}=cfg;%cfgcell;
        end
    elseif strcmp(handles.methodnames{i},'nta_MIkraskov')==1
        prompt = {'Channels:';'Mass:';'Distance Norm:'};
        title = 'Parameters';
        dims = [1 50];
        definput = {'[1 2]','4','maximum'};
        answer = inputdlg(prompt,title,dims,definput);
        cfg.channels=str2num(answer{1});
        if cfg.channels==0
            cfg.channels=nchoosek(1:size(handles.Data{1}{1},2),2);
        end
        cfg.mass=str2num(answer{2});
        cfg.metric=answer{3};
        if isfield(handles,'dim')==0 & isfield(handles,'tau')==0
            msgbox('No embedding parameters defined!','Error');
        else
            cfg.dims=handles.dim;
            cfg.taus=handles.tau;
        end
        cfg.plt=0;
        for j=1:length(handles.Data)
        handles.cfg{i}{j}=cfg;
        end
    elseif strcmp(handles.methodnames{i},'nta_amutiembknn')==1
        prompt = {'Mass:','Maximum lag?:','Distance Norm:'};
        title = 'Parameters: amutiembknn';
        dims = [1 50];
        definput = {'4','100','maximum'};
        answer = inputdlg(prompt,title,dims,definput);
        cfg.mass=str2num(answer{1});
        cfg.maxlag=str2num(answer{2});
        cfg.metric=answer{3};
        cfg.plt=0;
        if isfield(handles,'dim')==1 & isfield(handles,'tau')==1
            cfg.dim=handles.dim;
                    cfg.tau=handles.tau;
            
            for j=1:length(handles.Data)
                
                handles.cfg{i}{j}=cfg;
            end
            
        else
            msgbox('No embedding parameters defined!','Error');
        end
    elseif strcmp(handles.methodnames{i},'nta_AIS')==1
        prompt = {'Mass:','Distance Norm:'};
        title = 'Parameters: AIS';
        dims = [1 50];
        definput = {'4','maximum'};
        answer = inputdlg(prompt,title,dims,definput);
        cfg.mass=str2num(answer{1});
        cfg.metric=answer{2};
        cfg.plt=0;
        if isfield(handles,'dim')==1 & isfield(handles,'tau')==1
            cfg.dim=handles.dim;
                    cfg.tau=handles.tau;
            
            for j=1:length(handles.Data)
                
                handles.cfg{i}{j}=cfg;
            end
            
        else
            msgbox('No embedding parameters defined!','Error');
        end
   elseif strcmp(handles.methodnames{i},'nta_waveform_shape')==1
        prompt = {'Frequency:','Fs:', 'Width:'};
        title = 'Parameters: Waveform Shape';
        dims = [1 50];
        definput = {'[13 30]','1000', '5'};
        answer = inputdlg(prompt,title,dims,definput);
        cfg.freq=str2num(answer{1});
        cfg.fs=str2num(answer{2});
        cfg.width=str2num(answer{3});
        for j=1:length(handles.Data)
            handles.cfg{i}{j}=cfg;
        end
    end
    
end