function [conn,labelmat,r,c] = connset_helper(test) %#codegen

r=size(test,1);
c=size(test,2);
neighs=zeros(1,4);
labelmat=zeros(r+2,c+2);
labelmat(2:r+1,2:c+1)=test;
% coder.varsize('conn');
% conn=int32(zeros(0,2));
label=0;
% coder.varsize('index',[1 4],[0 1]);
k=1;
conn=[];
start=find([zeros(1,c+2);diff(labelmat)]==1);
lengthrun=find([zeros(1,c+2);diff(labelmat)]==-1)-start;
ls=length(start);
m=max(lengthrun);
test=zeros(ls,m);
for i=1:ls
    test(i,1:lengthrun(i))=start(i):start(i)+lengthrun(i)-1;
    temp=[start(i):start(i)+lengthrun(i)-1];
    labelmat(temp)=i;
    neigh=(labelmat([temp(1)-(r+2)-1:temp(end)-(r+2)+1]))';
    if any(neigh>0)
        d=[repmat(i,length(neigh(neigh>0)),1) neigh(neigh>0)];
        conn=[conn; d];
    else
        conn=[conn; [i i]];
    end
end

% for i=1:ls
%     temp=[start(i):start(i)+lengthrun(i)-1];
%      tempneigh=temp(1)-(r+2)-1:temp(end)-(r+2)+1;
%      tempneigh=[tempneigh ones(1,m-(lengthrun(i)+2))-2];
% %     [~,f,~] = intersect(test,[temp(1)-(r+2)-1:temp(end)-(r+2)+1],'stable');
% [f1,~]=find(test==tempneigh);
%      [f,~]=find(ismembc(test(1:i,:),tempneigh));
% %     f=unique(f);
%     
%     
%     
%     if isempty(f)==0
%         d=[repmat(i,length(f),1) mod(f,ls)];
%         conn=[conn; d];
%     else
%         conn=[conn; [i i]];
%     end
%     
% end



