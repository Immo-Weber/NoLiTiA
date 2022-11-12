l=length(recp1);
maxlag=5000;
for i=1:maxlag
recp1m=recp1(i:l-maxlag+i)-nanmean(recp1(i:l-maxlag+i));
recp2m=recp2(1:l-maxlag+1)-nanmean(recp2(1:l-maxlag+1));
CPR(i)=(nanmean(recp1m.*recp2m))./(nanstd(recp1(i:l-maxlag+i)).*nanstd(recp2(1:l-maxlag+1)));
end