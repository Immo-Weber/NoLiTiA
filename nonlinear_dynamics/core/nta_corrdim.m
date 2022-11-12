function [results]=nta_corrdim(data,cfg)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Estimation of the correlation dimension (Grassberger and Procaccia, 1983).
%   data:                           input data, 1xN double
%CONFIGURATION STRUCTURE:
%   cfg.tau:                        embedding delay,  1x1, int, default: 0
%   cfg.dim:                        embedding dimension, 1x1, int, default: 2
%   cfg.ens:                        min and max size of neighbourhood(% of maximal attractor
%                                   diameter), 1x2, double, default: [1 100]
%   cfg.nr:                         number of neighbourhoods, 1x1, int, default: 10
%   cfg.th:                         Theiler window in samples, 1x1, int, default: 0
%   cfg.manual:                     manually define the linear scaling region by choosing two points 
%                                   when the crosshair appears. If manual==0 logE(1:length(logE)/3) is used for slope calculation
%                                   1x1, int, default:0 
%   cfg.resl:                       number of points used for slope calculation, 1x1, int, default: 2
%   cfg.plt:                        plot results yes/no [1/0], 1x1, int, default: 0
%   cfg.verbose:                    verbose level [1/0], 1x1, int, default: 1
%OUTPUT:
%   results.cfg:                    configuration structure
%   results.logE_logC:              Nx2 matrix of log E (neighbourhood-size) and log C (correlation sum); 
%   results.diff_logC:              local slope of logC per logE
%   results.Dtakens:                estimate of the  correlation dimension using Taken's
%                                   estimator
%   results.neighsizelist:          vector of neighbourhood-sizes used for calculation
%DEPENDENCIES:
%   autocorr, amutibin, phasespace
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
if isfield(cfg,'dim')==1
    dim                             =   cfg.dim;
else
    dim                             =   2;
    if verbose==1
        disp('No dimension specified. Assigning defaults: 2')
    end
end
if isfield(cfg,'tau')==1
    tau                             =   cfg.tau;
else
    tau                             =   0;
    if verbose==1
        disp('No delay specified. Assigning defaults: 0 (optimization)')
    end
end
if isfield(cfg,'ens')==1
    en1                             =   log10(cfg.ens(1));
    en2                             =   log10(cfg.ens(2));
else
    en1                             =   0;
    en2                             =   2;
    if verbose==1
        disp('No scale limits specified. Assigning defaults: [1 100]')
    end
end
if isfield(cfg,'nr')==1
    nr                              =   cfg.nr;
else
    nr                              =   50;
    if verbose==1
        disp('No number of scales specified. Assigning defaults: 10')
    end
end
if isfield(cfg,'th')==1
    th                              =   cfg.th;
else
    th                              =   0;
    if verbose==1
        disp('No Theiler window specified. Assigning defaults: 0 (optimization)')
    end
end
if isfield(cfg,'resl')==1
    resl                            =   cfg.resl;
else
    resl                            =   2;
    if verbose==1
        disp('No number of adjacent points for slope calculation specified. Assigning defaults: 2')
    end
end
if isfield(cfg,'manual')==1
    manual                          =   cfg.manual;
    cfg.plt                         =   1;
else
    manual                          =   0;
    if verbose==1
        disp('Manual mode not specified. Assigning default: 0')
    end
end
if isfield(cfg,'plt')==1
    plt                             =   cfg.plt;
else
    plt                             =   0;
end

cfgs.dim                            =   dim;
cfgs.tau                            =   tau;
cfgs.it                             =   0;
cfgs.verbose                        =   verbose;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
results                             =   [];

[data,nodata]                       =   checkdatainteg(data,cfg,verbose);
if nodata==1
    return
end

%%%if no Theiler-window is provided the autocorrelation time is used%%%%%%%
if th==0
    cfgac                           =   [];
    cfgac.lag                       =   round(2*length(data)/3);
[a]                                 =   nta_autocorr(data,cfgac);         
th                                  =   find(a<0,1,'first');
if isempty(th)==1
    th                              =   0;
end
end

%%%if no Tau is provided the first minimum of the auto mutual information%%
%%%is used%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if tau==0
    cfgami.plt                      =   0;
    cfgami.verbose                  =   verbose;
    [ resultsami ]                  =   nta_amutibin( data,cfgami);
    cfgs.tau                        =   resultsami.firstmin;
