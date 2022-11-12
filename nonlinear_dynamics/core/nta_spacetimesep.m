function [results]=nta_spacetimesep(data,cfg)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Space-Time-Separation-Plot. Can be used to determine Theiler-window. For
%reference see (Provenzale et al. 1992)
%   data:                       input data, 1xN, double
%CONFIGURATION STRUCTURE:
%   cfg.tau:                    embedding delay, 1x1, int, default: 1
%   cfg.dim:                    embedding dimension, 1x1, int, default: 2
%   cfg.nr:                     Number of classes, 1x1, int, default: 5
%   cfg.maxlag:                 maximum number of temporal lags,1x1, int, default: 100
%   cfg.metric:                 distance norm 'euclidean' or 'maximum', char, default: 'maximum'
%   cfg.plt:                    plot results yes/no [1/0], 1x1, int, default: 1
%   cfg.verbose:                verbose level [1/0], 1x1, int, default: 1
%OUTPUT:
%   results.cfg:                configuration structure
%   results.hto:                space-time-matrix
%   results.lagvector:          1xmaxlag vector
%   results.classvector:        1xnr vector containing histogram intervals of
%                               distances
%DEPENDENCIES:
%   amutibin, phasespace, neighsearch
%Author: Immo Weber, 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isfield(cfg,'verbose')==1
    verbose                     =   cfg.verbose;
else
    verbose                     =   1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if verbose==1
disp('                                                 ');
disp('       _  __       __    _  ______ _  ___        ');
disp('      / |/ /___   / /   (_)/_  __/(_)/ _ |       ');
disp('     /    // _ \ / /__ / /  / /  / // __ |       ');
disp('    /_/|_/ \___//____//_/  /_/  /_//_/ |_|       ');
disp('                                                 ');
end
%%%read in parameters%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isfield(cfg,'dim')==0
    cfg.dim                     =   2;
    if verbose==1
        disp('No embedding dimension specified. Assigning defaults: 2')
    end
end
if isfield(cfg,'tau')==0
    cfg.tau                     =   0;
    if verbose==1
        disp('No embedding delay specified. Assigning defaults: 0 (optimization)')
    end
end
if isfield(cfg,'nr')==1
    nr                          =   cfg.nr;
else
    nr                          =   5;
    if verbose==1
        disp('No number of classes specified. Assigning defaults: 5')
    end
end
if isfield(cfg,'maxlag')==1
    maxlag                      =   cfg.maxlag;
else
    maxlag                      =   100;
    if verbose==1
        disp('No maximum delay specified. Assigning defaults: 100')
    end
end
if isfield(cfg,'metric')==1
    if strcmp(cfg.metric,'euclidean')==1
        metric                  =   1;
    elseif strcmp(cfg.metric,'maximum')==1
        metric                  =   2;
    end
else
    metric                      =   2;
    if verbose==1
        disp('No distance norm specified! Assigning default: maximum')
    end
end
if isfield(cfg,'plt')==1
    plt                         =   cfg.plt;
else
    plt                         =   1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
results                         =   [];

[data,nodata]                   =   checkdatainteg(data,cfg,verbose);
if nodata==1
    return
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%if no Tau is provided the first minimum of the auto mutual information%%
%%%is used%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if cfg.tau==0
    cfgami.numbin               =   10;
    cfgami.time                 =   length(data)/2;
    cfgami.plt                  =   0;
    cfgami.verbose=verbose;
    [ resultsami ]              =   nta_amutibin( data,cfgami);
    cfg.tau                     =   resultsami.firstmin;
    if verbose==1
        disp(['The best lag is probably' ' ' num2str(cfg.tau)])
    end
end
results                         =   nta_phasespace(data,cfg);
space                           =   results.embTS;
N                               =   length(space);
i                               =   1;
stsp                            =   zeros(nr,2);
sumdist                         =   zeros(N,N);
Ni                              =   zeros(2*N,1);

sumdist                         =   nta_neighsearch(space,[1:N]',metric);
mindist                         =   min(min(sumdist));
maxdist                         =   max(max(sumdist));
classvec                        =   linspace(mindist,maxdist/2,nr);
N2                              =   1:N;
% N2=gpuArray(N2);
[X,Y]                           =   meshgrid(N2,N2);
% X=gather(X);
% Y=gather(Y);
Z                               =   abs(X-Y);
reverseStr                      =   '';
steps                           =   maxlag;
hto                             =   zeros(nr,maxlag);
for i=1:maxlag
    Ni                          =   (Z==i);
    hto(:,i)                    =   cumsum(hist(sumdist(Ni),classvec));
    if verbose==1 
    percentDone                 =   100 * i / steps;
    msg                         =   sprintf('Percent done: %3.1f', percentDone); 
    fprintf([reverseStr, msg]);
    reverseStr                  =   repmat(sprintf('\b'), 1, length(msg));
    end
end
um                              =   max(hto);
um                              =   ones(nr,size(um,1))*um;
hto                             =   hto./um;
lagvector                       =   1:maxlag;
%%%plot results%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if plt==1
    contour(lagvector,classvec,hto,nr,'ShowText','on')
    xlabel('dt [samples]')
    ylabel('dE [arb.]')
end
%%%generate output structure%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
results.cfg                     =   cfg;
results.hto                     =   hto;
results.lagvector               =   lagvector;
results.classvector             =   classvec;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end


