function [data1,data2] = fetch_data(cfg,varargin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
cfg=[];
if length(varargin)==2
for i=1:length(varargin{1}.results)
%     load(['data_orig_' num2str(i) '_NoLiTiA_results.mat'])
    data1{i}=varargin{1}.results(i);
%     load(['data_surr_' num2str(i) '_NoLiTiA_results.mat'])
    data2{i}=varargin{2}.results(i);
end
end