if verbose==1
    disp(['The best lag is probably' ' ' num2str(tau)])
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
results                             =   nta_phasespace(data,cfgs);                     
space                               =   results.embTS;
N                                   =   length(space);                                          
i                                   =   1;
corrs                               =   zeros(nr,2);
neighsizelist                       =   logspace(en1,en2,nr);
%%%compute distance matrix-->parallel computation for speedup%%%%%%%%%%%%%%
%sumdist=neighsearch(space,[th+1:N-th]',1);
sumdist                             =   nta_neighsearch(space,[1:N]',2);
[nrows,ncol]                        =   size(sumdist);
markedth                            =   full(spdiags(bsxfun(@times,ones(ncol,1),NaN(1,2*th+1)),[-th:th],nrows,ncol));

sumdist(isnan(markedth))            =   [];
l                                   =   length(sumdist);

%%%remove zeros%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sumdist(:,all(~any( sumdist ),1))=[];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%calculate std as a proxy for attractor diameter%%%%%%%%%%%%%%%%%%%%%%%%%

maxsize=max(max(sumdist));
neighsizelist                       =   neighsizelist*maxsize/100;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[n2,edges]                          =   histcounts(sumdist,[0 neighsizelist],'Normalization','cumcount');
corrs(:,1)                          =   neighsizelist;
corrs(:,2)                          =   2*n2./l;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%calculate Taken's estimator%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Dtakens                             =   corrs(end,2)/trapz(corrs(:,1),(corrs(:,2)./corrs(:,1)));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
logE_logC(:,1)                      =   log10(corrs(:,1));
logE_logC(:,2)                      =   log10(corrs(:,2));
difflogC                            =   logE_logC';
difflogC                            =   diff(difflogC(:,1:resl:end),1,2);
difflogC                            =   difflogC(2,:)./difflogC(1,:);
if manual==0
    ind                             =   find(isinf(logE_logC(:,2))==0,1,'first');
linear                              =   logE_logC(ind:floor(length(logE_logC(:,1))/3),1);                                                              
[F,S]                               =   polyfit(linear,logE_logC(ind:floor(length(logE_logC(:,1))/3),2),1);
D                                   =   F(1);
[~,delta]                           =   polyval([D 0],linear-1,S);
end
%%%plot results%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if plt==1
    figure
    subplot(1,2,1)
    plot(logE_logC(:,1),logE_logC(:,2),'linewidth',3,'color','r')
    axis square
    xlabel('Log E','fontsize',12)
    ylabel('Log Correlation Sum','fontsize',12)
%     a = get(gca,'XTickLabel');
%     set(gca,'XTickLabel',a,'FontName','Times','fontsize',18)
%     b = get(gca,'YTickLabel');
%     set(gca,'YTickLabel',b,'FontName','Times','fontsize',18)
    axis tight
    if manual==1
        [x,~]                       =   ginput(2);
        x(1)                        =   find(logE_logC(:,1)>x(1),1,'first');
        x(2)                        =   find(logE_logC(:,1)>x(2),1,'first');
        linear                      =   logE_logC(x(1):x(2),1);        
        [F,S]                       =   polyfit(linear,logE_logC(x(1):x(2),2),1);
        D=F(1);
        [~,delta]                   =   polyval([D 0],linear-1,S);
    end
    subplot(1,2,2)
    plot(logE_logC(1:resl:length(difflogC)*resl-1,1),difflogC,'linewidth',3,'color','r');
    axis square
    xlabel('Log E [arb.]','fontsize',12)
    ylabel('Dim [arb.]','fontsize',12)
%     a = get(gca,'XTickLabel');
%     set(gca,'XTickLabel',a,'FontName','Times','fontsize',18)
%     b = get(gca,'YTickLabel');
%     set(gca,'YTickLabel',b,'FontName','Times','fontsize',18)
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%generate output structure%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
results.cfg                         =   cfg;
results.logE_logC                   =   logE_logC;
results.diff_logC                   =   difflogC;
results.Dtakens                     =   Dtakens;
results.D                           =   D;
results.residuals                   =   delta;
results.meanresiduals               =   mean(delta);
results.neighsizelist               =   neighsizelist;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
