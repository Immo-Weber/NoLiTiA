function [ results ] = nta_amutiembknn( data,cfg )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Calculates the auto-mutual information as a function of lags using a
%nearest neighbours estimator (Kraskov, 2004).
%   data:                       input data, 1xN, double
%CONFIGURATION STRUCTURE:
%   cfg.dim:                    embedding dimensions, 1x1, int, default: 2
%   cfg.tau:                    embedding delays, 1x1, int, default: 1;
%   cfg.mass:                   number of nearest neighbours used for PDF estimation, 1x1,
%                               int, default: 4
%   cfg.maxlag:                 maximum number of lags, 1x1, int, default: half data length
%   cfg.plt:                    plot results yes/no[1/0], 1x1, int, default: 1
%   cfg.metric:                 distance norm 'euclidean' or 'maximum', char, default: 'maximum'
%   cfg.verbose:                verbose level [1/0], 1x1, int, default: 1
%OUTPUT:
%   results.cfg:                configuration structure
%   results.embAMI:             auto-Mutual information per time lag, 1xlag, double
%   results.firstmin:           first minimum of embAMI
%   results.AIS:                active information storage
%DEPENDENCIES:
%   MIdelayunimulti
%Author: Immo Weber, 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isfield(cfg,'verbose')==1
    verbose                     =   cfg.verbose;
else
    verbose                     =   1;
end
%%%read in parameters%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isfield(cfg,'mass')==1
    mass                        =   cfg.mass;
else
    mass                        =   4;
    if verbose==1
        disp('No number of nearest neighbours specified! Assigning default: 4')
    end
end
if isfield(cfg,'dim')==1
    dim                         =   cfg.dim;
else
    dim                         =   2;
    if verbose==1
        disp('No embedding dimension specified! Assigning default: 2')
    end
end
if isfield(cfg,'tau')==1
    tau                         =   cfg.tau;
else
    tau                         =   1;
    if verbose==1
        disp('No embedding delay specified! Assigning default: 1')
    end
end
if isfield(cfg,'maxlag')==1
    maxlag                      =   cfg.maxlag;
    if maxlag >= length(data)
        if verbose==1
            disp('Warning! Maximum lag larger than sample size. Assigning default: half data length')
        end
        maxlag                  =   floor(length(data)/2);
    end
else
    maxlag                      =   floor(length(data)/2);
    if verbose==1
        disp('No maximum number of lags specified! Assigning default: half data length')
    end
end
if isfield(cfg,'metric')==1
    if strcmp(cfg.metric,'euclidean')==1
        metric                  =   'euclidean';
    elseif strcmp(cfg.metric,'maximum')==1
        metric                  =   'maximum';
    end
else
    metric                      =   'maximum';
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

data                            =   zscore(data);

cfge.mass                       =   mass;
cfge.dim                        =   dim;
cfge.tau                        =   tau;
cfge.lag                        =   0;
cfge.maxlag                     =   maxlag;
cfge.metric                     =   metric;
cfge.verbose                    =   verbose;
reverseStr                      =   '';
steps                           =   maxlag-1;
for i=1:maxlag
    cfge.lag                    =   i-1;
    [results]                   =   nta_MIdelayunimulti(data,cfge);
    embAMI(i)                   =   results.MI;
    if verbose==1
    percentDone                 =   100 * i /steps;
    msg                         =   sprintf('Percent done: %3.1f', percentDone); %Don't forget this semicolon    
    fprintf([reverseStr, msg]);
    reverseStr                  =   repmat(sprintf('\b'), 1, length(msg));
    end
end


firstmin                        =   diff(embAMI);
firstmin                        =   find(firstmin>0,1,'first');
%%%plot results%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if plt==1
    figure
    plot(embAMI,'color','r','linewidth',3)
    axis square
    xlabel('Lag [samples]','fontsize',12);
    ylabel('MI [nats]','fontsize',12)
    a                           =   get(gca,'XTickLabel');
    set(gca,'XTickLabel',a,'FontName','Times','fontsize',18)
    b                           =   get(gca,'YTickLabel');
    set(gca,'YTickLabel',b,'FontName','Times','fontsize',18)
end

%%%generate output structure%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
results.cfg                     =   cfg;
results.embAMI                  =   embAMI;
if isempty(firstmin)==0
results.firstmin                =   firstmin;
else
    results.firstmin            =   NaN;
end
results.AIS                     =   embAMI(2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end



