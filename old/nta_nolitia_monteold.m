function results=nta_nolitia_monte(data1,data2,cfg)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Tests statistical differences of provided datasets using nonparametric 
%Monte-Carlo simulations
%INPUT:
%   data1: input data (cell array of subjects), 1xN, cell array
%   data2: input data (cell array of subjects), 1xN, cell array
%CONFIGURATION STRUCTURE:
%   cfg.numperm: Number of permutations,1x1,int, default: 1000
%   cfg.vars: variables to test,1xN,int, default: 1
%   cfg.outputvar: specific output variable of vars to test
%   cfg.alpha: alpha level to test, 1x1, double, default: 0.05
%   cfg.bonf: Bonferroni correction yes/no [1/0],1x1, int, default: 0
%   cfg.verbose: verbose level [1/0], 1x1, int, default: 1
%   cfg.method: name of method of which results should be tested
%   cfg.plt: plot surrogate distribution with respect to original statistical differences 
%OUTPUT:
%   results.cfg: configuration structure
%   results.p: p-value
%   results.sig: significant yes/no [1/0]
%   results.diffsurr_grand: grand mean of differences between surrogate datasets
%   results.difforig_grand: grand mean of differences between original datasets
%DEPENDENCIES:
%   -
%Author: Immo Weber, 2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
verbose=1;
method=cfg.method;
outputvar=cfg.outputvar;
if isfield(cfg,'numperm')==1
    numperm=cfg.numperm;
else
    numperm=1000;
    if verbose==1
        disp('No number of permutations specified! Assigning default: 1000 permutations.')
    end
end

if isfield(cfg,'vars')==1
    vars=cfg.vars;
else
    vars=1;
    if verbose==1
        disp('No variables specified! Assigning default: first')
    end
end

if isfield(cfg,'alpha')==1
    alpha=cfg.alpha;
else
    alpha=0.05;
    if verbose==1
        disp('No alpha level specified! Assigning default: 0.05')
    end
end

if isfield(cfg,'bonf')==1
    bonf=cfg.bonf;
else
    bonf=0;
    if verbose==1
        disp('Bonferroni correction not specified! Assigning default: no correction.')
    end
end

if isfield(cfg,'plt')==1
    plt=cfg.plt;
else
    plt=0;
    if verbose==1
        disp('Plotting options not specified! Assigning default: no plotting.')
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
numdatasets=length(data1); 
for numvar=1:length(vars)
 extrData1=[];
 extrData2=[];
 for dataset=1:numdatasets
 n1(dataset)=size(data1{dataset}.methods(ismember({data1{dataset}.methods.methodnames},method)).results,2);
 n2(dataset)=size(data2{dataset}.methods(ismember({data2{dataset}.methods.methodnames},method)).results,2);
 
 for numrep=1:n1
 extrData1(dataset,numrep)=eval(['data1{dataset}.methods(ismember({data1{dataset}.methods.methodnames},method)).results{numrep}{vars(numvar)}.' outputvar]);
 end
 
 for numrep=1:n2
 extrData2(dataset,numrep)=eval(['data2{dataset}.methods(ismember({data2{dataset}.methods.methodnames},method)).results{numrep}{vars(numvar)}.' outputvar]);
 end
 
 [res] = nta_nolitia_t_values(extrData1(dataset,:),extrData2(dataset,:),2,numrep);
 diff_orig(numvar,dataset)=res.stat;
%  m1(dataset)=mean(extrData1(dataset,:),2);
%  m2(dataset)=mean(extrData2(dataset,:),2);
%  diff_orig(numvar,dataset)=m1(dataset)-m2(dataset);
 end
 diff_orig_grand(numvar)=mean(diff_orig(numvar,:));
 h = waitbar(0,'Please wait...');
%% Permutation statistic %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for permi=1:numperm
    
    for dataset=1:numdatasets
        tempsurr=[extrData1(dataset,:) extrData2(dataset,:)];
        rand_outp=randperm(n1(dataset)+n2(dataset));
        
        tempsurr=tempsurr(rand_outp);
        
        % diffsurr(dataset)=mean(tempsurr(1:n1))-mean(tempsurr(n1+1:end));
        [res] = nta_nolitia_t_values(tempsurr(1:n1),tempsurr(n1+1:end),2,numrep);
        diffsurr(dataset)=res.stat;
    end
    diffsurr_grand(numvar,permi)=mean(diffsurr);
    waitbar(permi/numperm,h)
end
close(h)

p_value(numvar)=size(find(abs(diffsurr_grand(numvar,:))>abs(diff_orig_grand(numvar))),2)/numperm;
if plt==1
    counts=histcounts(diffsurr_grand(numvar,:), 'Normalization', 'probability');
    figure
    bar(counts)
    hold on
    plot([diff_orig_grand(numvar) diff_orig_grand(numvar)],[0 max(counts)],'r')
    xlabel('Surrogate distribution')
    ylabel('Probability [arb.]')
    title(['variable: ' num2str(numvar)])
end
    
end
%% Generate results struct %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
results.p=p_value;
if bonf==0
    results.sig=p_value<alpha;
else
    results.sig=p_value<alpha./length(vars);
end
results.diffsurr_grand=diffsurr_grand;
results.diff_orig_grand=diff_orig_grand;
results.cfg=cfg;


end