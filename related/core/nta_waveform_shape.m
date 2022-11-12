function [results]=nta_waveform_shape_final(data,cfg)
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
%Author: Immo Weber, 2022

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
    
    %find turning points
    datadiff = diff(sign(data_filt));
    indx_rise_up = find(datadiff>0);
    indx_fall_down = find(datadiff<0);
    l_peaks_throughs=min([length(indx_rise_up) length(indx_fall_down)]);
    %determine if peak or through comes first
    [~,ind]=min([indx_rise_up(1) indx_fall_down(1)]);
    
    if ind==1
        
        for extrema=1:l_peaks_throughs-1
            [temp0 temp1]=max(data(indx_rise_up(extrema):indx_fall_down(extrema)));
            if temp1+indx_rise_up(extrema)-1-(fs*width)>0 & temp1+indx_rise_up(extrema)-1+(fs*width)<length(data)
                ind_max_p(k)=temp1+indx_rise_up(extrema)-1;
                max_p(k)=temp0;
                k=k+1;
            end
            [temp0 temp1]=min(data(indx_fall_down(extrema):indx_rise_up(extrema+1)));
            if temp1+indx_fall_down(extrema)-1-(fs*width)>0 & temp1+indx_rise_up(extrema+1)-1+(fs*width)<length(data)
                ind_min_p(g)=temp1+indx_fall_down(extrema)-1;
                min_p(g)=temp0;
                g=g+1;
            end
        end
        
    elseif ind==2
        
        for extrema=1:l_peaks_throughs-1
            [temp0 temp1]=max(data(indx_rise_up(extrema):indx_fall_down(extrema+1)));
            if temp1+indx_rise_up(extrema)-1-(fs*width)>0 & temp1+indx_fall_down(extrema+1)-1+(fs*width)<length(data)
                ind_max_p(k)=temp1+indx_rise_up(extrema)-1;
                max_p(k)=temp0;
                k=k+1;
            end
            [temp0 temp1]=min(data(indx_fall_down(extrema):indx_rise_up(extrema)));
            if temp1+indx_fall_down(extrema)-1-(fs*width)>0 & temp1+indx_fall_down(extrema)-1+(fs*width)<length(data)
                ind_min_p(g)=temp1+indx_fall_down(extrema)-1;
                min_p(g)=temp0;
                g=g+1;
            end
        end
        
    end
    
    peak_sharpness=mean(((max_p-data(ind_max_p-(fs*width)))+(max_p-data(ind_max_p+(fs*width))))/2);
    through_sharpness=mean(((-min_p+data(ind_min_p-(fs*width)))+(-min_p+data(ind_min_p+(fs*width))))/2);
    
    sharp_ratio=max([peak_sharpness/through_sharpness through_sharpness/peak_sharpness]);
    
    [l_peaks_throughs2, ind]=min([ind_max_p(1) ind_min_p(1)]);
    
    if ind==1
        
        for extrema=1:min([length(ind_min_p) length(ind_max_p)])-1%l_peaks_throughs2
            
            temp11=max(diff(data(ind_min_p(extrema):ind_max_p(extrema+1))));
            rise_steepness(extrema)=temp11;
            
            temp12=max(abs(diff(data(ind_max_p(extrema):ind_min_p(extrema)))));
            decay_steepness(extrema)=temp12;
            
        end
        
    elseif ind==2
        
        for extrema=1:min([length(ind_min_p) length(ind_max_p)])-1
            temp11=max(diff(data(ind_min_p(extrema):ind_max_p(extrema))));
            rise_steepness(extrema)=temp11;
            
            temp12=max(abs(diff(data(ind_max_p(extrema):ind_min_p(extrema+1)))));
            decay_steepness(extrema)=temp12;
        end
        
    end
    
    rise_steepness=mean(rise_steepness);
    decay_steepness=mean(decay_steepness);
    
    steep_ratio=max([decay_steepness/rise_steepness rise_steepness/decay_steepness]);
else
    warning('No Signal Processing Toolbox installed! Filtering not possible.')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
results.sharp_peak=peak_sharpness;
results.sharp_through=through_sharpness;
results.sharp_ratio=sharp_ratio;
results.steep_rise=rise_steepness;
results.steep_fall=decay_steepness;
results.steep_ratio=steep_ratio;
end