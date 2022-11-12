% installation script for NoLiTiA Toolbox 
path_to_nolitia = erase(mfilename('fullpath'),mfilename);

if isempty(path_to_nolitia)
    error('No path found. "install_nolitia" needs to be run as a script.')
end

% getcurrentfolder=pwd;
addpath(genpath(path_to_nolitia));
savepath
hasSPT = license('test', 'signal_toolbox');
    if hasSPT==0
        warning('No Signal Processing Toolbox installed! Filtering will not be possible.')
    end
    if sum(computer('arch')=='win64')<5
        warning('No 64-bit Matlab installed! You should compile the neighsearch function!')
    end
    
disp('All paths set. Installation complete!')
clear

