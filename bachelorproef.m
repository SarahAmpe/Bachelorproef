% testing van de wave functie:
t = -2:0.01:2;
plot(t,wave(2,4*pi,t));

% FMC invoerwaardes en testing
waveInfo = [2,2*pi,-2:0.01:2];
materialInfo = [3*10^6,2,2];
elementInfo = [4,1,2];

[fmc,S] = FMC(waveInfo,materialInfo,elementInfo);