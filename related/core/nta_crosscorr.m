function R=nta_crosscorr(data,lag)

data=horzcat(data,fliplr(data));


for i=1:lag
   temp=corrcoef(data(1:lag+1),data(i:lag+i));
   R(i)=temp(2);
end

R=R./R(1);