function [rdvec,rpdevec,zvec]=movreccoup(data1,data2,dim1,dim2,br,fs1,fs2,print,wind1,nei1,nei2,vers)

zvec=zeros(br,1);
zvec2=zeros(br,1);
for i=0:((length(data1)-vers)/wind1)-1
    [rd,rpde,z]=jointrecurrence2(data1((i*wind1)+1:(i+1)*wind1),dim1,fs1,nei1,data2((i*wind1)+1:(i+1)*wind1),dim2,fs2,nei2,br,2);
    rdvec(i*wind1+1:(i+1)*wind1)=rd;
    rpdevec(i*wind1+1:(i+1)*wind1)=rpde;
    z(isnan(z))=0;
    zvec=horzcat(zvec,z);
end
%% 
if vers~=0
 for i=0:((length(data1)-vers)/wind1)-1
     [rd,rpde,z]=jointrecurrence2(data1((i*wind1)+vers+1:((i+1)*wind1)+vers),dim1,fs1,nei1,data2((i*wind1)+vers+1:((i+1)*wind1)+vers),dim2,fs2,nei2,br,2);
     rdvec2(i*wind1+1:(i+1)*wind1)=rd;
     rpdevec2(i*wind1+1:(i+1)*wind1)=rpde;
     z(isnan(z))=0;
     zvec2=horzcat(zvec2,z);
 end
zvec2=zvec2(:,2:end);
%  tempmax2=max(zvec2);
%  zvec2=zvec2./max(tempmax2);
 zvec2=zvec2./sum(sum(zvec2));
end

 
zvec=zvec(:,2:end);
%  tempmax=max(zvec);
%  zvec=zvec./max(tempmax);
 zvec=zvec./sum(sum(zvec));

if vers~=0
tempvec=zeros(br,vers+length(zvec));
tempvec(:,1:vers)=zvec(:,1:vers);
tempvec(:,end-vers:end)=zvec2(:,end-vers:end);
tempvec(:,vers+1:end-vers)=((zvec(:,vers+1:end)+zvec2(:,1:end-vers)))./2;
zvec=tempvec;
 temprdvec=zeros(1,vers+length(rdvec));
 temprdvec(:,1:vers)=rdvec(1,1:vers);
 temprdvec(:,end-vers:end)=rdvec2(:,end-vers:end);
 temprdvec(:,vers+1:end-vers)=((rdvec(:,vers+1:end)+rdvec2(:,1:end-vers)))./2;
 rdvec=temprdvec;
 
 temprpdevec=zeros(1,vers+length(rpdevec));
 temprpdevec(:,1:vers)=rpdevec(:,1:vers);
 temprpdevec(:,end-vers:end)=rpdevec2(:,end-vers:end);
 temprpdevec(:,vers+1:end-vers)=((rpdevec(:,vers+1:end)+rpdevec2(:,1:end-vers)))./2;
 rpdevec=temprpdevec;

end

%  tempmax=max(zvec);
%  zvec=zvec./max(tempmax);
zvec=zvec./sum(sum(zvec));

subplot(5,2,1:2)
surf(1:length(zvec),1:br,zvec,'edgecolor','none')
%xlabel('Time [samples]')
ylabel('Frequency [Hz]')
 bla = 0;
 bla2 = 90;
 view(bla, bla2);
colorbar
subplot(5,2,7:8)
plot(rdvec)
title('Recurrence Density')
subplot(5,2,9:10)
plot(rpdevec)
title('Recurrence Period Density Entropy')
subplot(5,2,3:4)
plot(data1)
title('Timeseries1')
subplot(5,2,5:6)
plot(data2)
title('Timeseries2')
h=uicontrol('Style', 'slider','Min',0.1,'Max',1,'Value',1,'Position', [400 20 120 20],'Callback', @caxismov)
end

%% 

function caxismov(h, eventdata, handles)
     slider_value = get(h,'Value');
     caxis([0.1 slider_value])
 end