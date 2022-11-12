function [ handles ] = optimize_wrapper( handles )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
if isempty(handles.Data)==0
prompt = {'Optimization Mode:','Max Dimension:','Threshold Rtol:','Threshold Atol:','Threshold Minimum:','Number of Bins:','Range of Taus', 'Mass:','Prediction Horizon:','Mode:'};
title = 'Preprocessing Parameters';
dims = [1 35];
definput = {'deterministic','9','10','2','1','0','10:10:100','4','1','multi'};
answer = inputdlg(prompt,title,dims,definput);
cfg.optimization=answer{1};
cfg.dim=str2num(answer{2});

cfg.Rtol=str2num(answer{3});
cfg.Atol=str2num(answer{4});
cfg.thr=str2num(answer{5});
cfg.numbin=str2num(answer{6});
cfg.taus=str2num(answer{7});
cfg.mass=str2num(answer{8});
cfg.hor=str2num(answer{9});
cfg.mode=answer{10};
cfg.verbose=0;
h=waitbar(0,'Optimizing....');
for i=1:length(handles.Data)
[ optimize_batch{i} ]=batch_nolitia('nta_optimize_embedding',cfg,handles.Data{i});
for j=1:length(handles.Data{i})
temp=cell2mat(optimize_batch{i}{j});
handles.tau{i}(j,:)=[temp.opttau];
handles.dim{i}(j,:)=[temp.optdim];
end
waitbar(i/length(handles.Data),h)

end
close(h)
try
set(handles.Optimize,'BackgroundColor','green');
end
else
    msgbox('No data selected!','Error');
end

end

