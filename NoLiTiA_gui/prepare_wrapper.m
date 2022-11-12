function [ handles ] = prepare_wrapper( handles )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
if isempty(handles.Data)==0 
prompt = {'Time of interest:','Channels?:','Normalize?:','Detrend?:','Filter?','Lowpass-Freq.:','Highpass-Freq.:','Causal Filter?:','Sampling-Freq:'};
title = 'Preprocessing Parameters';
dims = [1 35];
definput = {'1:1000','1','1','1','0','0','0','1','1000'};
answer = inputdlg(prompt,title,dims,definput);
cfg.toi=str2num(answer{1});
cfg.channels=str2num(answer{2});
cfg.normalize=str2num(answer{3});
cfg.detrend=str2num(answer{4});
cfg.filter=str2num(answer{5});
cfg.lpfreq=str2num(answer{6});
cfg.hpfreq=str2num(answer{7});
cfg.causal=str2num(answer{8});
cfg.fs=str2num(answer{9});

for i=1:size(handles.Data,2)
    for trials=1:size(handles.Data{i},2)
    for channels=1:length(cfg.channels)
[ prep_data{i}{trials}(channels,:) ] = nta_prepare_data(handles.Data{i}{trials}(cfg.channels(channels),:),cfg );
    end
    end
end
% else
%  for i=1:size(handles.Data{1},2)
% [ prep_data_temp{i} ] = prepare_data(handles.Data{1}(:,i),cfg )
%  end
%  prep_data{1}=cell2mat(prep_data_temp);

handles.Data=prep_data;
try
set(handles.prepare,'BackgroundColor','green');
end
for i=1:length(handles.Data)
handles.results(i).prepare=cfg;
end
else
 msgbox('No data selected!','Error'); 
end

end

