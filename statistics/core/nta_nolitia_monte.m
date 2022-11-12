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
 temp1=[];
 temp2=[];
 for numrep=1:n1(dataset)
 temp1(numrep)=eval(['data1{dataset}.methods(ismember({data1{dataset}.methods.methodnames},method)).results{numrep}{vars(numvar)}.' outputvar]);
 end
 
 extrData1(1,dataset)=mean(temp1);
 
 for numrep=1:n2(dataset)
 temp2(numrep)=eval(['data2{dataset}.methods(ismember({data2{dataset}.methods.methodnames},method)).results{numrep}{vars(numvar)}.' outputvar]);
 end
 extrData2(1,dataset)=mean(temp2);
 
  
%  m1(dataset)=mean(extrData1(dataset,:),2);
%  m2(dataset)=mean(extrData2(dataset,:),2);
%  diff_orig(numvar,dataset)=m1(dataset)-m2(dataset);
 end
 [res] = nta_nolitia_t_values(extrData1,extrData2,2,numdatasets);
 diff_orig(numvar,dataset)=res.stat;
 diff_orig_grand(numvar)=res.stat;
 h = waitbar(0,'Please wait...');
%% Permutation statistic %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for permi=1:numperm
    
        tempsurr=[extrData1 extrData2];
        rand_outp=randperm(2*numdatasets);
        
        tempsurr=tempsurr(rand_outp);
        
        % diffsurr(dataset)=mean(tempsurr(1:n1))-mean(tempsurr(n1+1:end));
        [res] = nta_nolitia_t_values(tempsurr(1:numdatasets),tempsurr(numdatasets+1:end),2,numdatasets);
        
    
    diffsurr_grand(numvar,permi)=res.stat;
    waitbar(permi/numperm,h)
end
close(h)

p_value(numvar)=size(find(abs(diffsurr_grand(numvar,:))>abs(diff_orig_grand(numvar))),2)/numperm;
if plt==1
    [counts,edges]=histcounts(diffsurr_grand(numvar,:), 'Normalization', 'probability');
    figure
    bar(edges(1:end-1),counts)
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