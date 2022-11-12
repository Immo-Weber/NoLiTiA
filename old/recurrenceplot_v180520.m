function [results]=recurrenceplot(data,cfg)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Calculates different recurrence based quantities.
%   data: input data, 1xN double or NxN. Input data can either be a time series or
%   an adjacency matrix.
%CONFIGURATION STRUCTURE:
%   cfg.tau: embedding delay, 1x1, int, default: 0 (optimization)
%   cfg.dim: embedding dimension, 1x1, int, default: 2
%   cfg.en: neighbourhood-size in % std of data, 1x1,  double, default: 0
%   cfg.rr: recurrence rate in % of total possible rr, 1x1, double, default: 5
%   cfg.minlengthdet: minimum length of diagonal lines used for determinism
%   quantification, 1x1, int, default: 0 (off)
%   cfg.minlengthlam: minimum length of vertical lines used for laminarity
%   quantification, 1x1, int, default: 0 (off)
%   cfg.minmaxRecPD: minimum and maximum recurrence periods, 1x2, int,
%   default: [0 0]
%   cfg.singlenei: use only nearest neighbour for calculation  of recurrence
%   periods yes/no [1/0], 1x1, int, default: 1
%   cfg.norm: normalize recurrence frequencies by total possible number of
%   recurrences per period bin yes/no [1/0], 1x1, int, default: 0
%   cfg.amplitudes: estimate amplitude of recurrences [1/0], 1x1, int,
%   default: 0
%   cfg.ampmode: method to estimate amplitudes either by maximum distance
%   (1) or largest eigenvalue(2), 1x1, int, default: 1
%   cfg.waveform.mean: estimate mean waveform per period [1/0], 1x1, int,
%   default: 0
%   cfg.waveform.keepsingle: keep single waveforms [1/0], 1x1, int,
%   default: 0
%   cfg.metric: distance norm 'euclidean' or 'maximum', char, default: 'maximum'
%   cfg.plt: plot results yes/no [1/0], 1x1, int, default: 1
%   cfg.verbose: verbose level [1/0], 1x1, int, default: 1
%OUTPUT:
%   results.cfg: configuration structure
%   results.rr: recurrence rate
%   results.det: determinism
%   results.lam: laminarity
%   results.ratio: The ratio between det and rr
%   results.sumdist: thresholded recurrence matrix
%   results.alldist: untresholded recurrence matrix
%   results.ht: recurrence period probabilites as a function of periods or
%   expected values of recurrence amplitudes (depending on the parameter
%   cfg.amplitudes)
%   cfg.waveform: mean waveform shapes per period
%   results.gaco: generalized autocorrelation as a function of lags
%   results.rpde: recurrence period density entropy
%DEPENDENCIES:
%   amutibin, phasespace, neighsearch
%Author: Immo Weber, 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isfield(cfg,'verbose')==1
    verbose=cfg.verbose;
else
    verbose=1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if verbose==1
disp('                                                 ');
disp('       _  __       __    _  ______ _  ___        ');
disp('      / |/ /___   / /   (_)/_  __/(_)/ _ |       ');
disp('     /    // _ \ / /__ / /  / /  / // __ |       ');
disp('    /_/|_/ \___//____//_/  /_/  /_//_/ |_|       ');
disp('                                                 ');
end
%%%read in parameters%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if isfield(cfg,'dim')==1
dim=cfg.dim;
else
    dim=2;
    if verbose==1
    disp('No embedding dimension specified. Assigning default: 2')
    end
end
if isfield(cfg,'tau')==1
tau=cfg.tau;
else
    tau=0;
    if verbose==1
    disp('No embedding delay specified. Assigning default: 0')
    end
end
if isfield(cfg,'en')==1
en=cfg.en;
else
    en=0;
    if verbose==1
    disp('No neighbourhood size specified. Assigning default: 0')
    end
end
if isfield(cfg,'rr')==1
rr=cfg.rr;
elseif exist('en')==0
    rr=5;
    if verbose==1
    disp('No recurrence rate specified. Assigning default: 5')
    end
else
    rr=0;
end
if isfield(cfg,'minlengthdet')==1
minlengthdet=cfg.minlengthdet;
else
    minlengthdet=0;
    if verbose==1
    disp('No minimum diagonal line length specified. Assigning default: 0')
    end
end
if isfield(cfg,'minlengthlam')==1
minlengthlam=cfg.minlengthlam;
else
    minlengthlam=0;
    if verbose==1
    disp('No minimum vertical line length specified. Assigning default: 0')
    end
end
if isfield(cfg,'minmaxRecPD')==1
minRecPD=cfg.minmaxRecPD(1);
maxRecPD=cfg.minmaxRecPD(2);
else
    minRecPD=0;
    maxRecPD=0;
    if verbose==1
    disp('No range of recurrence periods specified. Assigning defaults: min max')
    end
