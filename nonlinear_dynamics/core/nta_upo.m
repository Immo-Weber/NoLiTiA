function [results] = nta_upo( data,cfg )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Function to detect unstable periodic orbits in 2-dimensional phase-space (experimental).
%See (So et al. 1996) for reference.
%   data:                               input data, 1xN, double
%CONFIGURATION STRUCTURE:
%   cfg.tau:                            embedding delay, 1x1, int, default: 0
%   cfg.numit:                          number of iterations for upo transform, 1x1, int, default: 200
%   cfg.bins:                           number of bins per dimension, 1x2, int, default: [20 20]
%   cfg.numsurr:                        number of surrogates for statistics, 1x1, int, default: 0
%   cfg.surrmode:                       type of surrogate:
%       mode==1                             random shuffling
%       mode==2                             phase randomization
%       mode==3                             amplitude adjusted phase randomization
%       mode==4                             cut time series at random point and flip second half
%       mode==5                             cut time series at random point and switch halves, 1x1,  int,
%                                           default: 2
%   cfg.plt:                             plot yes/no  [1/0], 1x1, int, default: 1
%   cfg.verbose:                         verbose level [1/0], 1x1, int, default: 1
%OUTPUT:
%   results.cfg:                        configuration structure
%   results.bincenters:                 center coordinates of histogram bins
%   results.countorig:                  normalized histogram counts of original phase-space
%   results.counttrans:                 normalized histogram counts of transformed phase-space
%   results.countsurr:                  normalized histogram counts of surrogates
%   results.statcount:                  z-score map of transformed phase space
%   results.histdiag:                   probabilities of center diagonal states of original and transformed phase-spaces
%   results.histdiagzscores:            zscore stats of center diagonal of transformed phase-spaces
%DEPENDENCIES:
%   amutibin, phasespace, surrogates
%Author: Immo Weber, 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isfield(cfg,'verbose')==1
    verbose                             =   cfg.verbose;
else
    verbose                             =   1;
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
if isfield(cfg,'tau')==1
    tau                                 =   cfg.tau;
else
    tau                                 =   0;
    if verbose==1
        disp('No tau specified. Assigning default: 0')
    end
end
if isfield(cfg,'numit')==1
    numit                               =   cfg.numit;
else
    numit                               =   200;
    if verbose==1
        disp('No number of iterations specified. Assigning default: 10')
    end
end
if isfield(cfg,'bins')==1
    binx                                =   cfg.bins(1);
    biny                                =   cfg.bins(2);
else
    binx                                =   20;
    biny                                =   20;
    if verbose==1
        disp('No number of bins specified. Assigning default: [20 20]')
    end
end
if isfield(cfg,'numsurr')==1
    numsurr                             =   cfg.numsurr;
else
    numsurr                             =   0;
    if verbose==1
        disp('No number of surrogates specified. Assigning default: 0')
    end
end
if isfield(cfg,'surrmode')==1
    surrmode                            =   cfg.surrmode;
else
    surrmode                            =   2;
    if verbose==1
        disp('No surrogate type specified. Assigning default: 2 (phase shuffling)')
    end
end

if isfield(cfg,'plt')==1
    plt                                 =   cfg.plt;
else
    plt                                 =   1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dim=2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
results                                 =   [];

[data,nodata]                           =   checkdatainteg(data,cfg,verbose);
if nodata==1
    return
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%if no Tau is provided the first minimum of the auto mutual information%%
%%%is used%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if tau==0
    cfgami.numbin                       =   10;
    cfgami.time                         =   length(data)/2;
    cfgami.plt                          =   0;
    cfgami.verbose                      =   verbose;
    [resultsami ]                       =   nta_amutibin( data,cfgami);
    tau                                 =   resultsami.firstmin;
    if verbose==1
        disp(['The best lag is probably' ' ' num2str(tau)])
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

countsurr                               =   1;
statcount                               =   1;
histdiag                                =   1;
mid2                                    =   1;
%% 
%%%Phase space reconstruction%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cfgs.dim                                =   dim;
cfgs.tau                                =   tau;
cfgs.it                                 =   0;
cfgs.backward                           =   1;
cfgs.verbose                            =   0;
results                                 =   nta_phasespace(data,cfgs);
space                                   =   results.embTS;
%space=fliplr(space);%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
minval                                  =   min(space);
maxval                                  =   max(space);
N                                       =   length(space);
steig                                   =   diff(space);

%% 

a                                       =   -5;
b                                       =   5;
transphasespace                         =   zeros(N-dim,dim);
erg                                     =   horzcat(eye(dim-1),zeros(dim-1,1));

for q=1:numit
    for i=2:N-dim
        an                              =   (inv(steig(i-1:i+dim-2,:))*steig(i:i+dim-1,1))';
        an                              =   vertcat(an,erg);        
        s                               =   an+((b-a).*rand(dim,dim)+a).*(sum(abs(space(i+1,:)-space(i,:))));
        transphasespace(i,1:dim)        =   (inv(eye(dim,dim)-s)*(space(i+1,:)'-s*space(i,:)'))';
    end
    [counttranstemp,mid]                =   hist3(transphasespace(:,1:2),'edges',{minval:(maxval-minval)/(binx-1):maxval minval:(maxval-minval)/(biny-1):maxval});
    counttransges(:,:,q)                =   100*(counttranstemp/(sum(counttranstemp(:))));
    
