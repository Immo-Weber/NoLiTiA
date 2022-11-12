function [ results ] = nta_MIkraskov( data1,data2,cfg )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Calculation of mutual information between two signals using a nearest neighbour estimator
%(Kraskov, 2004).
%   data1:                          input data, 1xN, double
%   data2:                          input data, 1xN, double
%CONFIGURATION STRUCTURE:
%   cfg.dims:                       embedding dimensions, 1x2, int, default: [2 2]
%   cfg.taus:                       embedding delays, 1x2, int, default: [0 0]
%   cfg.mass:                       number of nearest neighbours used for PDF estimation, 1x1, int,
%                                   default: 4
%   cfg.metric:                     distance norm 'euclidean' or 'maximum', char, default: 'maximum'
%   cfg.verbose:                    verbose level [1/0], 1x1, int, default: 1
%OUTPUT:
%   results.cfg:                    configuration structure
%   results.MI:                     Mutual information, 1x1, double
%   results.lMI:                    Local mutual information , 1xN, double
%DEPENDENCIES:
%   amutibin, phasespace, neighsearch
%Author: Immo Weber, 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isfield(cfg,'verbose')==1
    verbose                         =   cfg.verbose;
else
    verbose                         =   1;
end
%%%read in parameters%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isfield(cfg,'mass')==1
    mass                            =   cfg.mass;
else
    mass                            =   4;
end

if isfield(cfg,'dims')==1
    dims                            =   cfg.dims;
else
    dims                            =   [2 2];
end

if isfield(cfg,'taus')==1
    taus                            =   cfg.taus;
else
    taus                            =   [0 0];
end
if isfield(cfg,'metric')==1
    if strcmp(cfg.metric,'euclidean')==1
        metric                      =   1;
    elseif strcmp(cfg.metric,'maximum')==1
        metric                      =   2;
    end
else
    metric                          =   2;
    if verbose==1
        disp('No distance norm specified! Assigning default: maximum')
    end
end
%%%embedding of time series%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if taus(1)==0
    cfgami.plt                      =   0;
    cfgami.verbose                  =   verbose;
    [resultsami1]                   =   nta_amutibin( data1,cfgami);
    taus(1)                         =   resultsami1.firstmin;
end
if taus(2)==0
    [resultsami2]                   =   nta_amutibin( data2,cfgami);
    taus(2)                         =   resultsami2.firstmin;
end

cfgs1.dim                           =   dims(1);
cfgs1.tau                           =   taus(1);
cfgs1.verbose                       =   verbose;

cfgs2.dim                           =   dims(2);
cfgs2.tau                           =   taus(2);
cfgs2.verbose                       =   verbose;

minlengthPS                         =   min([length(data1)-(taus(1)*dims(1)*((dims(1)-1)/dims(1)))  length(data2)-(taus(2)*dims(2)*((dims(2)-1)/dims(2)))]);
results1                            =   nta_phasespace(data1,cfgs1);
space1                              =   results1.embTS(1:minlengthPS,:);
results2                            =   nta_phasespace(data2,cfgs2);
space2                              =   results2.embTS(1:minlengthPS,:);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
combspace                           =   horzcat(space1,space2);
N                                   =   size(combspace,1);

sumdistges                          =   nta_neighsearch(combspace,[1:N]',metric);
sumdistges                          =   sort(sumdistges);
%%%maximum distances for combined phase space used to project to marginal
%%%spaces%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
distance1                           =   repmat(sumdistges(mass+1,:),minlengthPS,1);

sumdist1                            =   nta_neighsearch(space1,[1:N]',metric);
sumdist2                            =   nta_neighsearch(space2,[1:N]',metric);

numdata1                            =   sum(sumdist1<distance1);
numdata2                            =   sum(sumdist2<distance1);
lMI                                 =   psi(mass)-(psi(numdata1+1)+psi(numdata2+1))+psi(N);
MI                                  =   psi(mass)-sum(psi(numdata1+1)+psi(numdata2+1))/N+psi(N);

%%%generate output structure%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
results.cfg                         =   cfg;
results.MI                          =   MI;
results.lMI                         =   lMI;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end





