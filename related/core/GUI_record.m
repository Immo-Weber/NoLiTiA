%%Automatically generated script%%
data=cell2mat(struct2cell(load('lorenz10000.mat')));
cfg.toi=1:1000;
cfg.normalize=1;
cfg.detrend=1;
cfg.filter=0;
cfg.lpfreq=0;
cfg.hpfreq=0;
cfg.causal=1;
cfg.fs=1000;
for i=1:size(data,2)
[data] = prepare_data(data(:,i),cfg);
end
cfg.optimization='deterministic';
cfg.dims=2:9;
cfg.R=10;
cfg.numbin=0;
cfg.taus=10:10:100;
cfg.mass=4;
cfg.hor=1;
cfg.mode='multi';
[ results ] = optimize_embedding( data,cfg);
cfg.lag=1;
cfg.numsurr=100;
cfg.surrmode=3;
[results]=timerev(data(:,1),cfg);
cfg.dim=3;
cfg.tau=9;
[result]=phasespace(data(:,1),cfg);
neighnum=neighsearch( result.embTS,[1:length(result.embTS)]');
imagesc(flipud(neighnum))
