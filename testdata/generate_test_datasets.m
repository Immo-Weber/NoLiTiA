numsubjects=10;
numtrials=20;
numvar=1;
datalength=2000;

meandata=0;
stddata=10;

home= what('NoliTiA_v1.2');
currentdir=pwd;

for subject=1:numsubjects 
for trials=1:numtrials
    [ sig ] = nta_signalgen([1 20 0],1,1000,0);
   data.trial{trials}=[stddata*randn(numvar,datalength)+meandata (sig(1:1000))']; 
   save([home.path '\testdata\temp\subj_rand' num2str(subject) '.mat'], 'data');
end
end

for subject=1:numsubjects 
for trials=1:numtrials
   [x,y,z]=nta_lorenzgen([0:0.1:300]); 
   data.trial{trials}(1,:)=(x(1:3000))';
   data.trial{trials}(2,:)=(y(1:3000))';
   save([home.path '\testdata\temp\subj_lor' num2str(subject) '.mat'], 'data');
end
end