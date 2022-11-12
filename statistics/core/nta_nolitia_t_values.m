function [results] = nolitia_t_values(data1,data2,dim,nobs)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

df=nobs-1;
diff_val=data1-data2;
mdiff = sum(diff_val,dim)./nobs;
  vdiff = sum(abs(diff_val - sum(diff_val,dim)./nobs).^2, dim) ./ df;
 results.stat  = sqrt(nobs).*mdiff./sqrt(vdiff);
%     results.p = 2*tcdf(-abs(results.stat),df);


