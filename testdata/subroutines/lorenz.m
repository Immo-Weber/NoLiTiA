function dYdt = lorenz( t,Y )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Evaluates the Lorenz-function at time point t and  starting point Y.
%Standard parameters are used to generate chaotic dynamics.
%use as: [t,X] = ode45(@lorenz,tspan,Y); to generate time series.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
y1=Y(1);
y2=Y(2);
y3=Y(3);

a = 10;
b = 28;
c = 8/3;
% m=50;
% w=0.122;

dy1dt=a*(y2-y1);
dy2dt=y1*(b-y3)-y2;
dy3dt=y1*y2-c*y3;%+m*sin(w*t);

dYdt=[dy1dt;dy2dt;dy3dt];

end

