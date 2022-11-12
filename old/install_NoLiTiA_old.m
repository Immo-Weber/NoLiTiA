getcurrentfolder=pwd;
addpath(genpath(getcurrentfolder));
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