end
counttrans                              =   nanmean(counttransges,3);
[countorig,mid2]                        =   hist3(space(:,1:2),'edges',{minval:(maxval-minval)/(binx-1):maxval minval:(maxval-minval)/(biny-1):maxval});
countorig                               =   100*(countorig/(sum(countorig(:))));
cln2(1:ndims(countorig))                =   {'i'};
    for i                               =   1:length(countorig)
        cln2(1:ndims(countorig))        =   {i};
        histdiag(i,1)                   =   countorig(cln2{:});
        histdiag(i,2)                   =   counttrans(cln2{:});
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if numsurr==0
       
    if plt==1
        figure
        plot(mid{1,1}(:),histdiag(:,1),'linewidth',2)
        hold on
        plot(mid{1,1}(:),histdiag(:,2),'r','linewidth',2)
        legend('original','transformed')
        xlabel('x','fontsize',12)
        ylabel('p(x)','fontsize',12)
        title('Diagonal of phase-space histogram')
        a                               =   get(gca,'XTickLabel');
        set(gca,'XTickLabel',a,'FontName','Times','fontsize',18)
        b                               =   get(gca,'YTickLabel');
        set(gca,'YTickLabel',b,'FontName','Times','fontsize',18)
        hold off
        figure        
        subplot(1,2,2)        
        surf(mid{1,1}(:),mid{1,2}(:),counttrans,'EdgeAlpha',0);
        axis tight
        title('Transformed phase-space histogram')
        view(0,90)
        xlabel('X-Axis','fontsize',12)
        ylabel('Y-Axis','fontsize',12)
        subplot(1,2,1)
        surf(mid2{1,1}(:),mid2{1,2}(:),countorig,'EdgeAlpha',0);
        axis tight
        title('Original phase-space histogram')
        view(0,90)
        xlabel('X-Axis','fontsize',12)
        ylabel('Y-Axis','fontsize',12)        
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif numsurr ~=0
    counttransges                       =   [];
    countsurr                           =   [];
    cfgsurr.mode                        =   surrmode;
    cfgsurr.numit                       =   10;
    reverseStr                          =   '';
    for surrv=1:numsurr
        
        [resultssurr]                   =   nta_surrogates(data',cfgsurr);
        imagev=resultssurr.surr;
        results2                        =   nta_phasespace(imagev,cfgs);
        space2                          =   results2.embTS;
        %space2=fliplr(space2);%%%%%%%%%%%%%%%
        N                               =   length(space2);
        steig2                          =   diff(space2);
        
        transphasespace=zeros(N-2,dim,numit);
        for q=1:numit
            for i=2:N-dim
                an                      =   (inv(steig2(i-1:i+dim-2,:))*steig2(i:i+dim-1,1))';
                an                      =   vertcat(an,erg);
                s                       =   an+((b-a).*rand(dim,dim)+a).*(sum(abs(space2(i+1,:)-space2(i,:))));
                transphasespace(i,1:dim)=   (inv(eye(dim,dim)-s)*(space2(i+1,:)'-s*space2(i,:)'))';
            end
            [counttranssurr,mid]        =   hist3(transphasespace(:,1:2),'edges',{minval:(maxval-minval)/(binx-1):maxval minval:(maxval-minval)/(biny-1):maxval});
            counttransges(:,:,q)        =   100*(counttranssurr/(sum(counttranssurr(:))));
        end
        countsurr(:,:,surrv)            =   nanmean(counttransges,3);
        if verbose==1 
        percentDone                     =   100 * surrv / numsurr;
        msg                             =   sprintf('Percent done: %3.1f', percentDone);
        fprintf([reverseStr, msg]);
        reverseStr                      =   repmat(sprintf('\b'), 1, length(msg));
        end
%         disp(['Percent done: ' num2str(percentDone) ' %'])
    end
   
    %% 
    countsurr                           =   single(countsurr);
    meancountsurr                       =   nanmean(countsurr,dim+1);
    stdcountsurr                        =   nanstd(countsurr,0,dim+1);
    statcount                           =   (counttrans-meancountsurr)./stdcountsurr;
    statcount(counttrans==0 | stdcountsurr==0)=0;
    
    cln2(1:ndims(statcount))            =   {'i'};
    for i=1:length(statcount)
        cln2(1:ndims(statcount))        =   {i};
        histdiagzscores(i)              =   statcount(cln2{:});
    end
    results.histdiagzscores             =   histdiagzscores;
    results.statcount                   =   statcount;
    if plt==1
        figure
        plot(mid{1,1}(:),histdiag(:,1),'linewidth',2)
        hold on
        plot(mid{1,1}(:),histdiag(:,2),'r','linewidth',2)
        legend('Original','Transformed')
        xlabel('x [arb.]','fontsize',12)
        ylabel('p(x) [arb.]','fontsize',12)
        title('Diagonal of phase-space histogram')
        a                               =   get(gca,'XTickLabel');
        set(gca,'XTickLabel',a,'FontName','Times','fontsize',18)
        b                               =   get(gca,'YTickLabel');
        set(gca,'YTickLabel',b,'FontName','Times','fontsize',18)
        hold off        
        figure
        surf(mid{1,1}(:),mid{1,2}(:),statcount,'EdgeAlpha',0);
        view(0,90)
        axis tight
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%generate output structure%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
results.cfg                             =   cfg;
results.cfg.mid2                        =   mid2;
results.bincenters                      =   mid;
results.countorig                       =   countorig;
results.counttrans                      =   counttrans;
results.countsurr                       =   countsurr;
results.histdiag                        =   histdiag;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

