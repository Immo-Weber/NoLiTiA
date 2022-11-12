%% Generate test-data set (10 subjects/10 trials/3 variables/5981 samples
%  and phase randomized surrogates)

generate_test_data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Anaylze data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cfg_a1.Data=data;
cfg_a1.methodnames={'nta_entropybin','nta_hurst'};
cfg_a1.verbose=0;
[cfg_a1]=prepare_wrapper(cfg_a1);
% [cfg_a1]=optimize_wrapper(cfg_a1);
[cfg_a1]=generate_cfg(cfg_a1);
[cfg_a1]=batch_wrapper(cfg_a1);

cfg_a2.Data=data_surr;
cfg_a2.methodnames={'nta_entropybin','nta_hurst'};
cfg_a2.verbose=0;
[cfg_a2]=prepare_wrapper(cfg_a2);
% [cfg_a2]=optimize_wrapper(cfg_a2);
[cfg_a2]=generate_cfg(cfg_a2);
[cfg_a2]=batch_wrapper(cfg_a2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Run statistics %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Monte-Carlo

cfg=[];
cfg.method='nta_entropybin'; %'hurst'
cfg.outputvar='Hx';%'expo';
cfg.numperm=1000;
cfg.vars=1:3;
cfg.plt=1;

[data1,data2] = fetch_data(cfg,cfg_a1,cfg_a2);

results_monte=nta_nolitia_monte(data1,data2,cfg);

%% Cluster-based permutation analysis
cfg=[];
cfg.method='nta_entropybin'; %'hurst'
cfg.outputvar='SI';%'expo';
cfg.numperm=1000;
cfg.vars=1:3;
cfg.maxcluster='sumt';
cfg.clustalpha=0.05;
cfg.plt=1;

results_cbpa=nta_nolitia_cbpa(data1,data2,cfg);

