function [results]=information_windowing(cfg,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Wrapper function to analyze information theoretic measures time resolved.
%Compatible functions: entropybin, entropykozachenko, amutibin,
%amutiembknn, MIbin, MIkraskov, AIS
%   varargin: Either one or two Nx1 time series (depending on input
%   function), e.g.: [results]=NoLiTiA_windowing(cfg,data1,data2) for MIbin
%CONFIGURATION STRUCTURE:
%   cfg.name: name of function, char
%   cfg.window: window length in samples, 1x1, int, default: 100
%   Also pass the individual parameters of the function to analyze.
%OUTPUT:
%   results.cfg: configuration structure
%   results.HX: Shannon entropy
%   results.firstmin: first minimum of auto-mutual information
%   results.MI: Mutual information
%   results.AIS: Active information storage
%   results.time: time in samples
%DEPENDENCIES:
%   entropybin, entropykozachenko, amutibin, amutiembknn, MIbin, MIkraskov, AIS
%Author: Immo Weber, 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
window=cfg.window;
name=cfg.name;
data1=varargin{1};
if nargin>2
    data2=varargin{2};
end

if strcmp(name,'entropybin')==1 | strcmp(name,'entropykozachenko')==1
    field='Hx';
elseif strcmp(name,'AIS')==1
    field='AIS';
elseif strcmp(name,'amutibin')==1 | strcmp(name,'amutiembknn')==1
    field='firstmin';
elseif strcmp(name,'MIbin')==1 | strcmp(name,'MIkraskov')==1
    field='MI';
end

numwin=floor(length(data1)/window);

if strcmp(name,'MIbin')==0 & strcmp(name,'MIkraskov')==0
    for i=1:numwin-1
        results1=eval([name '(data1(((i-1)*window)+1:i*window),cfg)']);
        temp(((i-1)*window)+1:i*window)=eval(['repmat(results1.' field ',window,1)']);
        results2=eval([name '(data1(((i-1)*window)+1+window/2:i*window+window/2),cfg)']);
        temp2(((i-1)*window)+1:i*window)=eval(['repmat(results2.' field ',window,1)']);
    end
else
    for i=1:numwin-1
        results1=eval([name '(data1(((i-1)*window)+1:i*window),data2(((i-1)*window)+1:i*window),cfg)']);
        temp(((i-1)*window)+1:i*window)=eval(['repmat(results1.' field ',window,1)']);
        results2=eval([name '(data1(((i-1)*window)+1+window/2:i*window+window/2),data2(((i-1)*window)+1+window/2:i*window+window/2),cfg)']);
        temp2(((i-1)*window)+1:i*window)=eval(['repmat(results2.' field ',window,1)']);
    end
end
time=window/2.*repmat(1:2*numwin-1,window/2,1);
time=time(:);
ges=nan(size(temp,2)+window/2,2);
ges(1:size(temp,2),1)=temp;
ges(1+window/2:length(temp)+window/2,2)=temp2;
%%generate output structure%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
eval(['results.' field '=nanmean(ges,2)']);
results.time=time;
results.cfg=cfg;
end