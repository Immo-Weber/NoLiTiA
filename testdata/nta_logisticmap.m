function [y]=nta_logisticmap(numit,r)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This function computes the logistic map or "Verhulst equation". 
%INPUT:
%   numit: number of iterations, 1x1, int
%   r: control parameter (chaotic behavior @ r>3.57), 1x1, double
%OUTPUT:
%   y: iterated time series
%Author: Immo Weber, 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
y(1,1)=0.4;
for i=1:numit
    y(i+1,1)=r*y(i,1)*(1-y(i,1));
end
end