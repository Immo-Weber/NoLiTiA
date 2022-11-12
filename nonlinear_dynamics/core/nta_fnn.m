function  [results]=nta_fnn(data,cfg)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%False Nearest Neighbours Algorithm by Hegger and Kantz (1999)
%   data:                           input data, 1xN, double
%CONFIGURATION STRUCTURE:
%   cfg.tau:                        embedding delay, 1x1, int, default: 0
%   cfg.dim:                        max embedding dimensions for which fnn should be
%                                   calculated, 1x1, int, default: 9
%   cfg.plt:                        plot results [1/0], 1x1, int, default: 0
%   cfg.Rtol:                       Threshold Parameter for distance, 1x1, double, default: 10
%   cfg.Atol:                       Threshold Parameter for loneliness criterion, 1x1, double, default: 2
%   cfg.thr:                        Threshold for first minimum in % fnn, 1x1 double, default: 0.1
%   cfg.verbose:                    verbose level [1/0], 1x1, int, default: 1
%OUTPUT:
%   results.cfg:                    configuration structure
%   results.fnn:                    first row: % of false nearest neighbours, second row: tested
%                                   dimensions
%   results.firstmin:               dimension at first zero crossing (zero false
%                                   neighbours)
%DEPENDENCIES:
%   amutibin, phasespace
%Author: Immo Weber, 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isfield(cfg,'verbose')==1
    verbose                         =   cfg.verbose;
else
    verbose                         =   1;
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
if isfield(cfg,'tau')
    tau                             =   cfg.tau;
else
    tau                             =   0;
    if verbose==1
        disp('No tau specified. Assigning default: 0')
    end
end
if isfield(cfg,'dim')
    dimmax                          =   cfg.dim;
else
    dimmax                          =   9;
    if verbose==1
        disp('No dimension specified. Assigning default: 9')
    end
end
if isfield(cfg,'plt')
    plt                             =   cfg.plt;
else
    plt                             =   0;
end
if isfield(cfg,'Rtol')
    Rtol                            =   cfg.Rtol;
else
    Rtol                            =   10;
    if verbose==1
        disp('No threshold parameter Rtol specified. Assigning default: 10')
    end
end
if isfield(cfg,'Atol')
    Atol                            =   cfg.Atol;
else
    Atol                            =   2;
    if verbose==1
        disp('No threshold parameter Atol specified. Assigning default: 2')
    end
end
if isfield(cfg,'thr')
    thr                             =   cfg.thr;
else
    thr                             =   0.1;
    if verbose==1
        disp('No threshold parameter for first minimum specified. Assigning default: 0.1')
    end
end

%%%if no Tau is provided the first minimum of the auto mutual information%%
%%%is used%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
results                             =   [];

[data,nodata]                       =   checkdatainteg(data,cfg,verbose);
if nodata==1
    return
end


if tau==0
    cfgami.numbin                   =   10;
    cfgami.time                     =   length(data)/2;
    cfgami.plt                      =   0;
    cfgami.verbose                  =   verbose;
    [resultsami]                    =   nta_amutibin( data,cfgami);
    tau                             =   resultsami.firstmin;
    if verbose==1
        disp(['The best lag is probably' ' ' num2str(tau)])
    end
end
%%%Phase-space  parameter%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cfgs.tau                            =   tau;
cfgs.plt                            =   0;
cfgs.it                             =   0;
cfgs.backward                       =   0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N                                   =   length(data);
sigma                               =   std(data,1);
reverseStr                          =   '';
steps                               =   dimmax ;
for i=1:dimmax
    mls                             =   N-i*tau;
    cfgs.dim                        =   i;
    cfgs.verbose                    =   0;
    results                         =   nta_phasespace(data,cfgs);
    space                           =   results.embTS(1:mls,:);
    eunorm                          =   nta_neighsearch(space,[1:mls]',1);
    eunorm(eunorm==0)               =   NaN;
    [minval,indi]                   =   min(eunorm);
    temp                            =   abs(data([1:mls]+1)-data(indi+1))./minval;
    first                           =   (temp)-Rtol;
    second                          =   sqrt((minval.^2+(data([1:mls]+1)-data(indi+1)).^2)./sigma)-Atol;
    fnn(i)                          =   sum((first>0) | (second>0));
    if verbose==1
    percentDone                     =   100 * i / steps;   
    msg                         =   sprintf('Percent done: %3.1f', percentDone);
    fprintf([reverseStr, msg]);
    reverseStr                  =   repmat(sprintf('\b'), 1, length(msg));
    end
%     msg = sprintf('Percent done: %3.1f', percentDone); 
%     fprintf([reverseStr, msg]);
%     reverseStr = repmat(sprintf('\b'), 1, length(msg));
end

fnn                                 =   (fnn/max(fnn))*100;
dimvek                              =   1:dimmax;
fnn(2,1:length(dimvek))             =   dimvek;
firstmin                            =   find(fnn(1,:)<=thr,1,'first');
if isempty(firstmin)==1
    firstmin                        =   dimmax;
    warning('No minimum detected! Assigning maximum.');
    results.nominflag=1;
end
firstmin=fnn(2,firstmin);

%%%plot results%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if plt==1
    plot(fnn(2,:),fnn(1,:))
    axis square
    xlabel('Dimension [arb.]','fontsize',12);
    ylabel('False nearest neighbours [%]','fontsize',12);
    a                               =   get(gca,'XTickLabel');
    set(gca,'XTickLabel',a,'FontName','Times','fontsize',18)
    b                               =   get(gca,'YTickLabel');
    set(gca,'YTickLabel',b,'FontName','Times','fontsize',18)
end
%%%generate output structure%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
results.cfg                         =   cfg;
results.fnn                         =   fnn;
results.firstmin                    =   firstmin;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
