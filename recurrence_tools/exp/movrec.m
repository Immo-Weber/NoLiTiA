function [rdvec,rpdevec,zvec]=movrec(data,dim,tau,br,fs,print,wind1,nei,vers,ampl)

%Erstellt "Recurrence-Zeit-Frequenz-Spektrum" basierend auf Recurrence-Plot
%data: Datensatz, Vek
%dim: Dimensionen für Phasenraumrekonstruktion, Int
%br: max. Frequenz, Int
%fs: Samplingfrequenz, Int
%print: 0
%wind1: Fensterbreite in samples, Int
%nei: Neighbourhood-Size in Prozent vom Maximaldurchmesser des Attraktors im Phasenraums, Int
%vers: Überlappung der Fenster in Samples, Int

if tau==0
    [ ~,timeneigh2,lagges ] = timenei( data,dim,tau,wind1,fs,1)
%     pause
end

zvec=zeros(br,1);
zvec2=zeros(br,1);
for i=0:((length(data)-vers)/wind1)-1
    if tau==0
        lag=lagges(i+1);
        nei=timeneigh2(i+1);
    else lag=tau;
    end
    [rd,~,~,rpde,z,y]=recurrenceplot3(data((i*wind1)+1:(i+1)*wind1),dim,lag,br,fs,nei,0,2);
    rdvec(i*wind1+1:(i+1)*wind1)=rd;
    rpdevec(i*wind1+1:(i+1)*wind1)=rpde;
    if ampl==1
        zvec=horzcat(zvec,z);
    else
        zvec=horzcat(zvec,y);
    end
end
%%
if vers~=0
    [ ~,timeneigh2,lagges ] = timenei( data(vers+1:end),dim,tau,wind1,fs,1)
%     pause
h = waitbar(0,'Please wait...');
steps =((length(data)-vers)/wind1) ;
    for i=0:((length(data)-vers)/wind1)-1
        if tau==0
            lag=lagges(i+1);
            nei=timeneigh2(i+1);
        else lag=tau;
        end
        [rd,~,~,rpde,z,y]=recurrenceplot3(data((i*wind1)+vers+1:((i+1)*wind1)+vers),dim,lag,br,fs,nei,0,2);
        rdvec2(i*wind1+1:(i+1)*wind1)=rd;
        rpdevec2(i*wind1+1:(i+1)*wind1)=rpde;
        if ampl==1
            zvec2=horzcat(zvec2,z);
        else
            zvec2=horzcat(zvec2,y);
        end
        waitbar((i+1/steps))
    end
    close(h)
    zvec2=zvec2(:,2:end);
    tempmax2=max(zvec2);
    zvec2=zvec2./max(tempmax2);
    % zvec2=zvec2./sum(sum(zvec2));
end


zvec=zvec(:,2:end);
tempmax=max(zvec);
zvec=zvec./max(tempmax); %unkommentieren
% zvec=zvec./sum(sum(zvec));

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

tempmax=max(zvec);
zvec=zvec./max(tempmax);   %unkommentieren
%zvec=zvec./sum(sum(zvec));
%%
if print==1
    subplot(4,2,1:2)
    surf(1:length(zvec),1:br,10.*log10(zvec),'edgecolor','none')
    %xlabel('Time [samples]')
    ylabel('Frequency [Hz]')
    axis1 = 0;
    axis2 = 90;
    view(axis1, axis2);
%     q=colorbar
    %set(q,'YScale',[0:0.01:1]);
    subplot(4,2,5:6)
    plot(rdvec)
    title('Recurrence Rate')
    grid on
    subplot(4,2,7:8)
    plot(rpdevec)
    title('Recurrence Period Density Entropy')
    grid on
    subplot(4,2,3:4)
    plot(data)
    title('Timeseries')
    grid on
    h=uicontrol('Style', 'slider','Min',0,'Max',1,'Value',1,'Position', [400 20 120 20],'Callback', @caxismov);
end
end



function caxismov(h, eventdata, handles)
slider_value = get(h,'Value');
caxis([0 slider_value])
end