function [results]=nta_ragwitz(data,cfg)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Local constant predictor used for estimation of phase-space embedding parameters (Ragwitz, xxx)
%   data:                               input data, 1xN, double
%CONFIGURATION STRUCTURE:
%   cfg.dims:                           min. & max. embedding dimensions to test, 1x2, int, default: [2 9]
%   cfg.taus:                           vector of tau to scan either in multiple of autocorrelation time in percent
%                                       e.g.[10:10:100] or directly in samples depending on 'mode', int, default: [10:10:100]
%   cfg.mass:                           number of neighbours per point, 1x1, int, default: 4
%   cfg.hor:                            prediction horizon, 1x1, int, default: 1
%   cfg.mode:                           how to define tau (taus). 'samples': taus in samples or 'multi'=
%                                       taus in multiple of autocorrelation time in percent, char, default:
%   'multi'
%   cfg.metric:                         distance norm 'euclidean' or 'maximum', char, default: 'maximum'
%   cfg.plt:                            plot results yes/no [1/0], 1x1, int, default: 0
%   cfg.verbose:                        verbose level [1/0], 1x1, int, default: 1
%OUTPUT:
%   results.cfg:                        configuration structure
%   results.tauopt:                     optimum tau
%   results.dimopt:                     optimum dimension
%   results.rmspe:                      mean squared prediction error normalized to standard deviation of data
%   results.prges:                      first rows: predicted values, second rows: original values ,2xdimsxtaus
%DEPENDENCIES:
%   autocorr, phasespace, neighsearch
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
if isfield(cfg,'dims')==1
    dims                                =   [cfg.dims(1):cfg.dims(2)];
else
    dims                                =   2:9;
    if verbose==1
        disp('No range of dimensions specified! Assigning defaults: 2:9')
    end
end
if isfield(cfg,'taus')==1
    taus                                =   cfg.taus;
else
    taus                                =   10:10:100;
    if verbose==1
        disp('No range of lags specified! Assigning defaults: 10:10:100')
    end
end
if isfield(cfg,'numran')==1
    numran                              =   cfg.numran;
else
    numran                              =   0;
    if verbose==1
        disp('No number of random query points specified! Assigning defaults: 100')
    end
end
if isfield(cfg,'mass')==1
    mass                                =   cfg.mass;
else
    mass                                =   4;
    if verbose==1
        disp('No number of neighbours specified! Assigning defaults: 4')
    end
end
if isfield(cfg,'hor')==1
    hor                                 =   cfg.hor;
else
    hor                                 =   1;
    if verbose==1
        disp('No prediction horizon specified! Assigning defaults: 1')
    end
end
if isfield(cfg,'mode')==1
    mode                                =   cfg.mode;
else
    mode                                =   'multi';
    if verbose==1
        disp('No mode for lags specified! Assigning defaults: multi')
    end
end
if isfield(cfg,'th')==1
    th                                  =   cfg.th;
else
    th                                  =   0;
    if verbose==1
        disp('No Theiler window specified! Assigning defaults: 0')
    end
end
if isfield(cfg,'metric')==1
    if strcmp(cfg.metric,'euclidean')==1
        metric                          =   1;
    elseif strcmp(cfg.metric,'maximum')==1
        metric                          =   2;
    end
else
    metric                              =   2;
    if verbose==1
        disp('No distance norm specified! Assigning default: maximum')
    end
end
if isfield(cfg,'plt')==1
    plt                                 =   cfg.plt;
else
    plt                                 =   0;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
results                                 =   [];

[data,nodata]                           =   checkdatainteg(data,cfg,verbose);
if nodata==1
    return
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nn                                      =   1;
cfgac                                   =   [];
[a]                                     =   nta_autocorr(data,cfgac);
if th==0
    th                                  =   find(a<0,1,'first');
end
zerocr                                  =   find(a<=1/exp(1),1,'first');

if strcmp(mode,'samples')==1
    tauvec                              =   taus;
else
    taus                                =   taus./100;
    tauvec                              =   ceil(taus.*zerocr);
end

maxn                                    =   length(data)-(tauvec(end)*dims(end)*((dims(end)-1)/dims(end)));
if maxn<numran
    numran                              =   maxn-1;
end
if numran==0
    out                                 =   1:maxn-hor;
    numran                              =   length(out);
else
    out                                 =   randperm(maxn-hor,numran);
end
tauvec                                  =   unique(tauvec);
reverseStr                              =   '';
steps                                   =   length(dims)*length(tauvec);
cfgs.verbose                            =   verbose;
for jj=1:length(dims)
    for qq=1:length(tauvec)
        cfgs.dim                        =   dims(jj);
        cfgs.tau                        =   tauvec(qq);
        cfgs.verbose                    =   0;
        results                         =   nta_phasespace(data,cfgs);
        space                           =   results.embTS;
        space                           =   flipud(space);
        space                           =   space(1:maxn,:);
        space                           =   flipud(space);
        
        orig                            =   space(out+hor,1);
        spacetemp                       =   space(1:end-hor,:);
        
        distance                        =   nta_neighsearch(spacetemp,out',metric);
        [~,index]                       =   sort(distance);
        index                           =   (index(2:mass+1,:))';
        
        for i=1:numran
            pr(i,1)                     =   sum(space(index(i,:)+hor,1))./mass;
        end
        rmspe(jj,qq)                    =   (sum((pr-orig).^2)/numran)/std(data);
        prges{1,jj,qq}                  =   pr;
        prges{2,jj,qq}                  =   orig;
        nn                              =   nn+1;
        if verbose==1 
        percentDone                     = 100 * nn / steps;
%         msg = sprintf('Percent done: %3.1f', percentDone); %Don't forget this semicolon
%         fprintf([reverseStr, msg]);
%         reverseStr = repmat(sprintf('\b'), 1, length(msg));
   
        msg                         =   sprintf('Percent done: %3.1f', percentDone);
        fprintf([reverseStr, msg]);
        reverseStr                  =   repmat(sprintf('\b'), 1, length(msg));
%  disp(['Percent done: ' num2str(percentDone) ' %'])
        end
    end
end
[a,b]                                   =   find(rmspe==min(min(rmspe)));
prges{3,1,1}                            =   prges{1,a,b};
prges{4,1,1}                            =   prges{2,a,b};
dimopt                                  =   dims(a);
tauopt                                  =   tauvec(b);

if length(dimopt)>1
    dimopt                              =   dimopt(1);
end

if length(tauopt)>1
    tauopt                              =   tauopt(1);
end


if verbose==1
disp(['The optimal Tau is probably: ' num2str(tauopt)])
disp(['The optimal Dimension is probably: ' num2str(dimopt)])
end

%%%plot results%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if plt==1
imagesc(tauvec,dims,rmspe);
axis square
xlabel('Tau [samples]','fontsize',12)
ylabel('Dimension [arb.]','fontsize',12)
a                                       = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',18)
b                                       = get(gca,'YTickLabel');
set(gca,'YTickLabel',b,'FontName','Times','fontsize',18)
end
%%%generate output structure%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
results.cfg                             =   cfg;
results.tauvec                          =   tauvec;
results.tauopt                          =   tauopt;
results.dimopt                          =   dimopt;
results.rmspe                           =   rmspe;
results.prges                           =   prges;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end