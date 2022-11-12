cfg.tau=0;
cfg.dim=4;
cfg.en=12;
cfg.waveform.mean=1;
cfg.avwavperiods=[25:40];
cfg.plt=0;
cfg.windowlength=1000;


for i=1:(length(x)/cfg.windowlength)*2-1
    [results]=recurrenceplot(x(((i-1)*(cfg.windowlength/2))+1:cfg.windowlength+(i-1)*(cfg.windowlength/2)),cfg);
    for j=1:length(cfg.avwavperiods)
    wav{j}(i,1:cfg.avwavperiods(1)+j)=(results.waveform.mean{1,cfg.avwavperiods(1)+j-1}-mean(results.waveform.mean{1,cfg.avwavperiods(1)+j-1}))./std(results.waveform.mean{1,cfg.avwavperiods(1)+j-1});
    end
end

for k=1:length(cfg.avwavperiods)
    avwav{k}=nanmean(wav{k});
    stdwav{k}=nanstd(wav{k});
end

plotwav=3;

figure(1)
plot(avwav{plotwav})
hold on
plot(avwav{plotwav}+stdwav{plotwav},'r');
plot(avwav{plotwav}-stdwav{plotwav},'r');


figure(2)
hold on
for i=1:size(wav{plotwav},1)
   plot(wav{plotwav}(i,:)) 
end
hold off

