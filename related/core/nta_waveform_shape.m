function [results]=nta_waveform_shape(data,cfg)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This function calculates sharpness and steepness measures to characterize
%waveform shapes (Cole et al., 2017).
%The Signal processing toolbox (SPT) needs to be installed for filtering operations.

%   data: input data, Nx1 double
%CONFIGURATION STRUCTURE:
%   cfg.freq: frequency of interest [Hz]. 1x2 vector, double, default: [13 30]
%   cfg.fs: sampling rate [Hz]. 1x1 vector, double, default: 1000
%   cfg.width: time interval left and right from peak/through used for
%   estimation of sharpness [ms]. 1x1 vector, double, default: 5
%OUTPUT:
%   results.sharp_peak: average peak sharpness, 1x1, double
%   results.sharp_throughs: average through sharpness, 1x1, double
%   results.sharp_ratio: sharpness ratio, 1x1, double
%   results.steep_rise: average rise steepness, 1x1, double 
%   results.steep_fall: average fall steepness, 1x1, double
%   results.steep_ratio: steepness ration, 1x1, double
%DEPENDENCIES:
%   butter (SPT!), filtfilt (SPT!)
%Author: Immo Weber, 2018

%Measures published in
%Cole, Scott R., et al. "Nonsinusoidal beta oscillations reflect cortical 
%pathophysiology in Parkinson's disease." 
%Journal of Neuroscience 37.18 (2017): 4830-4840.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isfield(cfg,'freq')==1
    freq=cfg.freq;
else
    freq=[13 30];
end

if isfield(cfg,'fs')==1
    fs=cfg.fs;
else
    fs=1000;
end

if isfield(cfg,'width')==1
    width=cfg.width/1000;
else
    width=0.005;
end

if fs*width<1
    width=1/fs;
    warning('width too small! Setting to 1/fs.')
    results.width='NaN';
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hasSPT = license('test', 'signal_toolbox');
if hasSPT==1

data=zscore(data)';
k=1;
g=1;

if freq~=0
    [b,a]=butter(4,[2*freq(1)/fs 2*freq(2)/fs],'bandpass');
    data_filt=filtfilt(b,a,data);
else
    data_filt=data;
end

datadiff = diff(sign(data_filt));
indx_up = find(datadiff>0);
indx_down = find(datadiff<0);
l_peaks_throughs=min([length(indx_up) length(indx_down)]);
[~,ind]=min([indx_up(1) indx_down(1)]);

if ind==1
    
    for extrema=1:l_peaks_throughs
        [temp0 temp1]=max(data(indx_up(extrema):indx_down(extrema)));
        if temp1+indx_up(extrema)-1-(fs*width)>0 & temp1+indx_up(extrema)-1+(fs*width)<length(data)
            ind_max_p(k)=temp1+indx_up(extrema)-1;
            max_p(k)=temp0;
            k=k+1;
        end
        [temp0 temp1]=min(data(indx_up(extrema):indx_down(extrema)));
        if temp1+indx_up(extrema)-1-(fs*width)>0 & temp1+indx_up(extrema)-1+(fs*width)<length(data)
            ind_min_p(g)=temp1+indx_up(extrema)-1;
            min_p(g)=temp0;
            g=g+1;
        end
    end
    
elseif ind==2
    
    for extrema=1:l_peaks_throughs
        [temp0 temp1]=max(data(indx_down(extrema):indx_up(extrema)));
        if temp1+indx_down(extrema)-1-(fs*width)>0 & temp1+indx_down(extrema)-1+(fs*width)<length(data)
            ind_max_p(k)=temp1+indx_down(extrema)-1;
            max_p(k)=temp0;
            k=k+1;
        end
        [temp0 temp1]=min(data(indx_down(extrema):indx_up(extrema)));
        if temp1+indx_down(extrema)-1-(fs*width)>0 & temp1+indx_down(extrema)-1+(fs*width)<length(data)
            ind_min_p(g)=temp1+indx_down(extrema)-1;
            min_p(g)=temp0;
            g=g+1;
        end
    end
    
end

sharp_peak=mean(((max_p-data(ind_max_p-(fs*width)))+(max_p-data(ind_max_p+(fs*width))))/2);
sharp_through=mean(((-min_p+data(ind_min_p-(fs*width)))+(-min_p+data(ind_min_p+(fs*width))))/2);

sharp_ratio=max([sharp_peak/sharp_through sharp_through/sharp_peak]);

l_peaks_throughs2=min([ind_max_p ind_min_p]);

for extrema=1:min([length(ind_min_p) length(ind_max_p)])%l_peaks_throughs2
    temp11=max(diff(data(ind_min_p(extrema):ind_max_p(find( ind_max_p > ind_min_p(extrema), 1 )))));
    if isempty(temp11)==1
        temp11=NaN;
    end
    steep_rise(extrema)=temp11;
    
    temp12=max(diff(data(ind_max_p(extrema):ind_min_p(find( ind_min_p > ind_max_p(extrema), 1 )))));
    if isempty(temp12)==1
        temp12=NaN;
    end
    steep_fall(extrema)=temp12;
    
end

steep_rise=mean(steep_rise);
steep_fall=mean(steep_fall);

steep_ratio=max([steep_fall/steep_rise steep_rise/steep_fall]);
else
    warning('No Signal Processing Toolbox installed! Filtering not possible.')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
results.sharp_peak=sharp_peak;
results.sharp_through=sharp_through;
results.sharp_ratio=sharp_ratio;
results.steep_rise=steep_rise;
results.steep_fall=steep_fall;
results.steep_ratio=steep_ratio;
end