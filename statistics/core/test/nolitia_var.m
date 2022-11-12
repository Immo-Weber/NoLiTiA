function [v] = nolitia_var(data,nobs) %#codegen
df=nobs-1;
temp=zeros(1,size(data,2),size(data,3));
for i=1:nobs
temp = temp+abs(data(i,:,:) - sum(data,1)./nobs).^2;
end
v=temp./df;
end

