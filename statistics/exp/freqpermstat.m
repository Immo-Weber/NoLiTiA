function [ Tmaxorig,Tpermmaxdist,thr,sig,Torig ] = freqpermstat( cellA,cellB,numperm,pl )
%Nonparametric permutation test for statistical comparison between cell
%arrays of 2D matrices.
%%reshape cell arrays into 3D-matrices%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
L1=length(cellA);
cellAmat=cell2mat(cellA);
cellAmat=reshape(cellAmat,size(cellA{1},1),size(cellA{1},2),L1);
cellAmat(isinf(cellAmat))=NaN;
L2=length(cellB);
cellBmat=cell2mat(cellB);
cellBmat=reshape(cellBmat,size(cellB{1},1),size(cellB{1},2),L2);
cellBmat(isinf(cellBmat))=NaN;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Calculate orginal distance matrix between both datasets%%%%%%%%%%%%%%%%%%
Dorig=nanmean(cellAmat,3)-nanmean(cellBmat,3);
%%Perform permutations and calculate permutation distances%%%%%%%%%%%%%%%%%
[r,c]=size(Dorig);
Dperm=zeros(r,c,numperm);
h = waitbar(0,'Pemuting...');
for i=1:numperm
    tempcat=horzcat(cellA,cellB);
    D=tempcat(randperm(size(tempcat,2)));
    cellAperm=cell2mat(D(1:L1));
    cellAperm=reshape(cellAperm,size(cellA{1},1),size(cellA{1},2),L1);
    cellAperm(isinf(cellAperm))=NaN;
    cellBperm=cell2mat(D(L1+1:end));
    cellBperm=reshape(cellBperm,size(cellB{1},1),size(cellB{1},2),L2);
    cellBperm(isinf(cellBperm))=NaN;    
    Dperm(:,:,i)=nanmean(cellAperm,3)-nanmean(cellBperm,3); 
    waitbar(i/numperm)
end
close(h)
%%Calculate t-statistics%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
STDperm=std(Dperm,0,3);
Torig=Dorig./STDperm;
Tmaxorig=max(max(Torig));
Tperm=Dperm./repmat(STDperm,1,1,numperm);

for i=1:numperm
    Tpermmaxdist(i)=max(max(Tperm(:,:,i)));
end
%%Determine two-sided threshold values for significance at alpha=0.05%%%%%%
[muhat,sigmahat,~,~] = normfit(Tpermmaxdist);
pd = makedist('Normal',muhat,sigmahat);
xvec=sort(Tpermmaxdist);
y = cdf(pd,xvec);
thr1=find(y<0.025,1,'last');
if isempty(thr1)==1
    thr1=1;
end
thr2=find(y>0.975,1,'first');
if isempty(thr2)==1
    thr2=length(y);
end
thr1=xvec(thr1);
thr2=xvec(thr2);

if Tmaxorig>thr2 | Tmaxorig<thr1
    sig=1
    Torig(Torig>thr1 & Torig<thr2 )=NaN;
else sig=0
end
%%Plot distribution of permutation statistics and threshold values%%%%%%%%% 
if pl==1
    %% 
    
histfit(Tpermmaxdist);
hold on
plot([Tmaxorig Tmaxorig],[0 50],'r');
plot ([thr1 thr1],[0 50],'g');
plot ([thr2 thr2],[0 50],'g');
%%Plot significant values of t-map%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
imagesc(Torig)
thr=horzcat(thr1,thr2);
end

