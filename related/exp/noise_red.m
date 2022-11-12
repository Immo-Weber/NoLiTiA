% load('lorenz10000.mat')
% noise=(4*rand(10000,1))-2;
% noisex=x+noise;
noisex=data;
newx=noisex;
for q=1:2
cfg=[];
cfg.dim=13;
cfg.tau=2;
target_dim=9;

diff_dim=cfg.dim-target_dim;
[results]=phasespace(newx,cfg);
space=results.embTS;
% space_new2=flipud(fliplr(space))
% t=[i:cfg.tau+1:i+(cfg.dim)*cfg.tau];
N=length(space);
distance=neighsearch(space,[1:N]');
distsort=sort(distance);
en=max(distsort(2,:));
neigh=distance<en;
space_new=[];

for i=1:N
    co_temp=cov(space(neigh(:,i),:));
    [eivec,eival]=eig(co_temp);
    [~,sind]=sort(sum(eival),2,'descend');
    sorted_eivec=eivec(:,sind);
    if size(eival,2)>1
    space_new(i,:)=space(i,:)*sorted_eivec(:,1:end-diff_dim);
    end
end    

weight=ones(target_dim,1);
weight([1 end])=0.1;
space_new=flipud(fliplr(space_new));


for i=1:N-(target_dim)*cfg.tau
    newx_temp(i,1)=mean(diag(space_new([i:cfg.tau+1:i+(target_dim)*cfg.tau],:)));
end
newx(1+(target_dim)*cfg.tau:N)=flipud(newx_temp);
end
arti=noisex-newx;
figure
plot(newx)
%hold on
figure
plot(noisex,'r')
figure
plot(arti,'g')
% newx=flipud(newx);
% noisex=flipud(noisex);
% noisextemp=noisex(1:length(newx));
% noisex=flipud(noisex);
% error(q)=(sum((newx-x(end-length(newx)+1:end)).^2)/length(newx));
% end
% plot(newx)
% hold on
% plot(noisextemp,'r')

