function [results]=nta_timerev(data,cfg)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Test for time reversibility. In conjunction with appropriate surrogates,
%timerev can be used to test for nonlinearity (H0 = linear dynamics, alpha=0.05). 
%See (xxx) for reference.
%   data:                           dataset, 1xN, double
%CONFIGURATION STRUCTURE:
%   cfg.lag:                        delay, 1x1, int, default: 1
%   cfg.numsurr:                    number of surrogates, 1x1, int, default: 100
%   cfg.surrmode:
%       mode==1                         random shuffling
%       mode==2                         phase randomization
%       mode==3                         amplitude adjusted phase randomization
%       mode==4                         cut time series at random point and flip second half
%       mode==5                         cut time series at random point and switch halves, 1x1,  int,
%                                       default: 2
%   cfg.numit:                      Number of iterations for amplitude adjustement
%                                   (mode==3),1x1,int, default: 10
%   cfg.verbose:                    verbose level [1/0], 1x1, int, default: 1
%OUTPUT:
%   results.cfg:                    configuration structure
%   results.Qt:                     time reversibility statistic
%   results.zstat:                  z-score of surrogate test
%   results.sig:                    H0 rejected [1] or not [0] (two-sided)
%   results.p:                      p-value
%DEPENDENCIES:
%   surrogates
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
if isfield(cfg,'lag')==1
    lag                             =   cfg.lag;
else
    lag                             =   1;
    if verbose==1
        disp('No lag specified. Assigning default: 1')
    end
end
if isfield(cfg,'numsurr')==1
    numsurr                         =   cfg.numsurr;
else
    numsurr                         =   100;
    if verbose==1
        disp('No number of surrogates specified. Assigning default: 100')
    end
end
if isfield(cfg,'surrmode')==1
    mode                            =   cfg.surrmode;
else
    mode                            =   2;
    if verbose==1
        disp('No surrogate mode specified. Assigning default: 2 (phase-randomization)')
    end
end
if isfield(cfg,'numit')==1
    numit                           =   cfg.numit;
else
    numit                           =   10;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
results                             =   [];

[data,nodata]                       =   checkdatainteg(data,cfg,verbose);
if nodata==1
    return
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sig                                 =   0;
p                                   =   1;
zstat                               =   0;
x                                   =   flipud(data);
cfgsurr.mode                        =   mode;
cfgsurr.numit                       =   numit;
x                                   =   zscore(x);
reverseStr                          =   '';
for q=1:length(lag)
    Qtsurr                          =   [];
    Qt(q)                           =   mean((diff(x,lag(q))).^3);%./mean((diff(x,lag(q))).^2);
    if numsurr>0
        for i=1:numsurr
            resultstemp             =   nta_surrogates(x,cfgsurr);
            temp                    =   resultstemp.surr;
            temp                    =   zscore(temp);
            Qtsurr(i)               =   mean((diff(temp,lag(q))).^3);%./mean((diff(temp,lag(q))).^2);
            if verbose==1 
            percentDone                     =   100 * i / numsurr;
            msg                         =   sprintf('Percent done: %3.1f', percentDone);
            fprintf([reverseStr, msg]);
            reverseStr                  =   repmat(sprintf('\b'), 1, length(msg));
            end
        end
        meansurr(q)                 =   mean(Qtsurr);
        stdsurr(q)                  =   std(Qtsurr);
        zstat(q)                    =   (Qt(q)-meansurr(q))./stdsurr(q);
        if zstat(q)<-1.96 | zstat(q)>1.96
            sig(q)                  =   1;            
        end
        p(q)                    =   2*normcdf(-abs(zstat(q)));
        if p(q)>1
            p(q)=1;
        end
    end
    
end
%%%generate output structure%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
results.cfg                         =   cfg;
results.Qt                          =   Qt;
results.Qtsurr                      =   Qtsurr;
results.zstat                       =   zstat;
results.sig                         =   sig;
results.p                           =   p;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
end
