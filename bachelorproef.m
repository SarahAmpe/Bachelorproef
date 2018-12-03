clear;
close all;
addpath('Hulpfuncties')
addpath('OrigineleFMCenPWI')
addpath('MultipleLayers')

%% FMC input (+ test wavefunctie)
% Parameters
t = linspace(-1e-5, 1e-5, 2048);
c = 7e6;
xref = 4;
zref = 4;
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
fmc = fmc + FMC(waveInfo,[c,-15,2],elementInfo);
fmc = fmc + FMC(waveInfo,[c,-10,5],elementInfo);
fmc = fmc + FMC(waveInfo,[c,0,3],elementInfo);
fmc = fmc + FMC(waveInfo,[c,15,7],elementInfo);


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
