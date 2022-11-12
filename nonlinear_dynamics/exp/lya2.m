function [results]=lya2(data,cfg)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Estimation of the largest Lyapunovexponent as described in Kantz (1994) and Rosenstein et al.(1993)
%   data: input data, 1xN, double
%CONFIGURATION STRUCTURE:
%   cfg.tau: embedding delay,  1x1, int, default: 0
%   cfg.dim: embedding dimension, 1x1, int, default: 2
%   cfg.en: size of neighbourhood(% of maximal attractor diameter), 1x1,
%   double, default: 5
%   cfg.numran: number of random points used for calculation, 1x1, int,
%   default: 100
%   cfg.it: number of temporal iterations, 1x1, int, default: 10
%   cfg.th: Theiler window in samples, 1x1, int, default: 0
%   cfg.resl: num. of adjacent points used for slope calculation, 1x1, int,
%   default: 2
%   cfg.method: either choose Kantz ['Kantz'] or Rosenstein's ['Rosenstein']
%   algorithm, char, default: 'Kantz'
%   cfg.metric: distance norm 'euclidean' or 'maximum', char, default: 'maximum'
%   cfg.manual: manually define the linear region by choosing two points 
%   when the crosshair appears. If manual==0 1:it/3 is used for slope calculation
%   1x1, int, default:0 
%   cfg.plt: plot results yes/no [1/0], 1x1, int, default: 1
%OUTPUT:
%   results.cfg: configuration  structure
%   results.lle: estimate of the largest Lyapunov exponent
%   results.loglya: log of distances after it iterations
%   results.it: vector with temporal iterations
%   results.diffloglya: local slope of loglya per iteration
%   results.residuals: residuals of line fitting
%DEPENDENCIES:
%   autocorr, amutibin, phasespace, neighsearch
%Author: Immo Weber, 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('       _  __       __    _  ______ _  ___        ');
disp('      / |/ /___   / /   (_)/_  __/(_)/ _ |       ');
disp('     /    // _ \ / /__ / /  / /  / // __ |       ');
disp('    /_/|_/ \___//____//_/  /_/  /_//_/ |_|       ');
disp('                                                 ');
%%%read in parameters%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isfield(cfg,'dim')==1
    dim=cfg.dim;
else
    dim=2;
    disp('No dimension specified. Assigning default: 3')
end
if isfield(cfg,'tau')==1
    tau=cfg.tau;
else
    tau=0;
    disp('No tau specified. Assigning default: 0 (optimization)')
end
if isfield(cfg,'en')==1
    en=cfg.en;    
else
    en=5;
    disp('No neighbourhood-size specified. Assigning default: 5')
end
if isfield(cfg,'it')==1
    it=cfg.it;
else
    it=10;
    disp('No number of iterations specified. Assigning default: 10')
end
if isfield(cfg,'th')==1
    th=cfg.th;
else
    th=0;
    disp('No Theiler-window specified. Assigning default: 0 (optimization)')
end
if isfield(cfg,'resl')==1
    resl=cfg.resl;
else
    resl=2;
    disp('No resolution for line fitting specified. Assigning default: 2')
end
if isfield(cfg,'numran')==1
    numran=cfg.numran;
else
    numran=100;
    disp('No number of random points specified. Assigning default: 100')
end
if isfield(cfg,'manual')==1
    manual=cfg.manual;
    cfg.plt=1;
else
    manual=0;
    disp('Manual mode not specified. Assigning default: 0')
end
if isfield(cfg,'plt')==1
    plt=cfg.plt;
else
    plt=0;
end
if isfield(cfg,'method')==1
    method=cfg.method;
else
    method='Kantz';
    disp('No method specified. Assigning default: Kantz')
end
if isfield(cfg,'metric')==1
if strcmp(cfg.metric,'euclidean')==1    
metric=1;
elseif strcmp(cfg.metric,'maximum')==1    
metric=2;
end
else
    metric=1;
      disp('No distance norm specified! Assigning default: euclidean')
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
z=1;
glyavectortn=[];
glyavektort0=[];
%%if no Theiler-window is provided the autocorrelation time is used%%%%%%%
if th==0
    cfgac=[];
    [a]=autocorr(data,cfgac);
    th=2*find(a<0,1,'first');
end
%%%if no Tau is provided the first minimum of the auto mutual information%%
%%%is used%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if tau==0
    cfgami.numbin=10;
    cfgami.time=length(data)/2;
    cfgami.plt=0;
    [ resultsami ] = amutibin( data,cfgami);
    tau=resultsami.firstmin;
    disp(['The best lag is probably' ' ' num2str(tau)])
