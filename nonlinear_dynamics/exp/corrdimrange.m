function corrdimrange(data,cfgj)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Estimating and plotting of the correlation dimension for a range of embedding dimensions(Grassberger and Procaccia, 1983).
%   data: input data, 1xN double
%CONFIGURATION STRUCTURE:
%   cfgj.tau: embedding  delay,  1x1, int, default: 1
%   cfgj.dims: range of embedding dimensions(min max), 1x2, int, default: [2 9]
%   cfgj.ens: min and max size of neighbourhood(% of maximal attractor diameter), 1x2, double, default: [0 100]
%   cfgj.nr: number of neighbourhoods, 1x1, int, default: 10
%   cfgj.th: Theiler window in samples, 1x1, int, default: 0
%   cfgj.resl: num. of points used for slope calculation, 1x1, int, default: 2
%   cfgj.plt: plot results yes/no  [1/0], 1x1, int, default: 1
%DEPENDENCIES:
%   corrdim
%Author: Immo Weber, 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('       _  __       __    _  ______ _  ___        ');
disp('      / |/ /___   / /   (_)/_  __/(_)/ _ |       ');
disp('     /    // _ \ / /__ / /  / /  / // __ |       ');
disp('    /_/|_/ \___//____//_/  /_/  /_//_/ |_|       ');
disp('                                                 ');
%%%read in parameters%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isfield(cfgj,'dims')==1
    dimstart=cfgj.dims(1);
    dimend=cfgj.dims(2);
else
    dimstart=2;
    dimend=9;
    disp('No range of dimensions specified. Assigning defaults: [2 9]')
end

if isfield(cfgj,'tau')==1
    tau=cfgj.tau;
else
    tau=0;
    disp('No embedding delay specified. Assigning defaults: [0] (optimization)')
end

if isfield(cfgj,'ens')==1
    enstart=log10(cfgj.ens(1));
    enend=log10(cfgj.ens(2));
else
    enstart=0;
    enend=2;
    disp('No scale limits specified. Assigning defaults: [1 100]')
end
if isfield(cfgj,'th')==1
    th=cfgj.th;
else
    th=0;
    disp('No Theiler window specified. Assigning defaults: 0 (optimization)')
end
if isfield(cfgj,'resl')==1
    resl=cfgj.resl;
else
    resl=2;
    disp('No number of adjacent points for slope calculation specified. Assigning defaults: 2')
end
if isfield(cfgj,'nr')==1
    nr=cfgj.nr;
else
    nr=10;
    disp('No number of scales specified. Assigning defaults: [10]')
end
if isfield(cfgj,'plt')==1
    plt=cfgj.plt;
else
    plt=1;
end
%%%%%passing parameters to corrdim function%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cfg.dim=0;
cfg.tau=tau;
cfg.ens=[enstart enend];
cfg.nr=nr;
cfg.resl=resl;
cfg.plt=0;
cfg.th=th;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
hold all
k=1;
%%%calculate correlation dimension for range of dimensions%%%%%%%%%%%%%%%%%
h = waitbar(0,'Please wait...');
steps = dimend-dimstart;
for dim=dimstart:dimend
    cfg.dim=dim;
    [results]=corrdim(data,cfg);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%plot results%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if  plt==1
        text(results.logE_logC(1:resl:length(results.diff_logC)*resl-1,1),results.diff_logC,[num2str(dim)])
        plot(results.logE_logC(1:resl:length(results.diff_logC)*resl-1,1),results.diff_logC,'linewidth',3,'color',[1/k 0 0]);
        k=k+1;
        axis square
    end
    waitbar((dim/steps))
end
close(h)
xlabel('Log E','fontsize',12)
ylabel('Dim','fontsize',12)
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',18)
b = get(gca,'YTickLabel');
set(gca,'YTickLabel',b,'FontName','Times','fontsize',18)