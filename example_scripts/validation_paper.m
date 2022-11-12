%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Validation%%
%%%entropykozachenko%%
unif=rand(30000,1); %uniform distribution (UD)
gau=1*randn(30000,1); %Gaussian distribution (GD)   

ent_unif_analy=0.5*log2(12*var(unif)); %analytic entropy estimate of UD
ent_gau_anal=0.5*log2(2*pi*exp(1)*var(gau)); %analytic entropy estimate of GD

cfg.dim=1;
cfg.tau=1;

for i=1:200
    cfg.mass=i;
    ent_unif_esti=entropykozachenko(unif,cfg); %Estimation of UD using Kozachenko's estimator
    ent_gau_esti=entropykozachenko(gau,cfg); %Estimation of GD
    
    ent_unif_esti=ent_unif_esti.Hx/log(2); %Converting in Bit
    ent_gau_esti=ent_gau_esti.Hx/log(2);
    
    diff_uni_ko(i)=abs(ent_unif_analy-ent_unif_esti); %Difference of analytic result and estimation (UD)
    diff_gau_ko(i)=abs(ent_gau_anal-ent_gau_esti); %Difference of analytic result and estimation (GD)
    i
end

for i=1:2000
cfg.numbin=i;
temp1=entropybin(unif,cfg);
temp2=entropybin(gau,cfg);

ent_unif_esti_bin(i)=temp1.Hx;
ent_gau_esti_bin(i)=temp2.Hx;

diff_uni_bin(i)=abs(ent_unif_analy-ent_unif_esti_bin(i));
diff_gau_bin(i)=abs(ent_gau_anal-ent_gau_esti_bin(i));
end


%%MIkraskov%%
N=4000;
for k=1:100
R = mvnrnd([1 1],[1 0.91; 0.91 1],N); %Generation of two unit variance Gaussians with covariance 0.9
R=zscore(R);
cfg.dims=[1 1];
cfg.taus=[1 1];

for i=1:300 %Estimation of MI using Kraskov's estimator as a function of mass
    cfg.mass=i;
    [ results ] = MIkraskov( R(:,1),R(:,2),cfg );
    MI_kraskov(i,1,k)=(i);
    MI(i,2,k)=results.MI;    
end
k
end

N=4000;
R = mvnrnd([1 1],[1 0.91; 0.91 1],N); %Generation of two unit variance Gaussians with covariance 0.9
R=zscore(R);
cfg=[];
for i=1:100 %Estimation of MI using Kraskov's estimator as a function of mass
    cfg.numbin=i;
    [ results ] = MIbin( R(:,1),R(:,2),cfg );
    MI_bin(i,1)=(i);
    MI_bin(i,2)=results.MI;    
end
%%%%%%Analyze Lorenz%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
L=1:0.025:1000;
[x,y,z] = lorenzgen( L );
data=x(1:10000);

cfg.numbin=500;
cfg.maxlag=5000;
cfg.plt=0;
resultsAMI=amutibin(data,cfg);

cfg=[];
cfg.tau=resultsAMI.firstmin;
cfg.dim=9;
cfg.plt=0;
[results_fnn]=fnn(data,cfg);

cfg=[];
cfg.plt=0;
cfg.mass=4;
cfg.numran=500;
cfg.dims=[2 9];
cfg.taus=[10:10:200];
[results_ragwitz]=ragwitz(data,cfg);

cfg=[];
cfg.tau=resultsAMI.firstmin;
cfg.dim=3;
cfg.nr=5;
cfg.maxlag=100;
[results_STS]=spacetimesep(data,cfg);

cfg=[];
cfg.dim=3;
cfg.tau=resultsAMI.firstmin;
cfg.plt=0;
results_emb=phasespace(data,cfg);

cfg=[];
cfg.lag=1;
cfg.numsurr=1000;
cfg.surrmode=3;
[results_TR]=timerev(data,cfg);

cfg=[];
cfg.tau=0;
cfg.ens=[0.1 100];
cfg.nr=100;
cfg.plt=0;
for i=1:9
    cfg.dim=i;
    [results_corrdim(i)]=corrdim(data(1:10000),cfg);
end

cfg=[];
cfg.tau=0;
cfg.en=5;
cfg.numran=100;
cfg.it=50;
cfg.plt=0;
for i=1:9
    cfg.dim=i;
    [results_lya(i)]=lya(data(1:10000),cfg);
end

cfg=[];
cfg.dim=3;
cfg.tau=resultsAMI.firstmin;
cfg.ens=[1 1 101];
cfg.singlenei=1;
cfg.norm=1;
cfg.plt=0;
[results_en_scan]=recfreq_en_scan(data,cfg);

