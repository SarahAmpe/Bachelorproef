function result = simulateTFM(A, f, t, cMaterial, xref, zref, elementInfo)
waveInfo = [A, f, t];
materialInfo = [cMaterial, xref, zref];
fmc,s = FMC(waveInfo, materialInfo, elementInfo);


tada = tfm(fmc, xref, zref, elementInfo);


