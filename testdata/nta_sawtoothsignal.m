for i=1:1000
    signalinf(i,1)=1/i;
    signalinf(i,2)=12*i;
    signalinf(i,3)=0;
end
    
    [ y ] = signalgen(signalinf,10,1000,0.3);
     
    