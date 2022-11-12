function [results]=nta_wind_recfreq(data,cfg)
%Calculates windowed recurrence based quantities with an overlap of half a window. 
%   data:                           input data, 1xN double
%CONFIGURATION STRUCTURE:
%   cfg.tau:                        embedding delay, 1x1, int, default: 0 (optimization)
%   cfg.dim:                        embedding Dimension, 1x1, int, default: 2
%   cfg.en:                         neighbourhood-size in % std of data, 1x1, int, default: 5
%   cfg.window:                     window size in samples.Parameter must be even number, 1x1,
%                                   int, default: 1/10 of data length
%   cfg.fs:                         sampling rate [Hz],1x1, double, default: -
%   cfg.minlengthdet:               minimum length of diagonal lines used for determinism
%                                   quantification, 1x1, int, default: 0 (off)
%   cfg.minlengthlam:               minimum length of vertical lines used for laminarity
%                                   quantification, 1x1, int, default: 0 (off)
%   cfg.minmaxRecPD:                minimum and maximum recurrence periods, 1x2, int,
%                                   default:  [0 0]
%   cfg.singlenei:                  use only nearest neighbour for calculation  of recurrence
%                                   periods yes/no [1/0], 1x1, int, default: 1
%   cfg.norm:                       normalize recurrence frequencies by total possible number of
%                                   recurrences per period bin yes/no [1/0], 1x1, int, default:  0
%   cfg.amplitudes (experimental):  estimate amplitude of recurrences [1/0], 1x1, int,
%                                   default: 1
%   cfg.db:                         export power in dB [1/0],1x1, int, default: 1
%   cfg.outp:                       estimate amplitudes either as magnitude or power [amp/pow],
%                                   char, default, amp
%   cfg.userawamp (experimental):   only use non-weighted amplitudes [1/0], 1x1, int,
%   default: 0
%   cfg.metric:                     distance norm 'euclidean' or 'maximum', char, default: 'maximum'
%   cfg.plt:                        plot windowed recurrence periods: yes/no[1/0], 1x1, int, default: 1
%   cfg.verbose:                    verbose level [1/0], 1x1, int, default: 1
%OUTPUT:
%   results.cfg:                    configuration structure
%   results.time:                   time vector in samples
%   results.resht:                  recurrence period probabilites as a function of periods
%   results.rpde:                   recurrence period density entropy
%   results.rr:                     recurrence rates
%   results.det:                    determinism
%   results.lam:                    laminarity
%   results.ratio:                  ratio of DET and RR
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
    dim                 =   cfg.dim;
else
    cfg.dim             =   2;
end
if isfield(cfg,'tau')==1
    tau                 =   cfg.tau;
else
    cfg.tau             =   0;
end
if isfield(cfg,'fs')==1
    fs                  =   cfg.fs;
else
    fs=NaN;
end
if isfield(cfg,'window')==1
    window              =   cfg.window;
else
    window              =   floor(length(data)/10);
    if mod(window,2)>0
        window          =   window+1;
    end
end
if isfield(cfg,'minmaxRecPD')==1
    mint                =   cfg.minmaxRecPD(1);
    maxt                =   cfg.minmaxRecPD(2);
else
    mint                =   1;
    maxt                =   0;
end
if isfield(cfg,'en')==1
    en                  =   cfg.en;
else
    en                  =   5;
end
if isfield(cfg,'rr')==1
    rr                  =   cfg.rr;
elseif exist('en')==0
    rr                  =   5;
    if verbose==1
        disp('No recurrence rate specified. Assigning default: 5')
    end
else
    rr                  =   0;
end
if isfield(cfg,'norm')==1
    norm                =   cfg.norm;
else
    norm                =   0;
end
if isfield(cfg,'singlenei')==1
    singlenei           =   cfg.singlenei;
else
    singlenei           =   1;
end
if isfield(cfg,'amplitudes')==1
    amplitudes          =   cfg.amplitudes;
else
    amplitudes          =   1;
    cfg.amplitudes      =   amplitudes;
end

if isfield(cfg,'userawamp')==1
    if cfg.userawamp==1
        userawamp       =   'rawamp';
    else
        userawamp       =   'ht';
    end
else
    userawamp           =   'ht';
end

if isfield(cfg,'outp')==1
    outp                =   cfg.outp;
else
    outp                =   'amp';
end

if isfield(cfg,'db')==1
    db                  =   cfg.db;
else
    db=1;
end

if isfield(cfg,'metric')==1
    if strcmp(cfg.metric,'euclidean')==1
        metric          =   1;
    elseif strcmp(cfg.metric,'maximum')==1
        metric          =   2;
    end
else
    metric=2;
    if verbose==1
        disp('No distance norm specified! Assigning default: maximum')
    end
end
if isfield(cfg,'plt')==1
    plt                 =   cfg.plt;
    cfg.plt             =   0;
else
    plt                 =   1;
    cfg.plt             =   0;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
results=[];

[data,nodata]=checkdatainteg(data,cfg,verbose);
if nodata==1
    return
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if verbose==1
disp('Checking window size...')
end

numwin=floor(length(data)/window);

if numwin>=1
    if verbose==1
    disp('Window size OK.')
    end

