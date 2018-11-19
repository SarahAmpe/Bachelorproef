%% testing van de wave functie:
t = 0.01:0.00125:1;
plot(t,wave(2,4*pi,t));

%% FMC invoerwaardes en testing
c = 200;
xref = 0;
zref = 5;
numElements = 20;
elementWidth = 1;
pitch = 1.5;
waveInfo = [2,2*pi,t];
materialInfo = [c,xref,zref];
elementInfo = [numElements,elementWidth,pitch];

[fmc,S] = FMC(waveInfo,materialInfo,elementInfo);

%% TFM testing
I = zeros(20);
arraySetup = (0:(numElements-1)) - (numElements-1)*elementWidth/2;
step_x = 0;
step_z = 0;
for m = -10:10
    step_x = step_x +1;
    step_z = 0;
    for n = 0:0.5:10
        step_z = step_z + 1;
        x = m;
        z = n/2;
        I(step_z, step_x) = tfm(fmc,t, x, z, c, arraySetup);
    end
end
imagesc(-10:10,0:0.5:10,I)
colorbar
% %% planeScan testing
% x = xref;
% z = zref;
% 
% I = planeScan(fmc, x, z,D , c, arrSetup)