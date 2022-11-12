function [ results_batch ] = batch_nolitia(func_name,cfg,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This function can be used to pass multiple datasets to NoLiTiA-functions.
%Input data can either be a NXM (N=samples or time points, M=channel or dataset)
%double matrix, or a 1xM cell array.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h2 = waitbar(0,'Inner Batch Job Processing...');
counter=1;
data1=varargin{1};
N=length(data1);
if iscell(data1)==0
    M=size(data1,1);
    N=size(data1,2);
    data1=mat2cell(data1,M,ones(N,1));
    N=size(data1,2);
    
elseif iscell(data1)==1
    
    for i=1:N
        data1{i}=data1{i}';
        N=size(data1{i},2);
        M=size(data1{i},1);
        data1{i}=mat2cell(data1{i},M,ones(N,1));
    end
    
    
    if ismember(func_name,{'MIbin' 'MIkraskov' 'jointrecurrenceplot' 'crossrecurrenceplot'})==0
        
        if iscell(cfg)==0
            cfgcell=cell(1,N);
            [cfgcell{:}]=deal(cfg);
            for trials=1:length(data1)
                for channels=1:length(data1{trials})
                    cfg_new{trials}{channels}=cfgcell{1};
                    if isfield(cfg_new{trials}{channels},'dim') & iscell(cfg_new{trials}{channels}.dim)
                        cfg_new{trials}{channels}.dim=cfgcell{channels}.dim{1}(trials,channels);
                        cfg_new{trials}{channels}.tau=cfgcell{channels}.tau{1}(trials,channels);
                    end
                end
            end
        end
        
        for j=1:length(data1)
            results_batch{j}=eval(['cellfun(@' func_name ',data1{j},cfg_new{j},''UniformOutput'',false)']);
            waitbar(counter/length(data1))
            counter=counter+1;
        end
        
        
    else
        
        if iscell(cfg)==0
            cfgcell=cell(1,N);
            [cfgcell{:}]=deal(cfg);
            for trials=1:length(data1)
                for comb=1:size(cfgcell{1}.channels,1)
                    cfg_new{trials}{comb}=cfgcell{1};
                    if isfield(cfg_new{trials}{comb},'dim') & iscell(cfg_new{trials}{comb}.dim)
                        cfg_new{trials}{comb}.dim=cfgcell{comb}.dim{1}(trials,comb);
                        cfg_new{trials}{comb}.tau=cfgcell{comb}.tau{1}(trials,comb);
                    elseif isfield(cfg_new{trials}{comb},'dims') & iscell(cfg_new{trials}{comb}.dims)
                        cfg_new{trials}{comb}.dims=[cfgcell{comb}.dims{1}(trials,cfgcell{1}.channels(comb,1)) cfgcell{comb}.dims{1}(trials,cfgcell{1}.channels(comb,2))];
                        cfg_new{trials}{comb}.taus=[cfgcell{comb}.taus{1}(trials,cfgcell{1}.channels(comb,1)) cfgcell{comb}.dims{1}(trials,cfgcell{1}.channels(comb,2))];
                    end
                end
            end
        end
        
        for j=1:length(data1)
            results_batch{j}=eval(['cellfun(@' func_name ',data1{j}(cfg_new{j}{1}.channels(:,1)),data1{j}(cfg_new{j}{1}.channels(:,2)),cfg_new{j},''UniformOutput'',false)']);
        end
    end
end

close(h2)


