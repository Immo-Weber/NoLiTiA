function [results]=nta_hurst(data,cfg)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%calculation of Hurst exponent
%   data:                       input data, 1xN, double
%CONFIGURATION STRUCTURE:
%   cfg.scale:                  max. number of windows 1x1, int, default: 10
%   cfg.plt:                    Plot results yes/no [1/0], 1x1, int, default: 1
%   cfg.verbose:                verbose level [1/0], 1x1, int, default: 1
%OUTPUT:
%   results.cfg:                configuration structure
%   results.expo:               estimate of the exponent
%   results.lognges:            log of window sizes
%   results.logmeanrr:          log of rescaled ranges
%   results.residuals:          residuals of line fitting
%   results.meanresiduals:      mean of residuals
%DEPENDENCIES:
%   
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
if isfield(cfg,'scale')==1
    scale                       =   cfg.scale;
else
    scale                       =   10;
    if verbose==1
        disp('No maximum number of windows specified. Assigning defaults: 10')
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
data                            =   zscore(data);
for i=1:scale
    n                           =   floor(length(data)/i);
    rr                          =   [];
    for j=1:i
        temp                    =   data((j-1)*n+1:n*j);
        m                       =   mean(temp);
        yt                      =   temp-m;
        zt                      =   cumsum(yt);
        rn                      =   max(zt)-min(zt);
        sn                      =   std(temp);
        rr(j)                   =   rn/sn;
    end
    nges(i)                     =   n;
    meanrr(i)                   =   mean(rr);
end
lognges                         =   log2(nges);
logmeanrr                       =   log2(meanrr);
[res,S]                         =   polyfit(lognges(5:end),logmeanrr(5:end),1);
expo                            =   res(1);
[~,delta]                       =   polyval([expo 0],lognges(1:end),S);
%%%plot results%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if plt==1
    plot(lognges,logmeanrr)
    axis square
    xlabel('Log(N) [arb.]','fontsize',12)
    ylabel('Log(R/S) [arb.]','fontsize',12)
    a                           =   get(gca,'XTickLabel');
    set(gca,'XTickLabel',a,'FontName','Times','fontsize',18)
    b                           =   get(gca,'YTickLabel');
    set(gca,'YTickLabel',b,'FontName','Times','fontsize',18)
end
%%%generate output structure%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
results.cfg                     =   cfg;
results.expo                    =   expo;
results.lognges                 =   lognges;
results.logmeanrr               =   logmeanrr;
results.residuals               =   delta;
results.meanresidual            =   mean(delta);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end