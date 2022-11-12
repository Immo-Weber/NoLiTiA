function results=nta_entropybin(data,cfg)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Calculates the Shannon entropy using a binning estimator.
%   data:                           input data, 1xN, double
%CONFIGURATION STRUCTURE:
%   cfg.numbin:                     number of bins,  1x1, int, default: 0 (optimization using Freedman-Diaconis rule)
%   cfg.verbose:                    verbose level [1/0], 1x1, int, default: 1
%OUTPUT:
%   results.Hx:                     Shannon entropy [bit], 1x1, double
%   results.SI:                     Shannon information [bit], 1xN, double
%   results.dist:                   Probability distribution. 
%DEPENDENCIES:
%   freeddiac
%Author: Immo Weber, 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isfield(cfg,'verbose')==1
    verbose                         =   cfg.verbose;
else
    verbose                         =   1;
end
%%%read in parameters%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isfield(cfg,'numbin')==1
    numbin                          =   cfg.numbin;
else
    numbin                          =   0;
    if verbose==1
        disp('No number of bins specified! Assigning default: 0 (optimization)')
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
results                             =   [];

[data,nodata]=checkdatainteg(data,cfg,verbose);
if nodata==1
    return
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

data                                =   zscore(data);

if numbin==0
    numbin                          =   nta_freeddiac(data);
end
[N,edges,bin]                       =   histcounts(data,numbin);
bindata                             =   edges(2)-edges(1);


results.dist                        =   N;
areadata                            =   bindata*(nansum(N));
results.dist                        =   results.dist/areadata;

results.SI                          =   -log2(results.dist);
results.Hx                          =   nansum((results.dist.*bindata).*results.SI);


results.SI                          =   results.SI(bin);
     

%%%generate output structure%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
results.cfg                         =   cfg;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end