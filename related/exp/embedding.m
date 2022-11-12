function [res,bestdim,bestlag]=embedding(data,cfg)

winlength=cfg.window;
mindim=cfg.dims(1);
maxdim=cfg.dims(2);
vielf=cfg.taus;
numran=cfg.numran;
mass=cfg.mass;
hor=cfg.hor;


if size(data,2)==1
    data=data';
end


cfgr.dims=mindim:maxdim;
cfgr.taus=vielf;
cfgr.numran=numran;
cfgr.mass=mass;
cfgr.hor=hor;
cfgr.mode='vielf';

for i=1:size(data,1)
for j=1:floor(size(data,2)/winlength)
    [bestlag(i,j),bestdim(i,j),rmspe]=ragwitznew(data(i,((j-1)*winlength+1:j*winlength)),cfgr)
end
end

res.dim=max(max(bestdim));
res.lag=round(mean(mean(bestlag)));