function [ handles,root ] = NoLiTiA_plot_tree( handles )
%%Subroutine for plot_batch_gui%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
root = uitreenode('v0', 'Methods', 'Methods', [], false);
if isfield(handles.results.methods,'methodnames')==1    
    for i=1:length(handles.results.methods)
        eval([handles.results.methods(i).methodnames '= uitreenode(''v0'',''' handles.results.methods(i).methodnames ''',''' handles.results.methods(i).methodnames ''', [], false);']);
        eval(['root.add(' handles.results.methods(i).methodnames ')']);
        methodvar=fieldnames(handles.results.methods(i).results{1}{1});
        methodvar(ismember(methodvar,{'cfg','dist','lagvector','classvector','prges','it','residuals','meanresidual','meanresiduals','logbox','lognges','neighsizelist','m1','m2','jp','time','lags','embTS','N','ens','bincenters'}))=[];
        iconPathhead = [fileparts(which('headicon.gif')) '\headicon.gif'] ;
        iconPathnorm= [fileparts(which('headicon.gif')) '\greenarrowicon.gif'] ;
        iconPathheadarrow= [fileparts(which('headicon.gif')) '\headarrow.gif'] ;
        for j=1:length(methodvar)
            if sum(ismember({'Dtakens','lle','dimopt','firstmin','zstat','expo','rpde','Hx','AIS','det','lam','ratio','Qt','sig'},methodvar{j}))>0 & sum(ismember({'nta_wind_recfreq'},handles.results.methods(i).methodnames))==0 & sum(ismember({'nta_recfreq_en_scan'},handles.results.methods(i).methodnames))==0
            eval([handles.results.methods(i).methodnames '.add(uitreenode(''v0'', ''' methodvar{j} [''','''] methodvar{j} [''' ,'''  iconPathhead ''', true));']]);
            elseif sum(ismember({'SI','lAIS','lMI'},methodvar{j}))>0 | (sum(ismember({'rr','det','lam','ratio','rpde'},methodvar{j}))>0 & sum(ismember({'wind_recfreq'},handles.results.methods(i).methodnames))>0)
            eval([handles.results.methods(i).methodnames '.add(uitreenode(''v0'', ''' methodvar{j} [''','''] methodvar{j} [''' ,'''  iconPathheadarrow ''', true));']]);
            else
            eval([handles.results.methods(i).methodnames '.add(uitreenode(''v0'', ''' methodvar{j} [''','''] methodvar{j} [''' ,'''  iconPathnorm ''', true));']]);    
            end
        end        
        handles.methodIDs{i,1}=i;
        handles.methodIDs{i,2}=handles.results.methods(i).methodnames;
    end
end
% Create a uitree on a specified GUIDE figure
mtree = uitree('v0',handles.figure1, 'Root', root);
% Specify the size of a uitree handles
set(mtree,'pos',[841,479,135,120]);
% Save the handle "mtree" to global handle structure
handles.mtree = mtree;
end

