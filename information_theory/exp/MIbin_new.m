function [ results ] = MIbin_new(data1,data2,cfg)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Calculation of mutual information between two signal using a binning
%estimator.
%   data1: input data, 1xN, double
%   data1: input data, 1xM, double
%%CONFIGURATION STRUCTURE:
%   cfg.numbin: number of bins,  1x1, int, default: 0 (optimization using Freedman-Diaconis rule)
%   cfg.verbose: verbose level [1/0], 1x1, int, default: 1
%OUTPUT:
%   results.cfg: configuration structure
%   results.MI: Mutual information [bit], 1x1, double
%   results.lMI: Local mutual information [bit], 1xN, double
%   results.jp: Joint probabilities, numbin x numbin
%   results.m1: marginal probability 1, 1xnumbin
%   results.m2:  marginal probability 2,1xnumbin
%DEPENDENCIES:
%   freeddiac
%Author: Immo Weber, 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isfield(cfg,'verbose')==1
    verbose=cfg.verbose;
else
    verbose=1;
end
%%%read in parameters%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isfield(cfg,'numbin')==1
    numbin=cfg.numbin;
else
    numbin=[0 0];
    if verbose==1
        disp('No number of bins specified! Assigning default: 0 (optimization)')
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% data1=(data1-mean(data1))./std(data1);
% data2=(data2-mean(data2))./std(data2);


if sum(isnan(data1))==1
[row1, col1] = find(isnan(data1));
data1(row1)=[];
data2(row1)=[];
end

if sum(isnan(data2))==1
[row2, col2] = find(isnan(data2));
data1(row2)=[];
data2(row2)=[];
end


    


if numbin(1)==0
    numbin(1)=freeddiac(data1);
end
if numbin(2)==0
    numbin(2)=freeddiac(data2);
end
    


% if isinf(numbin)==1 || isnan(numbin)==1
%     numbin=2;
% end


[N,Xedges,Yedges,binX,binY] = histcounts2(data1,data2,[numbin(1) numbin(2)]);

bindata1=Xedges(2)-Xedges(1);
bindata2=Yedges(2)-Yedges(1);

%%%estimation of p(x,y)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
results.jp=N;
areajp=bindata1*bindata2*nansum(nansum(N));
results.jp=results.jp/areajp;
results.jp_raw=N./nansum(nansum(N));
%%%estimation of p(x)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
results.m1=nansum(N);
areadata1=bindata1*nansum(nansum(N));
results.m1=results.m1/areadata1;
%%%estimation of p(y)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
results.m2=nansum(N');
areadata2=bindata2*nansum(nansum(N));
results.m2=results.m2/areadata2;
%%%estimation of MI%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SI1=-log2(results.m1);
SI2=-log2(results.m2);
Hdata1=nansum((results.m1*bindata1).*SI1);
Hdata2=nansum((results.m2*bindata2).*SI2);

temp=-log2(results.jp);
temp(isinf(temp)==1)=0;
SI12=temp;
Hdata1data2=sum(nansum((results.jp*bindata1*bindata2).*SI12));

results.MI=Hdata1+Hdata2-Hdata1data2;
% lMItemp=SI1+SI2-SI12;
% lMI=zeros(1,length(data1));
% 
% 
% for i=1:length(data1)
%     lMI(i)=lMItemp(binX(i),binY(i));
% end

 

%%%generate output structure%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
results.cfg=cfg;
% results.jp_raw=results.jp_raw-((nansum(N')./nansum(nansum(N)))'*(nansum(N)./nansum(nansum(N))));
% results.lMI=lMI;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end