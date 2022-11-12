function results=nsAMDF(data,cfg)
cfg.dim=2;
results=phasespace(data,cfg);
results.sx1=(sum((abs(diff(results.embTS'))).^cfg.p(1))).^(1/cfg.p(1));
results.sx2=(sum((abs(diff(results.embTS'))).^cfg.p(2))).^(1/cfg.p(2));

end
