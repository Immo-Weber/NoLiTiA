fs=200;
b(isnan(b))=0;
L=length(b);
Y = fft(b);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = fs*(0:(L/2))/L;
plot(f(2:end),P1(2:end))
xlim([0 50])
xlabel('f (Hz)')
ylabel('|P1(f)|')
set(gca,'TickDir','out')
box off
% export_fig(gcf, 'Fourierautolorenz2.tiff', '-transparent', '-nocrop')
%% 

% for i=1:69
%     meanrpdeorig(1:15,i)=rdrpdeorig{i}(2,1:15);
%     meanrpdesurr(1:15,i)=rdrpdesurr{i}(2,1:15);
% end
% rpdemeanorig=mean(meanrpdeorig,2);
% rpdemeansurr=mean(meanrpdesurr,2);
% figure
% [tdpower,f] = pwelch(y,5000,2500,1:500,1000);
% plot(f,tdpower)
% xlabel('f (Hz)')
% ylabel('|P(f)|')
% set(gca,'TickDir','out')
% box off
% export_fig(gcf, 'pwelchlorenz.tiff', '-transparent', '-nocrop')