end
%%%Phase-Space reconstruction%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cfgs.dim=dim;
cfgs.tau=tau;
cfgs.it=0;
results=phasespace(data,cfgs);
space=results.embTS;
N=length(space);
%%%draw random points%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n = N-it;
if numran>n
    numran=n;
end
out = randperm(n,numran);
%%%calculate distance matrix%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dist=neighsearch(space,[1:N]',metric);
[nrows,ncol]=size(dist);
% markedth = full(spdiags(bsxfun(@times,ones(ncol,1),NaN(1,2*th+1)),[-th:th],nrows,ncol));
% dist(isnan(markedth))=NaN;
%%%calculate neighbourhood-size%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
diameter=max(dist(:));
en=(diameter*en)/100;
zer=zeros(length(dist))==1;
%%%apply Kantz'-method%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if strcmp(method,'Kantz')
    
    for time=0:it
        temp=zer;
        temp(time+1:end,out+time)=dist(1:end-time,out)<en;
        glyavectortn(time+1,1)=nanmean(dist(temp));
    end
    
    
        
    
    
        
% for j=1:length(out)                                       
%     Distanztemp=dist(:,out(j));
%     Distanztemp(out(j)-th:out(j)+th)=NaN;                       %Apply Theiler correction
%     LD=find(Distanztemp<en & Distanztemp ~=0);                 
%     exclude=find(LD+it>N);                                      %Exclude points  which can not be iterated it times
%     LD(exclude,:)=[];
%     
%     if length(LD)>3
%         
%         lyavectorj=[];
%         for time=0:it
%             refp=ones(length(LD),1)*space(out(j)+time,:);         %Iterate reference point
%             Distanz2=sqrt(sum((space(LD+time,:)-refp).^2,2));     %Distance  of iterated neighbours and reference point
%             lyavectorj(time+1,1)=mean(Distanz2);                %Mean distance of all neighbours
%         end
%         glyavectortn(z,:)=lyavectorj;
%         z=z+1;
%     end
% end
%%%apply Rosenstein's-method%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif strcmp(method,'Rosenstein')
for j=1:length(out)                                       
    
    Distanztemp=dist(:,out(j));
    Distanztemp(out(j)-th:out(j)+th)=NaN;                     %Apply Theiler correction                                                              
    LD=find(Distanztemp==min(Distanztemp));
    exclude=find(LD+it>N);                                    %Exclude points  which can not be iterated it times
    LD(exclude,:)=[];
    
    if isempty(LD)==0
        
        lyavectorj=[];
        for time=0:it            
            refp=ones(length(LD),1)*space(out(j)+time,:);        %Iterate reference point
            Distanz2=sqrt(sum((space(LD+time,:)-refp).^2,2));    %Distance of iterated neighbours and reference point
            glyavectorj(time+1,1)=Distanz2(1);                  %Only use closest neighbour         
        end
        glyavectortn(z,:)=lyavectorj;
        z=z+1;
    end
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
glyavectortn( ~any(glyavectortn,2), : ) = [];                   %delete NaNs..

 lglyavectortn=log(glyavectortn)';
%  lglyavectortn=mean(lglyavectortn);                              %average log distance after it  iterations

diffloglya(1,:)=0:it;
diffloglya(2,:)=lglyavectortn(1:end);
diffloglya=diff(diffloglya(:,1:resl:end),1,2);
diffloglya=diffloglya(2,:)./diffloglya(1,:);                                   

%%%fit line for estimate of LLE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if manual==0
linear=1:it/3;                                                              
[F,S]=polyfit(linear-1,lglyavectortn(linear),1);
lle=F(1)
[~,delta] = polyval([lle 0],linear-1,S);
end
%%%plot results%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if plt==1
    figure
    plot(0:it,lglyavectortn(1:end),'b')
    xlabel('Iterations')
    ylabel('ln Mean Distance')
    if manual==1
        [x,~] = ginput(2);
        linear=round(x(1)):round(x(2));                                                              
        [F,S]=polyfit(linear-1,lglyavectortn(linear),1);
        lle=F(1)
        [~,delta] = polyval([lle 0],linear-1,S);
    end
    figure
    plot(0:resl:it-(resl-1),diffloglya);
    xlabel('Iterations')
    ylabel('LLE')       
end
%%%generate output structure%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
results.cfg=cfg;
results.lle=lle;
results.loglya=lglyavectortn;
results.it=0:it;
results.diffloglya=diffloglya;
results.residuals=delta;
results.meanresiduals=mean(delta);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
