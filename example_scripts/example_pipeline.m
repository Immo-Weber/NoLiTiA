load('lorenz10000.mat')
data1           =   x;
data2           =   y;

cfg             =   [];
cfg.normalize   =   1;
cfg.detrend     =   1;
cfg.filter      =   1;
cfg.lpfreq      =   100;
cfg.hpfreq      =   1;
cfg.fs          =   500;
cfg.toi         =   1:5000;
[prepared_data1]                    =   prepare_data(data1,cfg);
[prepared_data2]                    =   prepare_data(data2,cfg);

cfg             =   [];
cfg.optimization=   'deterministic';
cfg.dims        =   [2 9];
cfg.numbin      =   0; %Optimize bin size
[results_opt_emb]                   =   optimize_embedding(prepared_data1,cfg);

cfg             =   [];
cfg.minlength   =   0;
cfg.dim         =   results_opt_emb.optdim;
cfg.tau         =   results_opt_emb.opttau;
cfg.plt         =   0;
[results_rec]                       =   recurrenceplot(prepared_data1,cfg);


cfg             =   [];
cfg.numbin      =   0;
[results_MIbin]                     =   MIbin(prepared_data1,prepared_data2,cfg);
