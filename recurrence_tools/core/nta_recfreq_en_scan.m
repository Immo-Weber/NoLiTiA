function [results]=nta_recfreq_en_scan(data,cfg)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Calculates different recurrence based quantities over a range of 
%neighbourhood-sizes.
%   data:                           input data, 1xN double
%CONFIGURATION STRUCTURE:
%   cfg.tau:                        embedding delay, 1x1, int, default: 0 (optimization)
%   cfg.dim:                        embedding Dimension, 1x1, int, default: 2
%   cfg.ens:                        neighbourhood-size in % std of data. 
%                                   Specify minimum size, stepsize and maximum size, 1x3,  int, default: [1 1 101]
%   cfg.minmaxRecPD:                minimum and maximum recurrence periods, 1x2, int,
%                                   default: [0 0]
%   cfg.singlenei:                  use only nearest neighbour for calculation  of recurrence
%                                   periods yes/no [1/0], 1x1, int, default: 1
%   cfg.norm:                       normalize recurrence frequencies by total possible number of
%                                   recurrences per period bin yes/no [1/0], 1x1, int, default: 0
%   cfg.metric:                     distance norm 'euclidean' or 'maximum', char, default: 'maximum'
%   cfg.plt:                        plot results yes/no [1/0], 1x1, int, default: 1
%   cfg.verbose:                    verbose level [1/0], 1x1, int, default: 1
%OUTPUT:
%   results.cfg:                    configuration structure
%   results.rr:                     recurrence rate
%   results.loght:                  log of recurrence period probabilites as a function of periods
%   results.gaco:                   generalized autocorrelation as a function of lags
%   results.rpde:                   recurrence period density entropy
%DEPENDENCIES:
%   recurrenceplot
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
dim=cfg.dim;
else
    dim=2;
end
if isfield(cfg,'tau')==1
tau=cfg.tau;
else
    tau=0;
end
if isfield(cfg,'ens')==1
umin=cfg.ens(1);
ustep=cfg.ens(2);
umax=cfg.ens(3);
else
    umin=1;
    ustep=1;
    umax=101;
end
if isfield(cfg,'minmaxRecPD')==1
mint=cfg.minmaxRecPD(1);
maxt=cfg.minmaxRecPD(2);
else
    mint=0;
    maxt=0;
end
if isfield(cfg,'norm')==1
norm=cfg.norm;
else
    norm=0;
end

if isfield(cfg,'metric')==1
metric=cfg.metric;
else
    metric='maximum';
end

if isfield(cfg,'singlenei')==1
singlenei=cfg.singlenei;
else
    singlenei=1;
end
if isfield(cfg,'plt')==1
plt=cfg.plt;
else
    plt=1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
results=[];

[data,nodata]=checkdatainteg(data,cfg,verbose);
if nodata==1
    return
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


rdrpde=nan(3,length([umin:ustep:umax]));
rdrpde(3,:)=[umin:ustep:umax];

n=1;
%% 

cfgs.dim=dim;
cfgs.tau=tau;
cfgs.en=0;
cfgs.rr=0;
cfgs.mint=mint;
cfgs.maxt=maxt;
cfgs.singlenei=singlenei;
cfgs.norm=norm;
cfgs.plt=0;
cfgs.metric=metric;
cfgs.verbose=0;
cfgs.amplitudes=cfg.amplitudes;


reverseStr = '';
steps = length([umin:ustep:umax]);
for i=umin:ustep:umax
    cfgs.en=i;
    [results]=nta_recurrenceplot(data,cfgs);
    gaco(n,1:length(results.gaco))=results.gaco;
    ht(n,1:length(results.ht))=results.ht;
    rpde(n)=results.rpde;
    rr(n)=results.rr;
    det(n)=results.det;
    lam(n)=results.lam;
    ratio(n)=results.ratio;
    if verbose==1 
    percentDone = 100 * n / steps;
    msg = sprintf('Percent done: %3.1f', percentDone); 
    fprintf([reverseStr, msg]);
    reverseStr = repmat(sprintf('\b'), 1, length(msg));
    end
    n=n+1;
end
%%

loght=log10(ht);
%%%plot results%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if plt==1
    pcolor(1:size(loght,2),umin:ustep:umax,loght)
    shading interp
    set(gca, 'XScale', 'log')
    view(180,-90)
    xlabel('Recurrence period [samples]','fontsize',12)
    ylabel('Scale [%]','fontsize',12)
    set(gca,'TickDir','out')
    box off
    colorbar
end
%%%generate output structure%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
results=[];
results.cfg=cfg;
results.loght=loght;
results.ens=umin:ustep:umax;
results.gaco=gaco;
results.rpde=rpde;
results.rr=rr;
results.det=det;
results.lam=lam;
results.ratio=ratio;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end