function [CC]=connsets7(test) 

% r=uint32(size(test,1));
% c=uint32(size(test,2));
% 
% labelmat=int32(zeros(r+2,c+2));
% labelmat(2:r+1,2:c+1)=int32(test);
% label=1;
% neighs=int32(zeros(1,4));


k=1;
CC.PixelIdxList=[];
conn=[];
[conn,labelmat,r,c] = connset_helper(test);

% for col=2:c+1
%     for row=2:r+1
%         if labelmat(row,col)==1
%             neighs = [labelmat(row,col-1) labelmat(row-1,col) labelmat(row-1,col-1) labelmat(row+1,col-1)];                 
%             if nnz(neighs(:))==0
%                 labelmat(row,col)=label;
%                 
%             else                
%                 labelmat(row,col)=label;                
%                 index = find(neighs);
%                 for i = 1:length(index)
%                     tempval=neighs(index(i));
%                     conn(k,1)=label;
%                     conn(k,2)=tempval;
%                     k=k+1;
%                 end                
%             end
%             label=label+1;
%         end
%     end
% end
if isempty(conn)
    return
else
adj1 = sparse([conn(:,1); conn(:,2)], [conn(:,2); conn(:,1)], 1);
adj1=adj1+speye(length(adj1));
[p,q,ri,s] = dmperm(adj1);
labelmat=labelmat(2:r+1,2:c+1);
for i=1:length(ri)-1
    CC.PixelIdxList{i}=find(ismember(labelmat,p(ri(i):ri(i+1)-1)));
%        labelmat(ismember(labelmat,p(ri(i):ri(i+1)-1)))=i;
end

%imagesc(labelmat)
end






    