function [ OLg,OLgtau ] = timemuti( data,window,fs )
%UNTITLED2 Summary of this function goes here
%   Detailed edataplanation goes here
numwin=floor(length(data)/window);
% h = waitbar(0,'Please wait...');
% steps =numwin
for i=1:numwin
    D=data((i-1)*window+1:window*i);
    [ ~,OL ] = amutinew(D,round(length(D)/2),10,0 );
    OLg((i-1)*window+1:window*i)=OL;
    OLgtau(i)=OL;
%     waitbar((i/numwin));
end
% close(h)
time=1/fs:1/fs:length(OLg)/fs;
% plot(time,OLg)
% ylim([0 madata(OLg)])
% datalabel('Time (s)','FontSize', 20) % data-adatais label
% ylabel('First Minimum of Auto-Mutual Information (Samples) ','FontSize', 20) % y-adatais label