%%
pending='Calculating: -';
for i=1:numwin-1     
    [results1]                      =   nta_recurrenceplot(data(((i-1)*window)+1:i*window),cfg);
    rr(((i-1)*window)+1:i*window)   =   repmat(results1.rr,window,1);
    det(((i-1)*window)+1:i*window)  =   repmat(results1.det,window,1);
    lam(((i-1)*window)+1:i*window)  =   repmat(results1.lam,window,1);
    ratio(((i-1)*window)+1:i*window)=   repmat(results1.ratio,window,1);
    rpde(((i-1)*window)+1:i*window) =   repmat(results1.rpde,window,1);
     eval(['ht(((i-1)*window)+1:i*window,1:length(results1.ht))=repmat(results1.' userawamp ',window,1);'])
%     ht(((i-1)*window)+1:i*window,1:length(results1.ht))=repmat(results1.(userawamp),window,1);
    
    [results2]                      =   nta_recurrenceplot(data(((i-1)*window)+1+window/2:i*window+window/2),cfg);
    rr2(((i-1)*window)+1:i*window)  =   repmat(results2.rr,window,1);
    det2(((i-1)*window)+1:i*window) =   repmat(results2.det,window,1);
    lam2(((i-1)*window)+1:i*window) =   repmat(results2.lam,window,1);
    ratio2(((i-1)*window)+1:i*window)=  repmat(results2.ratio,window,1);
    rpde2(((i-1)*window)+1:i*window)=   repmat(results2.rpde,window,1);
     eval(['ht2(((i-1)*window)+1:i*window,1:length(results2.ht))=repmat(results2.' userawamp ',window,1);'])
%     ht2(((i-1)*window)+1:i*window,1:length(results2.ht))=repmat(results2.(userawamp),window,1);

    if verbose==1
    pending=[pending '-'];
    disp(pending)
    end
end
%%
if strcmp(outp,'amp')==1
    loght                           =   ht;
    loght                           =   loght';
    loght2                          =   ht2;
    loght2                          =   loght2';
    
elseif strcmp(outp,'pow')==1
    loght                           =   ht.^2;
    loght                           =   loght';
    loght2                          =   ht2.^2;
    loght2                          =   loght2';
end

if db==1
    if strcmp(outp,'amp')==1
        loght                       =   20.*log10(loght);
        loght2                      =   20.*log10(loght2);
    else
        loght                       =   10.*log10(loght);
        loght2                      =   10.*log10(loght2);
    end
end

%%
resht                                   =   nan(size(loght,1),size(loght,2)+window/2,2);
resht(1:size(loght,1),1:size(loght,2),1)=   loght;
resht(1:size(loght,1),1+window/2:length(rpde)+window/2,2)=loght2;
resht                                   =   nanmean(resht,3);

resrr                                   =   nan(size(rr,2)+window/2,2);
resrr(1:size(rr,2),1)                   =   rr;
resrr(1+window/2:length(rr)+window/2,2) =   rr2;
resrr                                   =   nanmean(resrr,2);

resrpde                                 =   nan(size(rpde,2)+window/2,2);
resrpde(1:size(rpde,2),1)               =   rpde;
resrpde(1+window/2:length(rpde)+window/2,2)=rpde2;
resrpde                                 =   nanmean(resrpde,2);

resdet                                  =   nan(size(det,2)+window/2,2);
resdet(1:size(det,2),1)                 =   det;
resdet(1+window/2:length(det)+window/2,2)=  det2;
resdet                                  =   nanmean(resdet,2);

reslam                                  =   nan(size(lam,2)+window/2,2);
reslam(1:size(lam,2),1)                 =   lam;
reslam(1+window/2:length(lam)+window/2,2)=  lam2;
reslam                                  =   nanmean(reslam,2);

resratio                                =   nan(size(ratio,2)+window/2,2);
resratio(1:size(ratio,2),1)             =   ratio;
resratio(1+window/2:length(ratio)+window/2,2)=ratio2;
resratio                                =   nanmean(resratio,2);

a                                       =   sort(resht(:));
noninf                                  =   find(isinf(a)==0);
minval                                  =   a(noninf(1));
resht(isinf(resht)==1)                  =   minval-realmin;


time                                    =   window/2.*repmat(1:2*numwin-1,window/2,1);
time                                    =   time(:);
if maxt==0
    maxt                                =   size(loght,1);
end
%%%plot results%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if plt==1
       
    if isnan(fs)==1
        surf(time,[mint:maxt],resht);
        ylabel('Recurrence period [samples]','fontsize',12)
        xlabel('Time [samples]','fontsize',12);
    else
        surf(time./fs,fs./[results1.cfg.minmaxRecPD(1):results1.cfg.minmaxRecPD(2)],resht);
        ylabel('Recurrence frequency [Hz]','fontsize',12)
        xlabel('Time [s]','fontsize',12);
    end
    axis tight
    shading interp;
    view([0 90])    
    colormap('jet')
    colorbar
end

else
    warning('Computation not possible! Window size too large.')
end
%%%generate output structure%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
results.cfg             =   cfg;
if isnan(fs)==1
results.time            =   time;
results.freq            =   [mint:maxt];
else
   results.time         =   time./fs;
   results.freq         =   fs./[mint:maxt];
end
results.resht           =   resht;
results.rpde            =   resrpde;
results.det             =   resdet;
results.lam             =   reslam;
results.rr              =   resrr;
results.ratio           =   resratio;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end