cfg=[];
cfg.dim=3;
cfg.tau=resultsAMI.firstmin;
cfg.en=30;
cfg.window=400;
cfg.minlengthdet=10;
cfg.minlengthlam=10;
cfg.singlenei=1;
cfg.norm=1;
cfg.plt=0;
results_wind_rec=wind_recfreq(data,cfg);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[logmap]=logisticmap(100,3.92);
cfg=[];
cfg.tau=1;
cfg.bins=[200 200];
cfg.numit=500;
cfg.numsurr=1000;
cfg.surrmode=1;
[results] = upo( logmap,cfg );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Plot Results%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%Lorenz%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('Lorenz_example.mat')

figure
plot(resultsAMI.ami(1:200),'linewidth',3,'color','r')
axis square
ylim([5 6.6])
xlabel('Lag [samples]','fontsize',12);
ylabel('MI [bit]','fontsize',12)
xt = get(gca, 'XTick');
set(gca, 'FontSize', 12)

figure
plot(results_fnn.fnn(2,:),results_fnn.fnn(1,:),'linewidth',3,'color','r')
axis square
xlim([1 9])
xlabel('Dim','fontsize',12);
ylabel('FNN [%]','fontsize',12)
xt = get(gca, 'XTick');
set(gca, 'FontSize', 12)

figure
contour(results_STS.lagvector,results_STS.classvector,results_STS.hto,results_STS.cfg.nr,'ShowText','on','linewidth',3)
axis square
xlabel('dT [samples]','fontsize',12)
ylabel('dE [arb.]','fontsize',12)
xt = get(gca, 'XTick');
set(gca, 'FontSize', 12)

figure
n=size(results_emb.embTS(:,1),1);
p=plot3(results_emb.embTS(:,1),results_emb.embTS(:,2),results_emb.embTS(:,3))
cd = [uint8(hot(n)*255) uint8(ones(n,1))].' %'
drawnow
set(p.Edge, 'ColorBinding','interpolated', 'ColorData',cd)
axis square
view([90 0])
xlabel('X-Axis','fontsize',12);
ylabel('Y-Axis','fontsize',12)
zlabel('Z-Axis','fontsize',12);
xt = get(gca, 'XTick');
set(gca, 'FontSize', 12)

figure
n=10000;
p=plot3(x(1:10000),y(1:10000),z(1:10000));
cd = [uint8(hot(n)*255) uint8(ones(n,1))].' %'
drawnow
set(p.Edge, 'ColorBinding','interpolated', 'ColorData',cd)
axis square
view([0 90])
xlabel('X-Axis','fontsize',12);
ylabel('Y-Axis','fontsize',12)
zlabel('Z-Axis','fontsize',12);
xt = get(gca, 'XTick');
set(gca, 'FontSize', 12)

figure
histogram(results_TR.Qtsurr);
hold on
plot([results_TR.Qt results_TR.Qt],[0 50],'linewidth',3)
% xlim([-1.45*10^-4 -1.41*10^-4])
axis square
xlabel('Qt [arb.]','fontsize',12)
ylabel('Frequency [arb.]','fontsize',12)
xt = get(gca, 'XTick');
set(gca, 'FontSize', 12)
legend('Surrogates','Original','Location','northwest')

figure
hold on
for i=1:9
    plot(results_corrdim(i).logE_logC(1:2:length(results_corrdim(i).diff_logC)*2-1,1),results_corrdim(i).diff_logC,'linewidth',2);
end
hold on
plot(results_corrdim(i).logE_logC(1:2:length(results_corrdim(i).diff_logC)*2-1,1),repmat(2.055,1,49),'--k','linewidth',3)
axis square
xlabel('Scale [arb.]','fontsize',12)
ylabel('Dim','fontsize',12)
xt = get(gca, 'XTick');
set(gca, 'FontSize', 12)
legend({'1','2','3','4','5','6','7','8','9'},'FontSize',8)

figure
hold on
for i=1:9
    plot(40*[0:2:50-(2-1)],40*results_lya(i).diffloglya,'linewidth',2);
end
hold on
plot(40*[0:2:50-(2-1)],repmat(0.906,1,25),'--k','linewidth',3)
axis square
xlabel('Iterations [s]','fontsize',12)
ylabel('Lyapunov Exponent','fontsize',12)
xt = get(gca, 'XTick');
set(gca, 'FontSize', 12)
legend({'1','2','3','4','5','6','7','8','9'},'FontSize',8)

