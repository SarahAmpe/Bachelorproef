function result = simulateTFM(A, f, t, cMaterial, xref, zref, elementInfo, x, z)
sample = wave(A,f,t);
waveInfo = [A, f, sample];
materialInfo = [cMaterial, xref, zref];
fmc,s = FMC(waveInfo, materialInfo, elementInfo);


tada = tfm(fmc, x, z, elementInfo);


