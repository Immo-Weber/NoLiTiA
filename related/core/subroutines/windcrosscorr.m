function [pearson,maxpea]=windcrosscorr(data1,data2)


l1=length(data1);
l2=length(data2);

tempvar2=data2-(movsum(data2,[0 l1-1]))./l1;
finlength=l2-l1;

matind=1:l2;
[x,y]=meshgrid(matind,matind);
matind=(x+y)-1;
matind=matind(1:l1,1:find(matind(l1,:)==l2));
temp=tempvar2(1:l2);
covvar=temp(matind);
vardat2=var(covvar);
vardat2=vardat2(:);
covvar=covvar.*(data1-mean(data1))';
covvar=sum(covvar)./(l1-1);
vardat1=var(data1);
pearson=covvar./(sqrt(vardat1.*vardat2'));
maxpea=max(pearson);










