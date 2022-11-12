function [ results ] = topo(data,cap,channels,plt,varargin)

cart3=horzcat(cap{2:4});
cart3=cart3(channels,:);
channelnames=cap{1}(channels,:);
subp=ceil(sqrt(size(data,2)));
for i=1:size(data,2)
    
    tri=delaunayTriangulation(cart3);
    k=convexHull(tri);
    if plt==1
        subplot(subp,subp,i)
        h = trisurf(k,tri.Points(:,1),tri.Points(:,2),tri.Points(:,3),data(:,i)) ;
        
        title([varargin{i}])
        axis equal
        lighting phong
        shading interp
        axis off
        view([0 90])        
        hold on
        scatter3(cart3(:,1),cart3(:,2),cart3(:,3),'.')
        line([-0.02,0], [0.08, 0.09], 'Color', 'r');
        line([0.02,0], [0.08, 0.09], 'Color', 'r');
        if iscell(cap)==1
            text(cart3(:,1)-0.005,cart3(:,2),cart3(:,3)+0.01,channelnames)
        end
    end
    results.k=k;
    results.tri=tri;
    results.cart3=cart3;
    results.channelnames=channelnames;
end
end

