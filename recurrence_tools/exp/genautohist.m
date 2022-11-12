b=gaco(5,:);
nonz=find(b~=0);
d=diff(nonz);
d(d==1)=NaN;
h=hist(d,1:10001);
h=h./sum(h);
fr=1000./[1:10001];
plot(fr(5:end),h(5:end),'LineWidth',5)
ylim([0 1])
set(gca,'TickDir','out')
box off
title('Frequency of Recurrence')
xlabel('f (Hz)','fontsize',12)
ylabel('p (arb.)','fontsize',12)
export_fig(gcf, 'genautolorenzhist.tiff', '-transparent', '-nocrop')

figure
plot([1:9974]./1000,gaco(5,:));
set(gca,'TickDir','out')
box off
xlabel('time (s)','fontsize',12)
ylabel('autocorrelation (arb.)','fontsize',12)
export_fig(gcf, 'autocorrlorenz.tiff', '-transparent', '-nocrop')