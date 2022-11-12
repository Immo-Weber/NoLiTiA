function [ results ] = nta_optimize_embedding( data,cfg )
%This function optimizes embedding parameters (dimension and tau. See (Cao, 1997)
%and (Ragwitz & Kantz, 2002) for reference.
%   data: input data, 1xN, double
%CONFIGURATION STRUCTURE:
%   cfg.optimization: choose optimization procedure 'deterministic' 
%   (false nearest neighbours(dimension) & auto-mutual information (tau))
%   or 'markov' (Ragwitz estimator (dimension & tau)),char,  default:
%   'deterministic'
%   Deterministic:
%       FNN parameter:
%           cfg.dim: max embedding dimensions to test, 1x1, int, default: 9
%           cfg.Rtol: Threshold Parameter for distance, 1x1, double, default: 10
%           cfg.Atol: Threshold Parameter for loneliness criterion, 1x1, double, default: 2
%           cfg.thr:  Threshold for first minimum in % fnn, 1x1 double, default: 1
%       Auto-mutual information parameter:
%           cfg.numbin: number of bins, 1x1, int, default: 0
%   Markov:
%       Ragwitz parameter:
%       cfg.dims: min. & max. embedding dimensions to test, 1x2, int, default: [2 9]
%       cfg.taus: vector of tau to scan either in multiple of autocorrelation time in percent
%       e.g.[10:10:100] or directly in samples depending on 'mode', int, default: [10:10:100]
%       cfg.mass: number of neighbours per point, 1x1, int, default: 4
%       cfg.hor: prediction horizon, 1x1, int, default: 1
%       cfg.mode: how to define tau (taus). 'samples': taus in samples or 'multi'=
%       taus in multiple of autocorrelation time in percent, char, default:
%       'multi'
%   cfg.embed: embed time series yes/no [1/0], 1x1, int, default: 0
%OUTPUT:
%   results.cfg: configuration structure
%   results.optdim: optimized embedding dimension
%   results.opttau: optimized embedding delay
%DEPENDENCIES:
%   fnn, amutibin, ragwitz, phasespace
%Author: Immo Weber, 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isfield(cfg,'verbose')==1
    verbose=cfg.verbose;
else
    verbose=1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if verbose==1
disp('       _  __       __    _  ______ _  ___        ');
disp('      / |/ /___   / /   (_)/_  __/(_)/ _ |       ');
disp('     /    // _ \ / /__ / /  / /  / // __ |       ');
disp('    /_/|_/ \___//____//_/  /_/  /_//_/ |_|       ');
disp('                                                 ');
end
%%%read in parameters%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isfield(cfg,'optimization')
optimization=cfg.optimization;
else
    optimization='deterministic';
    disp('No mode specified. Assigning default: deterministic')
end
if isfield(cfg,'embed')
embed=cfg.embed;
else
    embed=0;
    %disp('No mode specified. Assigning default: deterministic')
end
cfg.verbose=0;

if strcmp('deterministic',optimization)==1
    [resultsfnn]=nta_fnn(data,cfg);
    optdim=resultsfnn.firstmin;
    cfg.plt=0;
    [resultsami] = nta_amutibin( data,cfg);
    opttau=resultsami.firstmin;
elseif strcmp('markov',optimization)==1
    [resultsrag]=nta_ragwitz(data,cfg);
    optdim=resultsrag.dimopt;
    opttau=resultsrag.tauopt;
else
    f = errordlg('Unknown optimization method! Use either "determinsitic" or "markov"', 'Error');
end

if verbose==1
disp(['The optimum tau is probably: ' num2str(opttau)]);
disp(['The optimum dimension is probably: ' num2str(optdim)]);
end
cfgps.dim=optdim;
cfgps.tau=opttau;
if embed==1
[results]=nta_phasespace(data,cfgps);
end
%%%generate output structure%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
results.cfg=cfg;
results.optdim=optdim;
results.opttau=opttau;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

