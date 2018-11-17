%% testing van de wave functie:
t = 0.01:0.005:4;
plot(t,wave(2,4*pi,t));

%% FMC invoerwaardes en testing
c = 200;
xref = 3;
zref = 10;
numElements = 20;
elementWidth = 1;
pitch = 1.5;
waveInfo = [2,2*pi,t];
materialInfo = [c,xref,zref];
elementInfo = [numElements,elementWidth,pitch];

[fmc,S] = FMC(waveInfo,materialInfo,elementInfo);

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



