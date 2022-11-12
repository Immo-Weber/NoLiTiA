function [ results ] = nta_amutibin( data,cfg )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Calculates the auto-mutual information as a function of lags using a
%binning estimator.
%   data:                       input data, Nx1, double
%CONFIGURATION STRUCTURE:
%   cfg.numbin:                 number of bins, 1x1, int, default: 10
%   cfg.maxlag:                 maximum number of lags, 1x1, int, default: half data length
%   cfg.plt:                    plot results yes/no [1/0], 1x1, int, default: 1
%   cfg.verbose:                verbose level [1/0], 1x1, int, default: 1
%OUTPUT:
%   results.cfg:                configuration structure
%   results.ami:                auto mutual information as a function of time
%   results.firstmin:           first minimum of auto-mutual information
%DEPENDENCIES:
%   MIbin
%Author: Immo Weber, 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isfield(cfg,'verbose')==1
    verbose                     =   cfg.verbose;
else
    verbose                     =   1;
end
%%%read in parameters%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isfield(cfg,'numbin')==1
    numbin                      =   cfg.numbin;
else
    numbin                      =   10;
    if verbose==1
        disp('No number of bins specified! Assigning default: 10')
    end
end
if isfield(cfg,'maxlag')==1
    maxlag                      =   cfg.maxlag;
    if maxlag >= length(data)
        if verbose==1
            warning('Warning! Maximum lag larger than sample size. Assigning default: half data length')
        end
        maxlag                  =   floor(length(data)/2);
    end
else
    maxlag                      =   floor(length(data)/2);
    if verbose==1
        disp('No maximum number of lags specified! Assigning default: half data length')
    end
end
if isfield(cfg,'plt')==1
    plt                         =   cfg.plt;
else
    plt                         =   1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
madatalag                       =   length(data)-maxlag;
data                            =   (data-mean(data))./std(data);

data                            =   flipud(data);

cfgs.numbin                     =   numbin;
results.ami                     =   zeros(1,maxlag);
reverseStr                      =   '';
for i=1:maxlag
    resultsmi                   =   nta_MIbin(data(1:madatalag),data(i:madatalag+i-1),cfgs);
    results.ami(i)              =   resultsmi.MI;
    if verbose==1
    percentDone                 =   100 * i / maxlag;
    msg                         =   sprintf('Percent done: %3.1f', percentDone);
    fprintf([reverseStr, msg]);    
    reverseStr                  =   repmat(sprintf('\b'), 1, length(msg));
    end
end

if plt==1
    figure
    plot(results.ami,'linewidth',3,'color','r')
    axis square
    xlabel('Lag [samples]','fontsize',12);
    ylabel('MI [bit]','fontsize',12)
    a                           =   get(gca,'XTickLabel');
    set(gca,'XTickLabel',a,'FontName','Times','fontsize',18)
    b                           =   get(gca,'YTickLabel');
    set(gca,'YTickLabel',b,'FontName','Times','fontsize',18)
end

results.firstmin                =   diff(results.ami);
results.firstmin                =   find(results.firstmin>0,1,'first');

if isempty(results.firstmin)==1
    results.firstmin            =   1;
end

%%%generate output structure%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
results.cfg                     =   cfg;
results.lags                    =   1:maxlag;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end

