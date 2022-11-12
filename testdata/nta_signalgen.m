function [ y ] = nta_signalgen(signalinf,sec,fs,noise)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Generates a univariate oscillatory signal, composed of multiple sinusoids
%and noise.
%signalinf: amplitude, frequency, phase, nx3, double
%sec: time length in seconds, 1x1, double
%fs: sampling frequency in Hz, 1x1, int
%noise: amplitude in % STD of sinusoid, 1x1, double
%Author: Immo Weber, 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sampl=sec*fs;
x=0:(sec*2*pi)/sampl:sec*2*pi;
for i=1:size(signalinf,1)
y(i,:)=signalinf(i,1)*sin(signalinf(i,2)*x+signalinf(i,3));
end
y=sum(y,1);
a=-(noise/100)*std(y);
ns=-2*a.*rand(1,length(y))+a;
% ns=rand(1,length(y));
% ns=ns/std(ns);
% y=(noise.*(ns./max(ns)))-mean((noise.*(ns./max(ns))))+y;
y=ns+y;
y=y';
end

