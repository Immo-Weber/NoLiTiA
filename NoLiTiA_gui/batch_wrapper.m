function [ handles ] = batch_wrapper( handles )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
if isfield(handles,'cfg')==1
% [ data1,data2 ] = reshape_MV_input(handles);
h = waitbar(0,'Overall Batch Job Processing...');
steps=length(handles.methodnames);
ldata=length(handles.Data);
totalsteps=steps*ldata;
counter=1;
for i=1:steps
    
    for j=1:ldata
        [ results_batch{j} ] = batch_nolitia(handles.methodnames{i},handles.cfg{i}{j},handles.Data{j});
        handles.results(j).methods(i).results=results_batch{j};
        handles.results(j).methods(i).methodnames=handles.methodnames{i};
        try
            handles.results(j).files=handles.Datanames(j);
            handles.results(j).variable=handles.reg(2:end);
        end
        waitbar(counter/totalsteps)
        counter=counter+1;
    end
    
    
    
end
close(h)
try
set(handles.Calculate,'BackgroundColor','green');
end
msgbox('Batch complete!','Success');
else
    msgbox('No parameters defined!','Error');
end

end