end
if isfield(cfg,'singlenei')==1
singlenei=cfg.singlenei;
else
    singlenei=1;
    if verbose==1
    disp('No singlenei parameter specified. Assigning default: 1')
    end
end
if isfield(cfg,'norm')==1
    norm=cfg.norm;
else
    norm=0;
    if verbose==1
        disp('No normalization parameter specified. Assigning default: 0')
    end
end
if isfield(cfg,'amplitudes')==1
    amplitudes=cfg.amplitudes;
    if verbose==1 & amplitudes==1
        disp('Estimating amplitudes...')
    end
else
    amplitudes=0;
end

if isfield(cfg,'ampmode')==1
    ampmode=cfg.ampmode;
    
else
    ampmode=1;
end


if isfield(cfg,'waveform')==1
    if isfield(cfg.waveform,'mean')==1
        waveform=cfg.waveform.mean;
    else
        waveform=1;
    end    
    if verbose==1 & waveform==1
        disp('Estimating waveform...')
    end
    if isfield(cfg.waveform,'keepsingle')==1
        keepsingle=1;
    else
        keepsingle=0;
    end
else
    waveform=0;
    keepsingle=0;
end
if isfield(cfg,'metric')==1
if strcmp(cfg.metric,'euclidean')==1    
metric=1;
elseif strcmp(cfg.metric,'maximum')==1    
metric=2;
end
else
    metric=2;
    if verbose==1
      disp('No distance norm specified! Assigning default: maximum')
    end
end
if isfield(cfg,'plt')==1
plt=cfg.plt;
else
    plt=1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if size(data,1)==1 | size(data,2)==1

%%%if no Tau is provided the first minimum of the auto mutual information%%
%%%is used%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if tau==0
    cfgami.numbin=10;
    cfgami.time=length(data)/2;
    cfgami.plt=0;
    cfgami.verbose=0;
    [ resultsami ] = amutibin( data,cfgami);
    tau=resultsami.firstmin;
    if verbose==1
    disp(['The best lag is probably' ' ' num2str(tau)])
    end
