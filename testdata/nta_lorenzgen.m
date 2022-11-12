function [x,y,z] = nta_lorenzgen( L )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Function generates x,y,z components of the Lorenz-function using  random
%starting points.
%INPUT:
%   L: time vector at which the lorenz function should be evaluated e.g.
%   1:0.01:1000; 1 x time
%OUTPUT:
%   x: x component of Lorenz system
%   y: y component of Lorenz system
%   z: z component of Lorenz system
%Author: Immo Weber, 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

y10=randn(1)+5;
y20=randn(1)+5;
y30=randn(1)+5;

x10=randn(1)+5;
x20=randn(1)+5;
x30=randn(1)+5;
[t,X] = ode45(@lorenz,L,[x10 x20 x30]);
%%Generate Output%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x=X(:,1);
y=X(:,2);
z=X(:,3);

end

