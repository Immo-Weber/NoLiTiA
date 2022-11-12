g=1;
x1(1)=-1.5;
x1(2)=1.5;
y1(1)=-2;
y1(2)=1;
axis image
colormap jet
load('mandelcoord.mat')
xges=vertcat(x1,xges);
yges=vertcat(y1,yges);

for gg=1:11
    hold off
    x1=xges(gg,:);
    y1=yges(gg,:);
% while 1==1
    l1=linspace(x1(1),x1(2),1000);
    l2=linspace(y1(1),y1(2),1000);
    c=ones(1000,1000);
    for k=1:1000
        for m=1:1000
            x0=0+0i;
            for q=1:100
                x0=x0^2+complex(l2(k),l1(m));
                if abs(x0)>2
                    c(k,m)=q+1;
                    break
                end
            end
        end
    end
    imagesc(l1,l2,c)
    drawnow
    hold on
    rectangle('Position',[xges(gg+1,1) yges(gg+1,1) abs(xges(gg+1,2)-xges(gg+1,1)) abs(yges(gg+1,2)-yges(gg+1,1))])
    drawnow
%     [x,y] = ginput(2);
%     xges(g,1:2)=x;
%     yges(g,1:2)=y;
%     g=g+1;
%     x1=x;
%     y1=y;
end