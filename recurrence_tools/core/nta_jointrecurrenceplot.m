function [results]=nta_jointrecurrenceplot(data1,data2,cfg)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Calculates a joint recurrence plot and recurrence based measures.
%   data1:                          input data, 1xN double
%   data2:                          input data, 1xN double
%CONFIGURATION STRUCTURE:
%   cfg.taus:                       embedding delay, 1x2, int, default: [0 0] (optimization)
%   cfg.dims:                       embedding Dimension, 1x2, int, default: [2 2]
%   cfg.ens:                        neighbourhood-size in % std of data, 1x2,  int,
%                                   default:[0 0]
%   cfg.rrs:                        recurrence rate in % of total possible rr, 1x2, int, default: [5 5]
%   cfg.minmaxRecPD:                minimum and maximum recurrence periods, 1x2, int,
%                                   default:[0 0]
%   cfg.minlengthdet:               minimum length of diagonal lines used for determinism
%                                   quantification, 1x1, int, default: 0 (off)
%   cfg.minlengthlam:               minimum length of vertical lines used for laminarity
%                                   quantification, 1x1, int, default: 0 (off)   
%   cfg.singlenei:                  use only nearest neighbour for calculation  of recurrence
%                                   periods yes/no [1/0], 1x1, int, default: [1 1]
%   cfg.norm:                       normalize recurrence frequencies by total possible number of
%                                   recurrences per period bin yes/no [1/0], 1x1, int, default: [0 0]
%   cfg.metric:                     distance norm 'euclidean' or 'maximum', char, default: 'maximum'
%   cfg.plt:                        plot results yes/no [1/0], 1x1, int, default: 1
%   cfg.verbose:                    verbose level [1/0], 1x1, int, default: 1
%OUTPUT:
%   results.cfg:                    configuration structure
%   results.rr:                     recurrence rate
%   results.det:                    determinism
%   results.lam:                    laminarity
%   results.ratio:                  The ratio between det and rr
%   results.sumdist:                thresholded recurrence matrix
%   results.alldist:                untresholded recurrence matrix
%   results.ht:                     recurrence period probabilites as a function of periods
%   results.gaco:                   generalized autocorrelation as a function of lags
%   results.rpde:                   recurrence period density entropy
%DEPENDENCIES:
%   recurrenceplot
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
cfg1.verbose                        =   verbose;
cfg2.verbose                        =   verbose;
if isfield(cfg,'dims')==1
cfg1.dim                            =   cfg.dims(1);
cfg2.dim                            =   cfg.dims(2);
else
    cfg1.dim                        =   2;
    cfg2.dim                        =   2;
    if verbose==1
    disp('No dimensions specified. Assigning defaults: [2 2]')
    end
end
if isfield(cfg,'taus')==1
cfg1.tau                            =   cfg.taus(1);
cfg2.tau                            =	cfg.taus(2);
else
    cfg1.tau                        =   0;
    cfg2.tau                        =   0;
    if verbose==1
    disp('No delays specified. Assigning defaults: [0 0](optimization))')
    end
end
if isfield(cfg,'ens')==1
cfg1.en                             =   cfg.ens(1);
cfg2.en                             =   cfg.ens(2);
else
    cfg1.en                         =   0;
    cfg2.en                         =   0;
    if verbose==1
    disp('No neighbourhood-sizes specified. Assigning defaults: [0 0]')
    end
end
if isfield(cfg,'minmaxRecPD')==1
minRecPD                            =   cfg.minmaxRecPD(1);
maxRecPD                            =   cfg.minmaxRecPD(2);
else
    minRecPD                        =   0;
    maxRecPD                        =   0;
    if verbose==1
    disp('No range of recurrence periods specified. Assigning defaults: min max')
    end
end
if isfield(cfg,'rrs')==1
cfg1.rr                             =   cfg.rrs(1);
cfg2.rr                             =   cfg.rrs(2);
elseif isfield(cfg1,'en')==0
    cfg1.rr                         =   5;
    cfg2.rr                         =   5;
    if verbose==1
    disp('No recurrence rates specified. Assigning defaults: [5 5]')
    end    
end
if isfield(cfg,'minlengthdet')==1
cfg1.minlengthdet                   =   cfg.minlengthdet;
cfg2.minlengthdet                   =   cfg.minlengthdet;
else
    cfg1.minlengthdet               =   0;
    cfg2.minlengthdet               =   0;
    if verbose==1
    disp('No diagonal line length specified. Assigning defaults: 0')
    end
end
if isfield(cfg,'minlengthlam')==1
cfg1.minlengthlam                   =   cfg.minlengthlam;
cfg2.minlengthlam                   =   cfg.minlengthlam;
else
    cfg1.minlengthlam               =   0;
    cfg2.minlengthlam               =   0;
    if verbose==1
    disp('No vertical line length specified. Assigning defaults: 0')
    end
end
if isfield(cfg,'metric')==1
cfg1.metric                         =   cfg.metric;
cfg2.metric                         =   cfg.metric;
else
    cfg1.metric                     =   'maximum';
    cfg2.metric                     =   'maximum';
    if verbose==1
      disp('No distance norm specified! Assigning default: maximum')
    end
end
if isfield(cfg,'plt')==0
cfg.plt                             =   1;
end
cfg1.plt                            =   0;
cfg2.plt                            =   0;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[results1]                                  =   nta_recurrenceplot(data1,cfg1);
[results2]                                  =   nta_recurrenceplot(data2,cfg2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
sumdist1                                    =   results1.sumdist;
sumdist2                                    =   results2.sumdist;
complength(1)                               =   length(sumdist1);
complength(2)                               =   length(sumdist2);
complength                                  =   min(complength);

sumdist1                                    =   sumdist1(1:complength,1:complength);
sumdist2                                    =   sumdist2(1:complength,1:complength);

sumdist1                                    =   1-sumdist1;
sumdist2                                    =   1-sumdist2;

jointsumdist                                =   sumdist1.*sumdist2;
jointsumdist                                =   1-jointsumdist;
if cfg.plt==1
figure
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cfgjoint                                    =   cfg;
cfgjoint.plt                                =   cfg.plt;
cfgjoint.amplitudes                         =   0;
cfgjoint.minlengthdet                       =   cfg1.minlengthdet;
cfgjoint.minlengthlam                       =   cfg1.minlengthlam;
cfgjoint.minmaxRecPD                        =   [minRecPD maxRecPD];
[results]                                   =   nta_recurrenceplot(jointsumdist,cfgjoint);
end