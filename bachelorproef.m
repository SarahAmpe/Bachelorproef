%% testing van de wave functie:
t = 0.01:0.01:4;
plot(t,wave(2,4*pi,t));

%% FMC invoerwaardes en testing
t = 0.01:0.01:4;
c = 3*10^6;
xref = 2;
zref = 2;
numElements = 4;
elementWidth = 1;
pitch = 2;
waveInfo = [2,2*pi,t];
materialInfo = [c,xref,zref];
elementInfo = [numElements,elementWidth,pitch];

[fmc,S,F,d,pr,pt,A] = FMC(waveInfo,materialInfo,elementInfo);

%% TFM testing
arraySetup = (0:(numElements-1)) - (numElements-1)*elementWidth/2;
for m = 1:numElements
    for n = 1:numElements
        x = (m-1)- (numElements-1)*elementWidth/2;
        z = (n-1);
        I(n,m) = tfm(fmc,t, x, z, c, arraySetup);
    end
end
imagesc(I)
%% planeScan testing
x = xref;
z = zref;

I = planeScan(fmc, x, z,D , c, arrSetup)



