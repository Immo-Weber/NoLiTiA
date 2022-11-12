function [ results ] = entropykozachenko_wo_ps( data,cfg )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Calculation of Shannon entropy using a nearest neighbour estimator
%(Kozachenko and Leonenko,1987).
%   data:                       input data, 1xN, double
%CONFIGURATION STRUCTURE:
%   cfg.dim:                    dimension, 1x1, int, default: 2
%   cfg.tau:                    timelag, 1x1, int, default: 1
%   cfg.mass:                   number of neighbours used for probability density estimation,
%                               1x1, int, default: 4
%   cfg.metric:                 distance norm 'euclidean' or 'maximum', char, default: 'maximum'
%   cfg.verbose:                verbose level [1/0], 1x1, int, default: 1
%OUTPUT:
%   results.cfg:                configuration structure
%   results.Hx:                 Shannon entropy
%   results.SI:                 Shannon information , 1xN, double
%DEPENDENCIES:
%   amutibin, phasespace, neighsearch
%Author: Immo Weber, 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isfield(cfg,'verbose')==1
    verbose                     =   cfg.verbose;
else
    verbose                     =   1;
end
%%%read in parameters%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isfield(cfg,'mass')==1
    mass                        =   cfg.mass;
else
    mass                        =   4;
    if verbose==1
        disp('No number of nearest neighbours specified! Assigning default: 4')
    end
end
if isfield(cfg,'metric')==1
    if strcmp(cfg.metric,'euclidean')==1
        metric                  =   1;
    elseif strcmp(cfg.metric,'maximum')==1
        metric                  =   2;
    end
else
    metric                      =   2;
    if verbose==1
        disp('No distance norm specified! Assigning default: maximum')
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
results                         =   [];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N                               =   size(data,1);
d                               =   size(data,2);

sumdist                         =   neighsearch(data,[1:N]',metric);
sumdist                         =   sort(sumdist);
distance1                       =   sumdist(mass+1,:)';
SI                              =   -(psi(mass)-psi(N)-log(1)-d.*log(2.*distance1));
Hx                              =   -(psi(mass)-psi(N)-log(1)-d*mean(log(2.*distance1)));
%%%generate output structure%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
results.cfg                     =   cfg;
results.Hx                      =   Hx;
results.SI                      =   SI;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

