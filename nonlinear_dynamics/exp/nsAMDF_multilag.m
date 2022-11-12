function [ results ] = nsAMDF_multilag(data,cfg)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

for l=1:cfg.maxlag+1
    cfg.tau=l-1;
    temp=nsAMDF(data,cfg);
    results.sx(l,2)=temp.sx1;
    results.sx(l,1)=temp.sx2;
end

results.sx=results.sx./max(results.sx);
results.L=diff(results.sx');

end

