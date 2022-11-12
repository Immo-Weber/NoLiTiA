function [results]=nta_phasespace(data,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Embedding of time series in phase-space.
%   data: input data, 1xN, double
%CONFIGURATION STRUCTURE:   
%   cfg.dim: embedding dimension, 1x1, int, default: 2;
%   cfg.tau: embedding delay, 1x1  int, default: 1;
%   cfg.filter: mode of nonlinear noise reduction [none/simple/projection],
%   char, default: none
%   cfg.en: neighbourhood size for nonlinear noise reduction 
%   (experimental), 1x1, double, default: 0;
%   cfg.ensize: determine whether neighbourhood-size are absolute or
%   relative values in % of attractor diameter [rel/abs], char, default:
%   abs
%   cfg.Q: number of largest components to use for noise reduction, 1x1,
%   int, default: 2
%   cfg.keepfiltTS: keep filtered univariate time series [1/0], 1x1, int,
%   default: 1
%   cfg.keepresidual: keep residual univariate time series [1/0], 1x1, int,
%   default: 1
%   cfg.verbose: verbose level [1/0], 1x1, int, default: 1
%OUTPUT:
%   results.cfg: configuration structure
%   results.embTS: phase-space coordinates, N-(tau*dim*((dim-1)/dim))x dim, double
%   results.residual: extracted noise
%   results.filtTS: filtered time series
%DEPENDENCIES:
%   neighsearch
%Author: Immo Weber, 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% disp('                                                                                         ');
% disp('        ______          __             __    ___                    __      __           ');
% disp('       / ____/___ ___  / /_  ___  ____/ /___/ (_)___  ____ _   ____/ /___ _/ /_____ _    ');
% disp('      / __/ / __ `__ \/ __ \/ _ \/ __  / __  / / __ \/ __ `/  / __  / __ `/ __/ __ `/    ');
% disp('     / /___/ / / / / / /_/ /  __/ /_/ / /_/ / / / / / /_/ /  / /_/ / /_/ / /_/ /_/ / _ _ ');
% disp('    /_____/_/ /_/ /_/_.___/\___/\__,_/\__,_/_/_/ /_/\__, /   \__,_/\__,_/\__/\__,_(_|_|_)');
% disp('                                                   /____/                                ');
%%%checking input data%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin==1
    cfg=[];
else
    cfg=varargin{1};
end
if isfield(cfg,'verbose')==1
    verbose=cfg.verbose;
else
    verbose=1;
end

%%%%%read in parameters%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isfield(cfg,'dim')==1
    m=cfg.dim(1);
else
    m=2;
end
if isfield(cfg,'tau')==1
    tau=cfg.tau(1);
else
    tau=1;
end
if isfield(cfg,'filter')==1
    filter=cfg.filter;
else
    filter='none';
end

if isfield(cfg,'en')==1
    en=cfg.en;
else
    en=0;
end

if isfield(cfg,'keepresidual')==1
    keepresidual=cfg.keepresidual;
else
    keepresidual=1;
end

if isfield(cfg,'keepfiltTS')==1
    keepfiltTS=cfg.keepfiltTS;
else
    keepfiltTS=1;
end

if isfield(cfg,'ensize')==1
    ensize=cfg.ensize;
else
    ensize='abs';
end

if isfield(cfg,'Q')==1
    Q=cfg.Q;
else
    Q=2;
end

if isfield(cfg,'backward')==1
    backward=cfg.backward;
else
    backward=1;
end
if size(data,2)>1
    data=data';
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i=1;
j=1;
results.embTS=[];
maxlength=length(data)-(tau*m*((m-1)/m));
if verbose==1
    disp('Checking parameters...')
end
if maxlength>0
    if verbose==1
        disp('Parameters OK.')
    end
    results.embTS=zeros(maxlength,m);
    if backward==1
        data=flipud(data);
    end
    
    if strcmp(class(data),'gpuArray')==1
        results.embTS=zeros(maxlength,m,'gpuArray');
    end
    
    %%%embed  time series%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for i=1:maxlength
        results.embTS(i,1)=data(i);
        for j=1:m-1
            results.embTS(i,j+1)=data(i+tau*j);
        end
    end
    if backward==1
        results.embTS=flipud(results.embTS);
    end
else
    warning('Embedding not possible! Choose a smaller tau or dimension.')
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%simple nonlinear noise reduction%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if strcmp(filter,'simple')==1
    disp('Start filtering...')
    N=length(results.embTS);
    half=round(m/2);
    mat=[];
    sumdist=neighsearch(results.embTS,[1:N]',2);
    if strcmp(ensize,'rel')==1
        maxsize=max(sumdist(:));
        en=en*maxsize/100;
    end
    
    adj=cell(1,length(data));
    for i=1:length(results.embTS)
        adj{i}=find(sumdist(i,:)<=en);
        spacecleaned(i,half)=mean(results.embTS(adj{i}(:),half));
    end
    results.embTS(:,half)=spacecleaned(:,half);
    
    if keepfiltTS==1
        for i=1:length(results.embTS)-tau*m
            for j=1:m
                filtTStemp(j)=results.embTS(i+((j-1)*tau),j);
            end
            results.filtTS(i)=mean(filtTStemp);
        end
                
        if keepresidual==1
            if backward==1
                data=flipud(data);
            end
            results.residual=data((tau*(m-1)+1):length(results.filtTS)+tau*(m-1))-results.filtTS';
        end
    end
    disp('Filtering done!')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Local projective noise reduction%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if strcmp(filter,'projection')==1
    disp('Start filtering...')
    sumdist=neighsearch(results.embTS,[1:maxlength]',2);
    if strcmp(ensize,'rel')==1
        maxsize=max(sumdist(:));
        en=en*maxsize/100;
    end
    
    R=eye(m,m);
    R(1)=1000;
    R(end)=1000;
    
    
    for i=1:length(results.embTS)
        temp_neigh=find(sumdist(i,:)<=en);
%          disp(num2str(length(temp_neigh)))
        mass=mean(results.embTS(temp_neigh,:));
        for j=1:m
            for k=1:m
                tempcov=R*(results.embTS(temp_neigh,:)-mass)';
                covma(j,k)=sum(tempcov(j,:).*tempcov(k,:));
            end
        end
        [eigvec,eigenval]=eig(covma);
        [d,ind] = sort(diag(eigenval),'descend');
        %     eigenval = eigenval(ind,ind);
        eigvec = eigvec(:,ind);
        for q=1:Q
            projtemp(:,q)=eigvec(:,q)*(dot(eigvec(:,q),(R*(results.embTS(i,:)-mass)')));
        end
        
        results.embTS(i,:)=results.embTS(i,:)'-inv(R)*sum(projtemp,2);
        
    end
    
    if keepfiltTS==1
        for i=1:length(results.embTS)-tau*m
            for j=1:m
                filtTStemp(j)=results.embTS(i+((j-1)*tau),j);
            end
            results.filtTS(i)=mean(filtTStemp);
        end
        
        if keepresidual==1
            if backward==1
                data=flipud(data);
            end
            results.residual=data((tau*(m-1)+1):length(results.filtTS)+tau*(m-1))-results.filtTS';
        end
    end
    disp('Filtering done!')
end

%%%output structure%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
results.cfg=cfg;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end