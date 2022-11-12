dim=5;
tau=0;
en=20;
surr=50;
fs=200;
if tau==0
    [ ~,timeneigh2,lagges ] = timenei( test,dim,tau,length(test),fs,0);
%     pause
lagv(1)=lagges;
        lag=lagges(1);
        env(1)=timeneigh2;
        en=timeneigh2(1);
    else lag=tau;
end
[rdr,sumdist,N,rpder,ht]=recurrenceplotclassic(test,dim,lag,en,0);
for surrv=1:surr
    [imagev]=surrogates(test');
    [ ~,timeneigh2,lagges ] = timenei( imagev,dim,tau,length(test),fs,0);
    if tau==0
        lagv(surrv+1)=lagges;
        env(surrv+1)=timeneigh2;
        lag=lagges(1);
        en=timeneigh2(1);
    else lag=tau;
    end
    [rd,sumdist,N,rpde,ht]=recurrenceplotclassic(imagev,dim,lag,en,0);
    surrrd(surrv)=rd;
    surrrpde(surrv)=rpde;
end

meanrd=mean(surrrd);
meanrpde=mean(surrrpde);

K1=(rdr-meanrd)./std(surrrd);
K2=(rpder-meanrpde)./std(surrrpde);

pK1=normcdf(-abs(K1),0,1);
pK2=normcdf(-abs(K2),0,1);


