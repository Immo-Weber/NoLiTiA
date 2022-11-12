function results=entropy_picture(image,cfg)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Calculates the Shannon entropy of an image using a binning estimator.
%   data: input data, 1xN, double
%CONFIGURATION STRUCTURE:
%   cfg.numbin: number of bins,  1x1, int, default: 0 (optimization using Freedman-Diaconis rule)
%   cfg.verbose: verbose level [1/0], 1x1, int, default: 1
%OUTPUT:
%   results.Hx: Shannon entropy [bit], 1x1, double
%   results.dist: Probability distribution. 
%DEPENDENCIES:
%   freeddiac
%Author: Immo Weber, 2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isfield(cfg,'verbose')==1
    verbose=cfg.verbose;
else
    verbose=1;
end
%%%read in parameters%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isfield(cfg,'numbin')==1
    numbin=cfg.numbin;
else
    numbin=0;
    if verbose==1
        disp('No number of bins specified! Assigning default: 0 (optimization)')
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
results=[];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

xsize=size(image,1);
ysize=size(image,2);
k=1;

for x=2:xsize-1
    for y=2:ysize-1
        temp=image([x-1:x+1],[y-1:y+1]);
        newdata(k)=mean(temp(:));
        k=k+1;
    end
end

if numbin==0
    numbin=freeddiac(newdata);
end
[N,edges,bin] = histcounts(newdata,numbin);

results.dist=N;
results.dist=results.dist/nansum(N);

results.SI=-log2(results.dist);
results.Hx=nansum(results.dist.*results.SI);


results.SI=results.SI(bin);
     

%%%generate output structure%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
results.cfg=cfg;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end