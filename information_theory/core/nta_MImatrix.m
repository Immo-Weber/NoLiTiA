function [results]=nta_MImatrix(data,cfg)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Column-wise calculation of mutual information using two estimators. 
%   data:                           input data, NxM, double
%CONFIGURATION STRUCTURE:
%   cfg.mode:                       estimator type: bin ['bin'] or nearest neighbour ['nn'],char, default: 'bin'
%   Parameters for bin estimator:
%       cfg.numbin:                 number of bins,  1x1, int, default: 0
%   Parameters for nearest neighbour estimator:
%       cfg.dims:                   embedding dimensions, 1x2, int, default: [2 2]
%       cfg.taus:                   embedding delays, 1x2, int, default: [1 1]
%       cfg.mass:                   number of nearest neighbours used for PDF estimation, 1x1, int,
%                                   default:  4
%       cfg.plt:                    plot results yes/no [1/0], 1x1, int, default: 1
%       cfg.verbose:                verbose level [1/0], 1x1, int, default: 1
%OUTPUT:
%   results.cfg:                    configuration structure
%   results.MIMaabs:                Mutual information Matrix (absolute values), MxM, double
%   results.MIManorm:               Mutual information Matrix (normalized), MxM, double
%DEPENDENCIES:
%   MIkraskov, MIbin
%Author: Immo Weber, 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isfield(cfg,'verbose')==1
    verbose                         =   cfg.verbose;
else
    verbose                         =   1;
end
%%%read in parameters%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isfield(cfg,'mode')==1
    mode                            =   cfg.mode;
else
    mode                            =   'bin';
end
if isfield(cfg,'numbin')==1
numbin                              =   cfg.numbin;
else
    numbin                          =   0;
if verbose==1
    disp('No number of bins specified! Assigning default: 0')
end
end
if isfield(cfg,'mass')==1
mass                                =   cfg.mass;
else
    mass                            =   4;
end

if isfield(cfg,'dims')==1
dims                                =   cfg.dims;
else
    dims                            =   [2 2];
end

if isfield(cfg,'taus')==1
taus                                =   cfg.taus;
else
    taus                            =   [1 1];
end
if isfield(cfg,'plt')==1
plt                                 =   cfg.plt;
else
    plt                             =   1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
numcol                              =   size(data,2);
reverseStr                          =   '';
steps                               =   size(data,2)*size(data,2);
k                                   =   1;
MIma                                =   zeros(size(data,2));

if strcmp(mode,'nn')==1
    cfgnn.mass                      =   mass;
    cfgnn.dims                      =   dims;
    cfgnn.taus                      =   taus;
    cfgnn.verbose                   =   verbose;
    for i=1:size(data,2)
        for j=1:size(data,2)
            resultsnn               =   nta_MIkraskov( data(:,i),data(:,j),cfgnn );
            
            
            MIma(i,j)               =   resultsnn.MI;
            percentDone             =   100 * k / steps;
            msg                     =   sprintf('Percent done: %3.1f', percentDone); 
            fprintf([reverseStr, msg]);
            reverseStr              =   repmat(sprintf('\b'), 1, length(msg));
            k=k+1;
        end
    end
    
elseif strcmp(mode,'bin')==1
    cfgbin.numbin                   =   numbin;
    cfgbin.verbose                  =   verbose;
    for i=1:size(data,2)
        for j=1:size(data,2)
            resultsbin              =   nta_MIbin(data(:,i),data(:,j),cfgbin);
            MIma(i,j)               =   resultsbin.MI;
            percentDone             =   100 * k / steps;
            msg                     =   sprintf('Percent done: %3.1f', percentDone); 
            fprintf([reverseStr, msg]);
            reverseStr              =   repmat(sprintf('\b'), 1, length(msg));
            k=k+1;
        end
    end
end

MImaabs                             =   MIma;
temp                                =   meshgrid(diag(MIma))+meshgrid(diag(MIma))';
MIma                                =   (size(MIma,2)*MIma./temp);
%%%plot results%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if plt==1
    imagesc(1:numcol,1:numcol,MIma)
    axis square
    colorbar
    xlabel('Variable No','fontsize',12);
    ylabel('Variable No','fontsize',12);
    set(gca,'Xtick',1:1:numcol)
    set(gca,'Ytick',1:1:numcol)
    a                               =   get(gca,'XTickLabel');
    set(gca,'XTickLabel',a,'FontName','Times','fontsize',18)
    b                               =   get(gca,'YTickLabel');
    set(gca,'YTickLabel',b,'FontName','Times','fontsize',18)
end
%%%generate output structure%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
results.cfg                         =   cfg;
results.MImanorm                    =   MIma;
results.MImaabs                     =   MImaabs;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end