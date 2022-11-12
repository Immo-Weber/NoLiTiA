function [results]=nta_dfa(data,cfg)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Calculation of detrended fluctuation analysis
%   data:                   input data, 1xN, double
%CONFIGURATION STRUCTURE:
%   cfg.scales:             min & max number of windows (scales), 1x2, int, default: [2 10]
%   cfg.plt:                Plot results yes/no [1/0], 1x1, int, default: 1
%   cfg.verbose:            verbose level [1/0], 1x1, int, default: 1
%OUTPUT:
%   results.cfg:            configuration structure
%   results.expo:           estimate of the exponent
%   results.logbox:         log of window sizes
%   results.logF:           log of temporal fluctuations
%   results.residuals:      residuals of line fitting
%   results.meanresiduals:  mean of residuals
%DEPENDENCIES:
%   
%Author: Immo Weber, 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isfield(cfg,'verbose')==1
    verbose                 =   cfg.verbose;
else
    verbose                 =   1;
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
if isfield(cfg,'scales')==1
    mins                    =	cfg.scales(1);
    maxs                    =   cfg.scales(2);
else
    mins                    =   2;
    maxs                    =   10;
    if verbose==1
        disp('No windows specified. Assigning defaults.')
    end
end

if isfield(cfg,'plt')==1
    plt                     =   cfg.plt;
else
    plt                     =   1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
results                     =   [];

[data,nodata]               =   checkdatainteg(data,cfg,verbose);
if nodata==1
    return
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

meandata                    =   mean(data);
xt                          =   cumsum(data-meandata);
k                           =   1;
boxs                        =   [];
F                           =   [];
for i=mins:maxs
    l                       =   floor(length(xt)/i);
    bla                     =   [];
    for j=1:i
        par                 =   [];
        temp                =   [];
        xtemp               =   [];
        y=[];
        temp                =   xt((j-1)*l+1:l*j);
        xtemp(1,:)          =   [1:length(temp)];
        [par]               =   polyfit(xtemp,temp,1);      
        y                   =   xtemp.*par(1)+par(2);
        bla(j)              =   sum((temp-y).^2);
    end
    boxs(k)                 =   length(temp);
    F(k)                    =   sqrt(sum(bla)/(l*i));
    k                       =   k+1;
end
logbox                      =   log2(boxs);
logF                        =   log2(F);
[expo,S]                    =   polyfit(logbox,logF,1);
expo                        =   expo(1);
[~,delta]                   =   polyval([expo 0],logbox,S);
%%%plot results%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if plt==1
    plot(logbox,logF)
    axis square
    xlabel('Log(window length) [arb.]','fontsize',12)
    ylabel('Log(F) [arb.]','fontsize',12)  
    a                       =   get(gca,'XTickLabel');
    set(gca,'XTickLabel',a,'FontName','Times','fontsize',18)
    b                       =   get(gca,'YTickLabel');
    set(gca,'YTickLabel',b,'FontName','Times','fontsize',18)
end
%%%generate output structure%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
results.cfg                 =   cfg;
results.logbox              =   logbox;
results.logF                =   logF;
results.expo                =   expo;
results.residuals           =   delta;
results.meanresidual        =   mean(delta);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end