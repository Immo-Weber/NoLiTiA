function [ Rmm] = nta_autocorr(data,cfg )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Calculates the autocorrelation as a function of delays.
%   data: input data, 1xN, double
%CONFIGURATION STRUCTURE:
%   cfg.lag: number of temporal lags in samples, 1x1, int
%OUTPUT:
%   Rmm: one-sided autocorrelation as a function of temporal lag in samples
%DEPENDENCIES:
%   xcorr
%Author: Immo Weber, 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isfield(cfg,'lag')==1
lag=cfg.lag;
else
    lag=round(length(data)/2);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [Rmm,lags] = xcorr(data(1:lag+1),'coeff');
[Rmm] = nta_crosscorr(data,lag);
% Rmm = Rmm(lags>=0);
end

