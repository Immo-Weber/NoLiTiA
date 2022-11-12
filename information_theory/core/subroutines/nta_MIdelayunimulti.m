function [results]=nta_MIdelayunimulti(data,cfg)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Estimation of Mutual information between current time points and a lagged 
%past state using a nearest neighbour estimator (Kraskov, 2004). For a
%lag=1 the function computes the active information storage.
%   data: input data, 1xN, double
%CONFIGURATION STRUCTURE:
%   cfg.dim: embedding dimensions, 1x1, int, default: 2
%   cfg.tau: embedding delays, 1x1, int, default: 1
%   cfg.mass: number of nearest neighbours used for PDF estimation, 1x1, int,
%   default: 4
%   cfg.lag: time delay, 1x1, int, default: 1
%   cfg.metric: distance norm 'euclidean' or 'maximum', char, default: 'maximum'
%OUTPUT:
%   results.cfg: configuration structure
%   results.MI: auto-Mutual information per time lag, 1xlag, double
%DEPENDENCIES:
%   phasespace, neighsearch
%Author: Immo Weber, 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('       _  __       __    _  ______ _  ___        ');
disp('      / |/ /___   / /   (_)/_  __/(_)/ _ |       ');
disp('     /    // _ \ / /__ / /  / /  / // __ |       ');
disp('    /_/|_/ \___//____//_/  /_/  /_//_/ |_|       ');
disp('                                                 ');
%%%read in parameters%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isfield(cfg,'mass')==1
    mass=cfg.mass;
else
    mass=4;
    disp('No number of nearest neighbours specified! Assigning default: 4')
end
if isfield(cfg,'dim')==1
    dim=cfg.dim;
else
    dim=2;
    disp('No embedding dimension specified! Assigning default: 2')
end
if isfield(cfg,'tau')==1
    tau=cfg.tau;
else
    tau=1;
    disp('No embedding delay specified! Assigning default: 1')
end
if isfield(cfg,'lag')==1
    lag=cfg.lag;
else
    lag=1;
    disp('No lag specified! Assigning default: 1')
end
if isfield(cfg,'maxlag')==1
    maxlag=cfg.maxlag;
else
    maxlag=floor(length(data)/2);
    
end
if isfield(cfg,'metric')==1
    if strcmp(cfg.metric,'euclidean')==1
        metric=1;
    elseif strcmp(cfg.metric,'maximum')==1
        metric=2;
    end
else
    metric=2;
    disp('No distance norm specified! Assigning default: maximum')
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
l=1;

cfgs.dim=dim;
cfgs.tau=tau;

results=nta_phasespace(data,cfgs);
data=data(((dim-1)*tau)+1+lag:end);
results.embTS=results.embTS(1:end-lag,:);
if size(data,2)>1
    data=data';
end

results.embTS=horzcat(data,results.embTS);
results.embTS=results.embTS(1:end-(maxlag-lag-1),:);
N=size(results.embTS,1);

sumdistges=nta_neighsearch(results.embTS,[1:N]',metric);
sumdistges=sort(sumdistges);
%%%maximum distances for combined phase space used to project to marginal
%%%spaces%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sumdistges=repmat(sumdistges(mass+1,:),N,1);

sumdist1=nta_neighsearch(results.embTS(:,1),[1:N]',metric);
sumdist2=nta_neighsearch(results.embTS(:,2:end),[1:N]',metric);

numdata1=sum(sumdist1<sumdistges);
numdata2=sum(sumdist2<sumdistges);

results.lMI=psi(mass)-(psi(numdata1+1)+psi(numdata2+1))+psi(N);
results.MI=psi(mass)-sum(psi(numdata1+1)+psi(numdata2+1))/N+psi(N);

%%%generate output structure%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
results.cfg=cfg;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end