% testing van de wave functie:
t = 0.01:0.01:4;
plot(t,wave(2,4*pi,t));

% FMC invoerwaardes en testing
c = 3*10^6;
waveInfo = [2,2*pi,0.01:0.01:4];
materialInfo = [c,2,2];
elementInfo = [4,1,2];

[fmc,S,F,d,pr,pt,A] = FMC(waveInfo,materialInfo,elementInfo);
array = [-2, -1, 0, 1];
I = tfm(fmc, 1, 2, c, array);


