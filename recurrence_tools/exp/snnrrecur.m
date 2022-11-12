print=1;
br=50;
fs=200;
space=pred;
N=length(space);
mat=[];
hto=zeros(N-1,N);
%% 

for j=1:N;
    K=ones(N,1)*space(j,:);             %Referenzpunkt definieren
    Distanz=sqrt(sum((space-K).^2,2));  %Abstand zu allen anderen Punkten bestimmen
    sumdist(:,j)=Distanz;        
end

    groesse=max(sumdist(:));
    en=groesse/5;
   
    adj=cell(1,length(space));
    LD= sumdist>en;                     %finde distanzen groesser Radius en
    sumdist=LD;
                                        %LD2=find(sumdist>en);
                                        %sumdist(LD)=false;
                                        %sumdist(LD2)=true;
    n1=sum(sumdist==0);
    n2=sum(n1);
    rd=100*(n2/(N)^2);                  %Berechne recurrence rate
    adj1=find(sumdist(:,1)==0);
    adj{1}=diff(adj1);                  %Abstaende zwischen recurrences bestimmen
    
    h = waitbar(0,'Please wait...');
    steps = N;
    for i=2:N;
    adj1=find(sumdist(:,i)==0);
    adj{i}=diff(adj1);
    waitbar((i/steps))
    end
    
    close(h)
    
    adj=vertcat(adj{:,1:end});
    
    adj=(1./adj).*fs;
        
    ht=hist(adj,max(adj));
    ht(:,fs)=0;                         %letzen Frequenz-Bin ausschlieﬂen
    bt=sum(ht);
    um=ones(size(ht))*max(ht);
    ht=ht./bt;
   notzero=find(ht~=0);
    rpde=-sum(ht(notzero).*log2(ht(notzero)))/(log2(fs));
    %% 
    
    if print==1
       
 [r,c] = size(sumdist);
 imagesc((1:c),(1:r),sumdist);
 colormap(gray);
 axis equal
 set(gca,'XTick',0:100:(c+1),'YTick',0:100:(r+1),...
         'XLim',[0 c+1],'YLim',[0 c+1],'YDir','normal');
     xlabel('i')
     ylabel('j')
 figure
 plot(ht(1:br));
 set(gca,'XTick',0:10:size(ht,2))
 grid on
 grid MINOR
 xlabel('Hz')
 ylabel('P(Hz)')
        
    elseif print==2
        
z=meshgrid(ht(1:br),ht(1:br))';
surf(1:br,1:br,z)
colorbar  
    end