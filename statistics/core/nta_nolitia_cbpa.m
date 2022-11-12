function [results] = nta_nolitia_cbpa(data1,data2,cfg)
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
        disp('No total alpha level specified! Assigning default: 0.05')
    end
end

if isfield(cfg,'clustalpha')==1
    clustalpha=cfg.clustalpha;
else
    clustalpha=0.05;
    if verbose==1
        disp('No alpha level for clusters specified! Assigning default: 0.05')
    end
end

if isfield(cfg,'maxcluster')==1
    maxcluster=cfg.maxcluster;
else
    maxcluster='sicec';
    %     if verbose==1
    %         disp('No alpha level specified! Assigning default: 0.05')
    %     end
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
slowco=0;
hasIPT = license('test', 'image_toolbox');
avIPT= license('checkout','image_toolbox');
if hasIPT==0 | avIPT==0
    warning('No Image Processing Toolbox available! Using slower alternative...')
    slowco=1;
end
     
    for numvar=1:length(vars)
        h = waitbar(0,'Computing cluster statistics...');
        extrData1=[];
        extrData2=[];
        mdata1=[];
        mdata2=[];
        nopos=0;
        noneg=0;
        for dataset=1:numdatasets
            n1(dataset)=size(data1{dataset}.methods(ismember({data1{dataset}.methods.methodnames},method)).results,2);
            n2(dataset)=size(data2{dataset}.methods(ismember({data2{dataset}.methods.methodnames},method)).results,2);
            
            for numrep=1:n1                
                extrData1(dataset,numrep,:,:)=getfield(data1{dataset}.methods(ismember({data1{dataset}.methods.methodnames},method)).results{numrep}{vars(numvar)},outputvar);
            end
            
            for numrep=1:n2                
                extrData2(dataset,numrep,:,:)=getfield(data2{dataset}.methods(ismember({data2{dataset}.methods.methodnames},method)).results{numrep}{vars(numvar)},outputvar);
            end
            
            if numdatasets>1
                mdata1(dataset,:,:)=squeeze(mean(extrData1(dataset,:,:,:),2));
                mdata2(dataset,:,:)=squeeze(mean(extrData2(dataset,:,:,:),2));
                ndata=numdatasets;
            else
                mdata1=squeeze(extrData1(dataset,:,:,:));
                mdata2=squeeze(extrData2(dataset,:,:,:));
                ndata=n1;
            end
            
        end
 %%       
        [resorig] = nta_nolitia_t_values(mdata1,mdata2,1,ndata);
        t_orig(numvar,:,:)=squeeze(resorig.stat);
        critval = [tinv(clustalpha/2,ndata-1),tinv(1-clustalpha/2,ndata-1)];
        thr_orig_pos(numvar,:,:)=squeeze(t_orig(numvar,:,:)>critval(2));
        thr_orig_neg(numvar,:,:)=squeeze(t_orig(numvar,:,:)<critval(1));
        
  if slowco~=1      
         CC = bwconncomp(squeeze(thr_orig_pos(numvar,:,:)),4);
  else
         [CC]=connsets7(squeeze(thr_orig_pos(numvar,:,:)));
  end

        if isempty(CC.PixelIdxList)==0
            if strcmpi(maxcluster,'sizec')==1
                numPixels = cellfun(@numel,CC.PixelIdxList);
                [~,idx_orig] = max(numPixels);
                orig_la_cl_t_pos(numvar)=sum(t_orig(numvar,CC.PixelIdxList{idx_orig}));
                id_largest_cluster_pos{numvar}=CC.PixelIdxList{idx_orig};
            elseif strcmpi(maxcluster,'sumt')==1
                [orig_la_cl_t_pos{numvar},id_largest_cluster_pos{numvar}]=sum_t_cluster(CC.PixelIdxList,t_orig(numvar,:));
            end
        else
            nopos=1;
        end
        if slowco~=1
            CC = bwconncomp(squeeze(thr_orig_neg(numvar,:,:)),4);
        else
            [CC]=connsets7(squeeze(thr_orig_neg(numvar,:,:)));
        end

        
        if isempty(CC.PixelIdxList)==0
            if strcmpi(maxcluster,'sizec')==1
                numPixels = cellfun(@numel,CC.PixelIdxList);
                [~,idx_orig] = max(numPixels);
                orig_la_cl_t_neg(numvar)=sum(t_orig(numvar,CC.PixelIdxList{idx_orig}));
                id_largest_cluster_neg{numvar}=CC.PixelIdxList{idx_orig};
            elseif strcmpi(maxcluster,'sumt')==1
                
                [orig_la_cl_t_neg{numvar},id_largest_cluster_neg{numvar}]=sum_t_cluster(CC.PixelIdxList,abs(t_orig(numvar,:)));
            end
            
        else
            noneg=1;
        end
        
        if nopos==1 & noneg==1
            disp('no clusters found!')
            close(h)
            continue
        end   
        
      
       
      %%  
      tempsurr=[mdata1;mdata2];
        [~, rand_outp] = sort(rand(numperm,2*ndata),2);
      surr_la_cl_t_pos=NaN(length(vars),numperm);
      surr_la_cl_t_neg=NaN(length(vars),numperm);
        
      for permi=1:numperm
          
          tempsurr=tempsurr(rand_outp(permi,:),:,:);
          
          [ressurr]=nta_nolitia_t_values(tempsurr(1:ndata,:,:),tempsurr(ndata+1:end,:,:),1,ndata);
          t_surr=squeeze(ressurr.stat);
          

          
          if slowco~=1
              CC = bwconncomp(squeeze(t_surr>critval(2)),4);
          else
              [CC]=connsets7(squeeze(t_surr>critval(2)));
          end

          
          if isempty(CC.PixelIdxList)==0
              if strcmpi(maxcluster,'sizec')==1
                  numPixels = cellfun(@numel,CC.PixelIdxList);
                  [~,idx] = max(numPixels);
                  surr_la_cl_t_pos(numvar,permi)=sum(t_surr(CC.PixelIdxList{idx}));
              elseif strcmpi(maxcluster,'sumt')==1
                  [tempc,~]=sum_t_cluster(CC.PixelIdxList,t_surr);
                  surr_la_cl_t_pos(numvar,permi)=tempc(1);
              end
              
          else
              surr_la_cl_t_pos(numvar,permi)=NaN;
          end
          
          if slowco~=1
              CC = bwconncomp(squeeze(t_surr<critval(1)),4);
          else
              [CC]=connsets7(squeeze(t_surr<critval(1)));
          end

          
          if isempty(CC.PixelIdxList)==0
              if strcmpi(maxcluster,'sizec')==1
                  numPixels = cellfun(@numel,CC.PixelIdxList);
                  [~,idx] = max(numPixels);
                  surr_la_cl_t_neg(numvar,permi)=sum(t_surr(CC.PixelIdxList{idx}));
              elseif strcmpi(maxcluster,'sumt')==1
                  [tempc,~]=sum_t_cluster(CC.PixelIdxList,abs(t_surr));
                  surr_la_cl_t_neg(numvar,permi)=tempc(1);
              end
          else
              surr_la_cl_t_neg(numvar,permi)=NaN;
          end
          
          
          waitbar(permi/numperm,h)
      end
        close(h)
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if nopos==0  
            for numclusters=1:length(orig_la_cl_t_pos{numvar})
            results.pos_cluster(numvar).p(numclusters)=2.*size(find(surr_la_cl_t_pos(numvar,:)>orig_la_cl_t_pos{numvar}(numclusters)),2)/numperm;
            if results.pos_cluster(numvar).p(numclusters)>1
                results.pos_cluster(numvar).p(numclusters)=1;
            end
            results.pos_cluster(numvar).ids{numclusters}=id_largest_cluster_pos{numvar}{numclusters};
            results.pos_cluster(numvar).sig(numclusters)=results.pos_cluster(numvar).p(numclusters)<alpha;
            end
        end
        if noneg==0   
            for numclusters=1:length(orig_la_cl_t_neg{numvar})
            results.neg_cluster(numvar).p(numclusters)=2.*size(find(surr_la_cl_t_neg(numvar,:)>orig_la_cl_t_neg{numvar}(numclusters)),2)/numperm;
            if results.neg_cluster(numvar).p(numclusters)>1
                results.neg_cluster(numvar).p(numclusters)=1;
            end
            results.neg_cluster(numvar).ids{numclusters}=id_largest_cluster_neg{numvar}{numclusters};
            results.neg_cluster(numvar).sig(numclusters)=results.neg_cluster(numvar).p(numclusters)<alpha;
            end
        end
        results.averages(:,1,numvar)=squeeze(mean(mdata1,1));
        results.averages(:,2,numvar)=squeeze(mean(mdata2,1));
    end
    results.cfg=cfg;
    
    
    if plt==1
        for numvar=1:length(vars)
            figure
            minval=min(min(results.averages(:,:,numvar)));
            maxval=max(max(results.averages(:,:,numvar)));
            plot(results.averages(:,1,numvar),'r');
            hold on
            plot(results.averages(:,2,numvar),'g');
            xlabel('Time [samples]','Fontsize',12)
            ylabel('Variable','Fontsize',12)
            title('Cluster-statistics')
            legend('group 1', 'group 2')
            
            if isfield(results,'pos_cluster')==1
                sigind=find(results.pos_cluster(numvar).sig==1);
                for i=1:length(sigind)
                    patch([results.pos_cluster(numvar).ids{sigind(i)}(1) results.pos_cluster(numvar).ids{sigind(i)}(end) results.pos_cluster(numvar).ids{sigind(i)}(end) results.pos_cluster(numvar).ids{sigind(i)}(1)],[minval minval maxval maxval],'g','FaceAlpha',.3)
                    text(results.pos_cluster(numvar).ids{sigind(i)}(1),maxval,['pos. cluster ' num2str(i) ': p=' num2str(results.pos_cluster(numvar).p(sigind(i)))] )
                end
            end
            
            if isfield(results,'neg_cluster')==1
                sigind=find(results.neg_cluster(numvar).sig==1);
                for i=1:length(sigind)
                    patch([results.neg_cluster(numvar).ids{sigind(i)}(1) results.neg_cluster(numvar).ids{sigind(i)}(end) results.neg_cluster(numvar).ids{sigind(i)}(end) results.neg_cluster(numvar).ids{sigind(i)}(1)],[minval minval maxval maxval],'r','FaceAlpha',.3)
                    text(results.neg_cluster(numvar).ids{sigind(i)}(1),maxval,['neg. cluster ' num2str(i) ': p=' num2str(results.neg_cluster(numvar).p(sigind(i)))] )
                end
                
            end
        title(['variable: ' num2str(numvar)])    
        end
    end

end


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [min_max_sum_t,min_max_ind_t]=sum_t_cluster(indx,tges)
res_sum_t=NaN(1,length(indx));
for i=1:length(indx)
    res_sum_t(i)=sum(tges(indx{i}));
end
% [min_max_sum_t,ind_t]=max(res_sum_t);
[min_max_sum_t,ind_t]=sort(res_sum_t,'descend');
min_max_ind_t=indx(ind_t);
end



