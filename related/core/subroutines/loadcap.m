function [cap]=loadcap(cfg)
%cfg.capfile='\\dfs.hrz.uni-marburg.de\PROJEKTE\FB20\NEUROLOGIE_FORSCHUNG\AG Clinical Systems Neuroscience\PIs\Immo und Carina\Immo\Studien\TP1\tp1peri\siewal\TP1_SieWal_peri_OFF_HC.sfp';
fileID = fopen(cfg.capfile);
cap = textscan(fileID,'%s %f64 %f64 %f64');
fclose(fileID);
