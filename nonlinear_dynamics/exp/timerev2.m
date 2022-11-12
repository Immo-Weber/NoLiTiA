function [Qt,zstat]=timerev2(data,tau,surr,numsurr,statmode)
zstat=0;
x=flipud(data);
for q=1:length(tau)
    Qtsurr=[];
        Qt(q)=mean(diff(x,tau(q)).^3);
if surr>0
    for i=1:numsurr
    temp=surrogates(x,surr,10);
    temp=zscore(temp);
    Qtsurr(i)=mean(diff(temp,tau(q)).^3);
    end
    
    meansurr(q)=mean(Qtsurr);
    stdsurr(q)=std(Qtsurr);
    
    if statmode==1
    zstat(q)=(Qt(q)-meansurr(q))./stdsurr(q);
    else
        [~,~,rankD]=unique(horzcat(Qt,Qtsurr));
        zstat=rankD(1);
    end
end

    
    
end