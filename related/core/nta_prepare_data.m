function [ prep_data ] = nta_prepare_data(data,cfg )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This function prepares data by defining time spans of interest and 
%optionally normalizing and detrending data and applying a buterworth filter. 
%The Signal processing toolbox (SPT) needs to be installed for filtering operations.
%   data: input data, Nx1 double
%CONFIGURATION STRUCTURE:
%   cfg.toi: time points of interest in samples. 1xN vector, int, default: 1:length(data)
%   cfg.normalize: z normalization yes/no [1/0], 1x1, int, default: 1
%   cfg.detrend: remove linear trend yes/no [1/0], 1x1, int, default: 0
%   cfg.filter: filter yes/no [1/0], 1x1, int, default: 0
%   cfg.lpfreq: lowpass frequency in Hz, 1x1, int, default: 100
%   cfg.hpfreq: highpass frequency in Hz, 1x1, int, default: 1
%   cfg.causal: apply causal filter (one-direction) yes/no [1/0] , 1x1, int,
%   default: 0
%   cfg.fs: Sampling frequency in Hz, 1x1, int, default: 1000
%OUTPUT:
%   prep_data: prepared data;
%DEPENDENCIES:
%   butter (SPT!), filter (SPT!), filtfilt (SPT!)
%Author: Immo Weber, 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('                                      _                    __      __           ') 
disp('    ____  ________  ____  ____ ______(_)___  ____ _   ____/ /___ _/ /_____ _    ')
disp('   / __ \/ ___/ _ \/ __ \/ __ `/ ___/ / __ \/ __ `/  / __  / __ `/ __/ __ `/    ')
disp('  / /_/ / /  /  __/ /_/ / /_/ / /  / / / / / /_/ /  / /_/ / /_/ / /_/ /_/ / _ _ ')
disp(' / .___/_/   \___/ .___/\__,_/_/  /_/_/ /_/\__, /   \__,_/\__,_/\__/\__,_(_|_|_)')
disp('/_/             /_/                       /____/                                ')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isfield(cfg,'toi')==1 & cfg.toi~=0
    toi=cfg.toi;
else
    toi=1:length(data);
end

if isfield(cfg,'normalize')==1
    normalize=cfg.normalize;
else
    normalize=1;
end

if isfield(cfg,'detrend')==1
    detrend=cfg.detrend;
else
    detrend=0;
end

if isfield(cfg,'filter')==1
    filterc=cfg.filter;
else
    filterc=0;
end

if isfield(cfg,'lpfreq')==1
    lpfreq=cfg.lpfreq;
else
    lpfreq=100;
end

if isfield(cfg,'hpfreq')==1
    hpfreq=cfg.hpfreq;
else
    hpfreq=1;
end

if isfield(cfg,'filtord')==1
    filtord=cfg.filtord;
else
    filtord=4;
end

if isfield(cfg,'causal')==1
    causal=cfg.causal;
else
    causal=0;
end

if isfield(cfg,'fs')==1
    fs=cfg.fs;
else
    fs=1000;
end
if size(data,2)==1
    data=data';
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if detrend==1
    a=polyfit(1:length(data),data,1);
    trend=polyval(a,1:length(data));
    data=data-trend;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if filterc==1
    hasSPT = license('test', 'signal_toolbox');
    if hasSPT==1
        disp('Filtering data....')
        if hpfreq>0 & lpfreq>0
            [b,a]=butter(filtord,[2*hpfreq/fs 2*lpfreq/fs] ,'bandpass');
        elseif hpfreq>0 & lpfreq==0
            [b,a]=butter(filtord,[2*hpfreq/fs] ,'high');
        elseif hpfreq==0 & lpfreq>0
            [b,a]=butter(filtord,[2*lpfreq/fs] ,'low');
        end
        if causal==1
            data=filter(b,a,data);
        elseif causal==0
            data=filtfilt(b,a,data);
        end
    else
        warning('No Signal Processing Toolbox installed! Filtering not possible.')
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
prep_data=data(toi);
if normalize==1
    prep_data=(prep_data-mean(prep_data))/std(prep_data);
end
prep_data=prep_data';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

