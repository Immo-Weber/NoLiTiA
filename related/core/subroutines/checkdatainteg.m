function [data,nodata]=checkdatainteg(data,cfg,verbose)

if verbose==1
disp('Checking data integrity....')
end

if sum(isnan(data))>0
    if verbose==1
   warning('Nans detected! Removing....') 
    end
[row] = find(isnan(data));
data(row)=[];
end

nodata=0;
if isempty(data)
    warning('No data!')
    nodata=1;
    return
end

if ischar(data)
    warning('Data must be numeric!')
    nodata=1;
    return
end

if size(data,1)>size(data,2)
    if verbose==1
    disp('transposing data...')
    end
    data=data';
end

if verbose==1
disp('Check finished. Data OK!')
end
end