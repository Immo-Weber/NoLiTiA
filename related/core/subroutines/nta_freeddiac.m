function [optbinnum]=nta_freeddiac(data)
%This function calculates the optimal number of bins
%for histograms by using the freedman-diaconis-rule
%Author: Immo Weber, 2018
N=length(data);
data=sort(data);
uq=floor(0.25*N*1);
oq=floor(0.75*N+1);
iqr=data(oq)-data(uq);
h=2*iqr*N^(-1/3);
optbinnum=floor((max(data)-min(data))/h);
if optbinnum==0 | isinf(optbinnum) | optbinnum==1 | isnan(optbinnum)==1
    optbinnum=2;
end
end