%Generate test-data
clear all
close all

%% Generate test data%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cfg.mode=2;
cfg.verbose=0;
L=1:0.05:300;

for subject=1:10
    
    for trials=1:10
        [x,y,z] = nta_lorenzgen( L );
        data{subject}{trials}(1,:)=x';
        [results]=nta_surrogates(data{subject}{trials}(1,:),cfg);
        data_surr{subject}{trials}(1,:)=results.surr';
        data{subject}{trials}(2,:)=y';
        [results]=nta_surrogates(data{subject}{trials}(2,:),cfg);
        data_surr{subject}{trials}(2,:)=results.surr';
        data{subject}{trials}(3,:)=z';
        [results]=nta_surrogates(data{subject}{trials}(3,:),cfg);
        data_surr{subject}{trials}(3,:)=results.surr';
    end


end