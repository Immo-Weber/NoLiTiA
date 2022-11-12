function lyadimrange(data,cfg)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Estimation of the maximum lyapunov exponent for a range of embedding dimensions (Kantz 1994, Rosenstein et al. 1993).
%   data: input data, 1xN, double
%CONFIGURATION STRUCTURE:
%   cfg.tau: embedding delay,  1x1, int, default: 1
%   cfg.dims: range of embedding dimensions(min max), 1x2, int, default: [2 9]
%   cfg.en: size of neighbourhood(% of maximal attractor diameter), 1x2,
%   double, default: 5
%   cfg.numran: number of random points used for calculation, 1x1, int,
%   default: 100
%   cfg.th: Theiler window in samples, 1x1, int, default: 0
%   cfg.it: number of forward iterations in time, 1x1, int, default: 10
%   cfg.method: either choose Kantz ['Kantz'] or Rosenstein's ['Rosenstein'] algorithm, char, default: 'Kantz' 
%   cfg.plt: plot results yes/no [1/0], 1x1, int, default: 1
%DEPENDENCIES:
%   lya
%Author: Immo Weber, 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('       _  __       __    _  ______ _  ___        ');
disp('      / |/ /___   / /   (_)/_  __/(_)/ _ |       ');
disp('     /    // _ \ / /__ / /  / /  / // __ |       ');
disp('    /_/|_/ \___//____//_/  /_/  /_//_/ |_|       ');
disp('                                                 ');
%%%read in parameters%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isfield(cfg,'dims')==1
dimstart=cfg.dims(1);
dimend=cfg.dims(2);
else
    dimstart=2;
    dimend=9;
    disp('No range of dimensions specified. Assigning default: [2 9]')
end

if isfield(cfg,'tau')==1
    tau=cfg.tau;
else
    tau=0;
    disp('No embedding delay specified. Assigning default: 0 (optimization)')
end
if isfield(cfg,'en')==1
    en=cfg.en;
else
    en=5;
    disp('No neighbourhood-size specified. Assigning default: 5')
end
if isfield(cfg,'it')==1
    it=cfg.it;
else
    it=10;
    disp('No number of iterations specified. Assigning default: 10')
end
if isfield(cfg,'th')==1
    th=cfg.th;
else
    th=0;
    disp('No Theiler-window specified. Assigning default: 0 (optimization)')
end
if isfield(cfg,'resl')==1
    resl=cfg.resl;
else
    resl=2;
    disp('No resolution for line fitting specified. Assigning default: 2')
end
if isfield(cfg,'numran')==1
    numran=cfg.numran;
else
    numran=100;
    disp('No number of random points specified. Assigning default: 100')
end
if isfield(cfg,'plt')==1
    plt=cfg.plt;
else
    plt=1;
end
if isfield(cfg,'method')==1
    method=cfg.method;
else
    method='Kantz';
    disp('No estimator specified. Assigning default: Kantz')
end

cfgl.dim=0;
cfgl.tau=tau;
cfgl.en=en;
cfgl.it=it;
cfgl.th=th;
cfgl.resl=resl;
cfgl.numran=numran;
cfgl.plt=0;
cfg1.method=method;

figure
hold all

h = waitbar(0,'Please wait...');
steps = dimend-dimstart;
for dim=dimstart:dimend
    cfgl.dim=dim;
[results]=lya(data,cfgl)
%  plot(0:length(lglyavektortn(1:end))-1,lglyavektortn(1:end),'b')
%  text(0:length(lglyavektortn(1:end))-1,lglyavektortn(1:end),[num2str(dim)])
 text(0:resl:length(results.diffloglya)*resl-1,results.diffloglya,[num2str(dim)])
 plot(0:resl:length(results.diffloglya)*resl-1,results.diffloglya);
waitbar((dim/steps))
end
close(h)
xlabel('Iterations')
ylabel('LLE')