figure
pcolor(1:size(results_en_scan.loght,2),1:1:101,results_en_scan.loght)
shading interp
set(gca, 'XScale', 'log')
view(180,-90)
xlabel('T [Samples]','fontsize',12)
ylabel('Scale (%)','fontsize',12)
set(gca,'TickDir','out')
box off
colormap('jet')
h=colorbar
ylabel(h, 'Log(P(T))','fontsize',12);

figure
surf(results_wind_rec.time,1:385,results_wind_rec.resht);
axis tight
shading interp;
view([0 90])
xlabel('Time [Samples]','fontsize',12);
ylabel('T [samples]','fontsize',12)
colormap('jet')
h=colorbar
ylabel(h, 'Log(P(T))','fontsize',12);

%%%Logistic%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('UPO_logistic.mat')

figure
plot(results_UPO.bincenters{1},results_UPO.histdiagzscores,'linewidth',3,'color','b')
axis square
axis tight
xlabel('Transformed Variable','fontsize',12);
ylabel('Z-Test Score [arb.]','fontsize',12)
xt = get(gca, 'XTick');
set(gca, 'FontSize', 12)
hold on
plot([0.745 0.745],[min(results_UPO.histdiagzscores) 2],'linewidth',3,'color','r')
hold on
plot(results_UPO.bincenters{1},repmat(1.96,1,200),'--k','linewidth',3)
legend('Z-Scores','Analytic Result','Sig. Threshold','Location','northwest')

figure
surf(results_UPO.bincenters{1},results_UPO.bincenters{2},results_UPO.counttrans)
grid off
axis tight
view([0 90])
shading interp
xlabel('X-Axis','fontsize',12);
ylabel('Y-Axis','fontsize',12);
zlabel('P(x)','fontsize',12);
xt = get(gca, 'XTick');
set(gca, 'FontSize', 12);
caxis([0 0.36])
h = colorbar;
ylabel(h, '<P(x)>','fontsize',12);

figure
surf(results_UPO.bincenters{1},results_UPO.bincenters{2},results_UPO.countorig)
view([0 90])
grid off
axis tight
shading interp
xlabel('X-Axis','fontsize',12);
ylabel('Y-Axis','fontsize',12);
zlabel('P(x)','fontsize',12);
xt = get(gca, 'XTick');
set(gca, 'FontSize', 12);
caxis([0 0.36])
h = colorbar;
ylabel(h, 'P(x)','fontsize',12);

figure
plot(results_UPO.bincenters{1},diag(results_UPO.countorig),'linewidth',3,'color','b')
hold on
plot(results_UPO.bincenters{1},diag(results_UPO.counttrans),'linewidth',3,'color','r')
axis square
axis tight
xlabel('X-Axis [arb.]','fontsize',12);
ylabel('<P(X)> [arb.]','fontsize',12)
xt = get(gca, 'XTick');
set(gca, 'FontSize', 12)
legend('Original','Transformed','Location','northwest')

%%Gaussians%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('uni_gau_koz_entropy_func_of_mass.mat')
load('uni_gau_bin_entropy_func_of_binsize.mat')
load('gau_MI_func_of_mass_100_reali.mat')

figure
semilogy(1:2000,diff_gau_bin,'linewidth',3,'color','r')
axis square
xlim([1 200])
ylim([0.0001 1])
xlabel('Number of Bins','fontsize',12);
ylabel('dH [bit]','fontsize',12)
xt = get(gca, 'XTick');
set(gca, 'FontSize', 12)

figure
semilogy(1:200,diff_gau_ko,'linewidth',3,'color','r')
axis square
xlim([1 200])
ylim([0.0001 1])
xlabel('Mass','fontsize',12);
ylabel('dH [bit]','fontsize',12)
xt = get(gca, 'XTick');
set(gca, 'FontSize', 12)

figure
plot(1:300,MI(:,2,3),'linewidth',3,'color','r')
axis square
xlim([1 300])
xlabel('Mass','fontsize',12);
ylabel('MI [nats]','fontsize',12)
xt = get(gca, 'XTick');
set(gca, 'FontSize', 12)
hold on
plot(1:300,repmat(0.830366,1,300),'--k','linewidth',3)

figure
plot(1:100,MI_bin(:,2),'linewidth',3,'color','r')
axis square
xlim([1 100])
xlabel('Number of Bins','fontsize',12);
ylabel('MI [bit]','fontsize',12)
xt = get(gca, 'XTick');
set(gca, 'FontSize', 12)
hold on
plot(1:100,repmat(0.830366,1,100),'--k','linewidth',3)





