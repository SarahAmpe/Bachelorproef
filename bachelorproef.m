% testing van de wave functie:
plot(-2:0.01:2,wave(2,2*pi,-2:0.01:2))

% FMC invoerwaardes en testing
golfInfo = [2,2*pi,-2:0.01:2];
materialInfo = [3*10^6,2,2];
elementInfo = [4,1,2];

fmc = FMC(wavefInfo,materialInfo,elementInfo)