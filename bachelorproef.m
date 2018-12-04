clear;
close all;
addpath('Hulpfuncties')
addpath('OrigineleFMCenPWI')
addpath('MultipleLayers')

%% FMC input (+ test wavefunctie)
% Parameters
t = linspace(-1.2e-5, 1.2e-5, 4096);
c = 7e6;
xref = 12;
zref = 2.3;
numElements = 64;
elementWidth = 0.53;
pitch = 0.63;

% Waveplot en full matrix berekenen
plot(t,wave(1,5e6,t));
waveInfo = [1, 5e6,t];
materialInfo = [c,xref,zref];
elementInfo = [numElements,elementWidth,pitch];
[fmc,~] = FMC(waveInfo,materialInfo,elementInfo);

% Extra defecten toevoegen
fmc = fmc + FMC(waveInfo,[c,-17,2],elementInfo);
fmc = fmc + FMC(waveInfo,[c,-17,3],elementInfo);
fmc = fmc + FMC(waveInfo,[c,-17,4],elementInfo);
fmc = fmc + FMC(waveInfo,[c,-17,5],elementInfo);
fmc = fmc + FMC(waveInfo,[c,-13,4],elementInfo);
fmc = fmc + FMC(waveInfo,[c,-13,3],elementInfo);
fmc = fmc + FMC(waveInfo,[c,-7,3.5],elementInfo);
fmc = fmc + FMC(waveInfo,[c,-4,2.7],elementInfo);
fmc = fmc + FMC(waveInfo,[c,-4,4.2],elementInfo);
fmc = fmc + FMC(waveInfo,[c,0,2],elementInfo);
fmc = fmc + FMC(waveInfo,[c,0,5],elementInfo);
fmc = fmc + FMC(waveInfo,[c,5,1.5],elementInfo);
fmc = fmc + FMC(waveInfo,[c,5,5.5],elementInfo);
fmc = fmc + FMC(waveInfo,[c,10,2],elementInfo);
fmc = fmc + FMC(waveInfo,[c,10,5],elementInfo);
fmc = fmc + FMC(waveInfo,[c,13,4],elementInfo);
fmc = fmc + FMC(waveInfo,[c,13,3],elementInfo);
fmc = fmc + FMC(waveInfo,[c,17,3.5],elementInfo);
fmc = fmc + FMC(waveInfo,[c,12,4.8],elementInfo);

%% Algemene testparameters
% Invoerwaarden
D = 5*pitch; % Aperture width
aantalx = 64; % Nauwkeurigheid (aantal punten dat je wilt plotten)
aantalz = 64;
zmin = 0.01; % Testgrenzen voor z
zmax = 10;

% Andere nodige waarden
xmin = -(numElements-1)*pitch/2;
xmax = (numElements-1)*pitch/2;
arraySetup = (-(numElements-1)*pitch/2:pitch:(numElements-1)*pitch/2);
z = linspace(zmin,zmax,aantalz);
x = linspace(xmin,xmax,aantalx);


%% planeScan testing
I = planeScan(fmc,t,x,z,D,c,arraySetup);
imagesc(x, z, I)
plotTitle = ['PlaneBScan at position (', num2str(xref), ',' , num2str(zref), ')' ];
title(plotTitle)
xlabel('x-coordinate in mm')
ylabel('z-coordinate in mm')
cb = colorbar;
cb.Label.String = 'Intensity of the wave in the receiving transducers';
file = string(['PlaneBScan_at_position_(', num2str(xref), ',' , num2str(zref), ').png' ]);
saveas(gcf, file)

%% sectorScan testing
I = sectorScan(fmc,t,x,z,c,arraySetup);
imagesc(x,z,I)
plotTitle = ['SectorScan at position (', num2str(xref), ',' , num2str(zref), ')' ];
title(plotTitle)
xlabel('x-coordinate in mm')
ylabel('z-coordinate in mm')
cb = colorbar;
cb.Label.String = 'Intensity of the wave in the receiving transducers';
file = string(['SectorScan_at_position_(', num2str(xref), ',' , num2str(zref), ').png' ]);
saveas(gcf, file)

%% focusedScan testing
I = focusedScan(fmc,t,x,z,D,c,arraySetup);
imagesc(x,z,I)
plotTitle = ['FocusedScan at position (', num2str(xref), ',' , num2str(zref), ')' ];
title(plotTitle)
xlabel('x-coordinate in mm')
ylabel('z-coordinate in mm')
cb = colorbar;
cb.Label.String = 'Intensity of the wave in the receiving transducers';
file = string(['FocusedScan_at_position_(', num2str(xref), ',' , num2str(zref), ').png' ]);
saveas(gcf, file)

%% TFM testing
I = tfm(fmc,t,x,z, c, arraySetup);
imagesc(x,z,I)
plotTitle = ['TFM at position (', num2str(xref), ',' , num2str(zref), ')' ];
title(plotTitle)
xlabel('x-coordinate in mm')
ylabel('z-coordinate in mm')
cb = colorbar;
cb.Label.String = 'Intensity of the wave in the receiving transducers';
file = string(['TFM_at_position_(', num2str(xref), ',' , num2str(zref), ').png' ]);
saveas(gcf, file)
