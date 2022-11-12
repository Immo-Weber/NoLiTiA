function [ test,time,X,Y ] = lorenzcoupling( fs,sec,delay,str,grad,nrtrl )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Generates coupled Lorenz time series.
%fs: sampling frequency, 1x1 int
%sec: seconds per trial, 1x1, double
%delay: coupling delay in s, 1x1, double
%str: coupling strenght [0-1], 1x1, double
%grad: coupling term raised to power grad, 1x1, int
%nrtrl: number of trials, 1x1, int
%test: cell array of generated time series of second component of each Lorenz system
%Coupling direction: test(:,1)-->test(:,2)
%time: time vector
%X: all three time series of first Lorenz system (last trial)
%Y: all three time series of second Lorenz system (last trial)
%Author: Immo Weber, 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 y10=randn(nrtrl)+5;
 y20=randn(nrtrl)+5;
 y30=randn(nrtrl)+5;
 
 x10=randn(nrtrl)+5;
 x20=randn(nrtrl)+5;
 x30=randn(nrtrl)+5;
 
tspan=[0:1/fs:((sec*fs)-1)/fs];
for i=1:nrtrl

 [t,X] = ode45(@lorenz,tspan,[x10(i) x20(i) x30(i)]);    
 [t,Y] = ode45(@lorenz,tspan,[y10(i) y20(i) y30(i)]);

Y(1+round(delay*fs):end,2)= Y(1+round(delay*fs):end,2)+(str.*(X(1:end-round(delay*fs),2).^grad));
 
test{i}(1,:)=[X(:,2)'];
test{i}(2,:)=[Y(:,2)'];
time{i}=[0:1/fs:((fs*sec)-1)/fs];


end
end

