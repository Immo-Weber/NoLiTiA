function [results]=nta_crossrecurrenceplot(data1,data2,cfg)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Calculates a cross recurrence plot and recurrence based measures.
%   data1:                              input data, 1xN double
%   data2:                              input data, 1xN double
%CONFIGURATION STRUCTURE:
%   cfg.tau:                            embedding delay, 1x1, int, default: 1
%   cfg.dim:                            embedding Dimension, 1x1, int, default: 2
%   cfg.en:                             neighbourhood-size in % std of data, 1x1,  int, default: 0
%   cfg.rr:                             recurrence rate in % of total possible rr, 1x1, int, default: 5
%   cfg.minlengthdet:                   minimum length of diagonal lines used for determinism
%                                       quantification, 1x1, int, default: 0 (off)
%   cfg.minlengthlam:                   minimum length of vertical lines used for laminarity
%                                       quantification, 1x1, int, default: 0 (off) 
%   cfg.minmaxRecPD:                    minimum and maximum recurrence periods, 1x2, int,
%                                       default: [0 0]
%   cfg.singlenei:                      use only nearest neighbour for calculation  of recurrence
%                                       periods yes/no [1/0], 1x1, int, default:
%   cfg.norm:                           normalize recurrence frequencies by total possible number of
%                                       recurrences per period bin yes/no [1/0], 1x1, int, default:
%   cfg.plt:                            plot results yes/no [1/0], 1x1, int, default: 1
%   cfg.verbose:                        verbose level [1/0], 1x1, int, default: 1
%OUTPUT:
%   results.cfg:                        configuration structure
%   results.rr:                         recurrence rate
%   results.det:                        determinism
%   results.lam:                        laminarity
%   results.ratio:                      The ratio between det and rr
%   results.sumdist:                    thresholded recurrence matrix
%   results.alldist:                    untresholded recurrence matrix
%   results.ht:                         recurrence period probabilites as a function of periods
%   results.gaco:                       generalized autocorrelation as a function of lags
%   results.rpde:                       recurrence period density entropy
%DEPENDENCIES:
%   amutibin, phasespace, recurrenceplot
%Author: Immo Weber, 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isfield(cfg,'verbose')==1
    verbose=cfg.verbose;
else
    verbose=1;
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
    dim                         =   max(cfg.dim);
else
    dim                         =   2;
end
if isfield(cfg,'tau')==1
    tau                         =   mean(cfg.tau);
else
    tau                         =  1;
end
if isfield(cfg,'en')==1
    en                          =   cfg.en;
else
    en                          =   0;
end
if isfield(cfg,'rr')==1
    rr                          =   cfg.rr;
elseif exist('en')==0
    rr                          =   5;
else
    rr                          =   0;
end
if isfield(cfg,'minlengthdet')==1
    minlengthdet                =   cfg.minlengthdet;
else
    minlengthdet                =   0;
end
if isfield(cfg,'minlengthlam')==1
    minlengthlam                =   cfg.minlengthlam;
else
    minlengthlam                =   0;
end
if isfield(cfg,'plt')==1
    plt                         =   cfg.plt;
else
    cfg.plt                     =   1;
end
%%%if no Tau is provided the first minimum of the auto mutual information%%
%%%is used%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if tau==0
    cfgami.numbin               =   10;
    cfgami.time                 =   length(data1)/2;
    cfgami.plt                  =   0;
    cfgami.verbose              =   verbose;
    [ resultsami ]              =   nta_amutibin( data1,cfgami);
    tau                         =   resultsami.firstmin;
    if verbose==1
    disp(['The best lag is probably' ' ' num2str(tau)])
    end
end
%%%phase-space reconstruction%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cfgs.dim                        =   dim(1);
cfgs.tau                        =   tau(1);

results1                        =   nta_phasespace(data1,cfgs);                 
space1                          =   results1.embTS;
results2                        =   nta_phasespace(data2,cfgs);
space2                          =   results2.embTS;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N                               =   length(space1);
mat                             =   [];
sumdist                         =   zeros(N,N);
for j=1:N
    K                           =   ones(N,1)*space2(j,:);
    Distanz                     =   sqrt(sum((space1-K).^2,2));
    sumdist(:,j)                =   Distanz;
end
if rr~=0
    sortdist                    =   sort(sumdist(:));
    indtemp                     =   (rr/100)*(N^2);
    en                          =   sortdist(floor(indtemp));
else
    groesse                     =   std(data1);
    en                          =   (en*groesse)/100;
end

if cfg.plt==1
c                               =   length(sumdist);
figure
ax1                             =   subplot(2,2,1);
imagesc((1:c),(1:c),flipud(sumdist))
axis square
colormap(ax1,jet);
set(gca,'XTick',0:floor((c+1)/10)+1:(c+1),'YTick',0:floor((c+1)/10)+1:(c+1),...
        'XLim',[0 c+1],'YLim',[0 c+1],'YDir','normal');
    xlabel('State i [samples]','fontsize',12)
    ylabel('State j [samples]','fontsize',12)
end
sumdist                         =   sumdist>en;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cfgcross                        =   cfg;
cfgcross.plt                    =   cfg.plt;
cfgcross.amplitudes             =   0;
% cfgcross.minlengthdet=minlengthdet;
% cfgcross.minlengthlam=minlengthlam;
[results]                       =   nta_recurrenceplot(sumdist,cfgcross);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end