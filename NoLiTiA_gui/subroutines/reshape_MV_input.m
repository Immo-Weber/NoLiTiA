function [ data1,data2 ] = reshape_MV_input(handles)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
multivariate=0;
data1=cell(1,length(handles.Data));
data2=cell(1,length(handles.Data));
for qq=1:length(handles.methodnames)
    multivariate=multivariate+sum(strcmp(handles.methodnames{qq},{'nta_crossrecurrenceplot';'nta_jointrecurrenceplot';'nta_MIbin';'nta_MIkraskov'}));
end
if multivariate>0
    for qq=1:length(handles.Data)
        data1{qq}=handles.Data{qq}(:,1);
        data2{qq}=handles.Data{qq}(:,2);
    end
end

end

