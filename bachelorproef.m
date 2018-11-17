%% testing van de wave functie:
t = 0.01:0.01:8;
plot(t,wave(2,4*pi,t));

%% FMC invoerwaardes en testing
c = 200;
xref = 0;
zref = 3;
numElements = 20;
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
imagesc((0:(numElements-1)) - (numElements-1)*elementWidth/2,0:(numElements-1),I)
colorbar
%% planeScan testing
x = xref;
z = zref;

I = planeScan(fmc, x, z,D , c, arrSetup)