end
%%%Phase-Space reconstruction%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cfgs.dim=dim;
cfgs.tau=tau;
cfgs.verbose=verbose;
results=phasespace(data,cfgs);        
%%%calculate distance matrix%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N=length(results.embTS);
mat=[];
results.sumdist=neighsearch(results.embTS,[1:N]',metric);
distances=results.sumdist;
%%%calculate neighbourhood-sizes%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if rr~=0
    sortdist=sort(results.sumdist(:));
    indtemp=(rr/100)*(N^2);
    en=sortdist(floor(indtemp));
else
    groesse=std(data);%max(results.sumdist(:));
    en=(en*groesse)/100;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
results.sumdist= results.sumdist>en;

else
    results.sumdist=data;
    rd=[];
    N=length(results.sumdist);    
end
n1=sum(sum(results.sumdist==0));
rd=100*(n1/(N)^2);
alldist=flipud(results.sumdist);
results.sumdist=+results.sumdist;
results.sumdist=abs(results.sumdist-1);
%%%%Determinism%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
det=0;
ratio=0;
if minlengthdet>0
    kernel=eye(minlengthdet,minlengthdet);
    det=sum(sum((conv2(double(conv2(results.sumdist,kernel,'valid')==sum(kernel(:))),kernel,'full'))>0))/N^2;
    ratio=det/rd;
end
lam=0;
if minlengthlam>0
    kernel=ones(minlengthlam,1);
    lam=sum(sum((conv2(double(conv2(results.sumdist,kernel,'valid')==sum(kernel(:))),kernel,'full'))>0))/N^2;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
results.sumdist=tril(results.sumdist);

%%%generalized autocorrelation%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
indmat=flipud(repmat([1:N]',1,N))-repmat([1:N],N,1);
times=indmat(logical(flipud(results.sumdist)));
results.gaco=hist(times,0:N);
results.gaco=results.gaco./(N-(0:N));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
results.sumdist=abs(results.sumdist-1);
sumd=results.sumdist;
results.sumdist(end+1,1:length(results.sumdist))=NaN; %mark the end of the recurrence plot
nanpos=find(isnan(results.sumdist)==1);
temp=find(results.sumdist==0 | isnan(results.sumdist)==1);
psind=horzcat(temp(1:end-1),temp(2:end));
psind=mod(psind,N+1);
psind(psind==0)=N+1;
temp2=diff(temp); %raw recurrence periods
temp2=horzcat(temp2,psind);
temp2(end+1,:)=NaN;
[endpos,~]=ismember(temp,nanpos);
endpos=find(endpos==1);
temp2([endpos(endpos>1)-1],:)=NaN;
temp2([endpos],:)=NaN;
temp2(temp2(:,1)==1,:)=NaN;
if singlenei==1
    temp2([endpos],:)=-1;
    temp2=vertcat([-1 -1 -1],temp2);
    temp2(end,:)=[];
    temp2(isnan(temp2(:,1))==1,:)=[];
    ind=find(temp2(:,1)>0);
    ind2=find(temp2(ind,1) & temp2(ind-1,1)==-1);
    temp2=temp2(ind(ind2),:);
end

if  maxRecPD==0
    maxRecPD=length(results.sumdist)-1;
    minRecPD=1;
end
temp2(isnan(temp2)==1,:)=[];
results.sumdist(end,:)=[];
results.ht=hist(temp2(:,1),1:length(results.sumdist));                     
poss=fliplr((1:length(results.sumdist)));
if norm==1
    results.ht=results.ht./poss;
end
htges=results.ht;

if maxRecPD~=0
    if maxRecPD>length(results.ht)
        warning('Warning! Maximum recurrence period larger than largest possible period. Assigning maximum...')
        maxRecPD=length(results.ht);
    end
    results.ht=results.ht(minRecPD:maxRecPD);
end

btges=sum(htges);
btspec=sum(results.ht);
if btspec==0
    warning('Warning! No recurrences detected! filling with NaNs...')
end
htges=htges./btges;
results.ht=results.ht./btspec;

if amplitudes==1 | waveform==1
for i=1:size(results.sumdist,2)
   [amp(i),meanwave,singlewave]=calcamp(temp2,results.embTS,i,waveform,ampmode,dim,tau);
   if waveform==1
       results.waveform.mean{i}=meanwave;
       if keepsingle==1
           results.waveform.single{i}=singlewave;
       end
   end
end
results.ht=results.ht.*amp(minRecPD:maxRecPD);
end

notzeroges=find(htges~=0);
notzero=find(results.ht~=0);
rpde=-sum(htges(notzeroges).*log(htges(notzeroges)))/(log((notzeroges(end)))); 
alldist=flipud(alldist);
% results.sumdist=results.sumdist(1:end-1,:);
%%%plot results%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if plt==1
    [r,c] = size(alldist);    
    if exist('distances')
    figure
    ax1=subplot(2,2,1);
    imagesc((1:c),(1:r),distances)
    axis square
    colormap(ax1,jet);
    set(gca,'XTick',0:floor((c+1)/10)+1:(c+1),'YTick',0:floor((c+1)/10)+1:(r+1),...
        'XLim',[0 c+1],'YLim',[0 c+1],'YDir','normal');
    xlabel('State i [samples]','fontsize',12)
    ylabel('State j [samples]','fontsize',12)
    end
    
    ax2=subplot(2,2,2);
    imagesc((1:c),(1:r),results.sumdist);
    colormap(ax2,gray);
    axis square
    set(gca,'XTick',0:floor((c+1)/10)+1:(c+1),'YTick',0:floor((c+1)/10)+1:(r+1),...
        'XLim',[0 c+1],'YLim',[0 c+1],'YDir','normal');
    xlabel('State i [samples]','fontsize',12)
    ylabel('State j [samples]','fontsize',12)
    subplot(2,2,3)
    plot(minRecPD:maxRecPD,results.ht);
    axis square
    set(gca,'XTick',0:floor(size(results.ht,2)/10)+1:size(results.ht,2))
    xlabel('T [samples]')
    ylabel('P(T) [arb.]')
    subplot(2,2,4)
    plot(results.gaco)
    axis square
     xlabel('Lag [samples]','fontsize',12)
    ylabel('Generalized autocorrelation [arb.]','fontsize',12)
end
%%%generate output structure%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
results.cfg=cfg;
results.rr=rd;
if exist('distances')
results.alldist=distances;
end
results.rpde=rpde;
results.det=det;
results.lam=lam;
results.ratio=ratio;
results.N=N;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [amp,meanwave,singlewave]=calcamp(temp2,ps,period,waveform,ampmode,dim,tau)
tempind=find(temp2(:,1)==period);
tempamp=0;
meanwave=0;
singlewave=0;
if ampmode==1
for i=1:length(tempind)
    sigma=neighsearch(ps(temp2(tempind(i),2):temp2(tempind(i),3),:),[1:size(ps(temp2(tempind(i),2):temp2(tempind(i),3),:),1)]',2);
    tempamp(i)=max(max(sigma));
    if waveform==1 & temp2(tempind(i),3)+(dim-1)*tau<length(ps)
        singlewave(i,1:period+(dim-1)*tau+1)=ps(temp2(tempind(i),2):temp2(tempind(i),3)+(dim-1)*tau,end);
    end
end   

elseif ampmode==2
for i=1:length(tempind)
    sigma=cov(ps(temp2(tempind(i),2):temp2(tempind(i),3),:));
    tempamp(i)=max(eig(sigma));
    if waveform==1 & temp2(tempind(i),3)+(dim-1)*tau<length(ps)
        singlewave(i,1:period+(dim-1)*tau+1)=ps(temp2(tempind(i),2):temp2(tempind(i),3)+(dim-1)*tau,end);
    end
end
end
amp=mean(tempamp);
if waveform==1
    if size(singlewave,1)>1
        meanwave=mean(singlewave);
    end
end
end