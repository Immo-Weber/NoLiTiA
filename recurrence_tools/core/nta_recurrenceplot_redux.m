function [ results ] = nta_recurrenceplot_redux( data,cfg )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Calculates a recurrence plot.
%   data: input data, 1xN double 
%CONFIGURATION STRUCTURE:
%   cfg.tau: embedding delay, 1x1, int, default: 0 (optimization)
%   cfg.dim: embedding dimension, 1x1, int, default: 2
%   cfg.en: neighbourhood-size in % std of data, 1x1,  double, default: 0
%   cfg.rr: recurrence rate in % of total possible rr, 1x1, double, default: 5
%   cfg.metric: distance norm 'euclidean' or 'maximum', char, default: 'maximum'
%   cfg.plt: plot results yes/no [1/0], 1x1, int, default: 1
%   cfg.verbose: verbose level [1/0], 1x1, int, default: 1
%OUTPUT:
%   results.cfg: configuration structure
%DEPENDENCIES:
%   amutibin, phasespace, neighsearch
%Author: Immo Weber, 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isfield(cfg,'verbose')==1
    verbose=cfg.verbose;
else
    verbose=1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isfield(cfg,'dim')==1
dim=cfg.dim;
else
    dim=2;
    if verbose==1
    disp('No embedding dimension specified. Assigning default: 2')
    end
end
if isfield(cfg,'tau')==1
tau=cfg.tau;
else
    tau=0;
    if verbose==1
    disp('No embedding delay specified. Assigning default: 0')
    end
end
if isfield(cfg,'en')==1
en=cfg.en;
else
    en=0;
    if verbose==1
    disp('No neighbourhood size specified. Assigning default: 0')
    end
end
if isfield(cfg,'rr')==1
rr=cfg.rr;
else
    rr=5;
    if verbose==1
    disp('No recurrence rate specified. Assigning default: 5')
    end
end
if isfield(cfg,'metric')==1
if strcmp(cfg.metric,'euclidean')==1    
metric=1;
elseif strcmp(cfg.metric,'maximum')==1    
metric=2;
end
else
    metric=2;
    if verbose==1
      disp('No distance norm specified! Assigning default: maximum')
    end
end
if isfield(cfg,'plt')==1
plt=cfg.plt;
else
    plt=1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
results=[];

[data,nodata]=checkdatainteg(data,cfg,verbose);
if nodata==1
    return
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if tau==0
    cfgami.numbin=10;
    cfgami.time=length(data)/2;
    cfgami.plt=0;
    cfgami.verbose=verbose;
    [ resultsami ] = nta_amutibin( data,cfgami);
    tau=resultsami.firstmin;
    if verbose==1
    disp(['The best lag is probably' ' ' num2str(tau)])
    end
end
%%%Phase-Space reconstruction%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cfgs.dim=dim;
cfgs.tau=tau;
results=nta_phasespace(data,cfgs);                 
space=results.embTS;
%%%calculate distance matrix%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N=length(space);
mat=[];
sumdist=zeros(N,N);
sumdist=nta_neighsearch(space,[1:N]',metric);
distances=sumdist;
%%%calculate neighbourhood-sizes%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if rr~=0
    sortdist=sort(sumdist(:));
    indtemp=(rr/100)*(N^2);
    en=sortdist(floor(indtemp));
else
    groesse=std(data);%max(sumdist(:));
    en=(en*groesse)/100;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sumdist= sumdist>en;
N=length(sumdist);
n1=sum(sum(sumdist==0));
rd=100*(n1/(N)^2);
if plt==1
    imagesc((1:N),(1:N),sumdist);
    colormap(gray);
    axis square
    set(gca,'XTick',0:floor((N+1)/10)+1:(N+1),'YTick',0:floor((N+1)/10)+1:(N+1),...
        'XLim',[0 N+1],'YLim',[0 N+1],'YDir','normal');
    xlabel('State i [arb.]','fontsize',12)
    ylabel('State j [arb.]','fontsize',12)
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
results.cfg=cfg;
results.rr=rd;
results.sumdist=sumdist;
end

