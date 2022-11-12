function [results]=nta_surrogates(data,cfg)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Generates surrogate data using 5 different algorithms. 
%   data: input data, Nx1, double
%CONFIGURATION STRUCTURE:
%   cfg.mode:
%       mode==1 random shuffling
%       mode==2 phase randomization
%       mode==3 amplitude adjusted phase randomization
%       mode==4 cut time series at random point and flip second half
%       mode==5 cut time series at random point and switch halves, 1x1,
%       int, default: 1
%   cfg.numit: Number of iterations for amplitude adjustement
%   (mode==3),1x1,int, default: 0
%   cfg.verbose: verbose level [1/0], 1x1, int, default: 1
%OUTPUT:
%   results.cfg: configuration structure
%   results.surr: surrogate time series, Nx1, double
%DEPENDENCIES:
%   -
%Author: Immo Weber, 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isfield(cfg,'verbose')==1
    verbose=cfg.verbose;
else
    verbose=1;
end
%%%read in parameters%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isfield(cfg,'mode')==1
    mode=cfg.mode;
else
    mode=1;
    if verbose==1
        disp('No surrogate type specified! Assigning default: random shuffling')
    end
end
if isfield(cfg,'numit')==1
    numit=cfg.numit;
else
    numit=0;
    if verbose==1
        disp('No number of iterations for amplitude adjustment specified! Assigning default: 0')
    end
end
if size(data,2)>1
    data=data';
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%random shuffling%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if mode==1
     surr=data(randperm(size(data,1)),:);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%phase randomization%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif mode==2 | mode==3
    
    
    complfft=fft(data);
    amplitude=sqrt(real(complfft).^2+imag(complfft).^2);
    phase=atan2(imag(complfft),real(complfft));
    shu=rand(length(phase),1)*2*pi;
    re = amplitude .* cos(shu);
    im = amplitude .* sin(shu);
    F = re + 1i*im;
    surr=real(ifft(F));
    %%
%%%Amplitude adjustement%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if mode==3
        [~,~,rankD]=unique(data);
        
        for i=1:numit
            
            surr=sort(surr);
            surr=surr(rankD);            
            complfftsurr=fft(surr);
            phase=atan2(imag(complfftsurr),real(complfftsurr));
            resurr=amplitude.*cos(phase);
            imsurr=amplitude.*sin(phase);
            Fsurr = resurr + 1i*imsurr;
            surr=real(ifft(Fsurr));
            
        end
    end
%%%flipped surrogates%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
elseif mode==4
    out = randperm(length(data),1);
    surr=data;
    surr(out:end)=flipud(data(out:end));
%%%switched surrogates%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif mode==5
    out = randperm(length(data),1);
    surr=data;
    surr=vertcat(data(out+1:end),data(1:out));
end
%%%generate output structure%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
results.cfg=cfg;
results.surr=surr;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end