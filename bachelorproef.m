clear;
close all;
addpath('Hulpfuncties')
addpath('OrigineleFMCenPWI')
addpath('MultipleLayers')

%% FMC input (+ test wavefunctie)
% Parameters
t = linspace(-1.2e-5, 1.2e-5, 4096);
c = 7e6;
xref = 0;
zref = 3;
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
% fmc = fmc + FMC(waveInfo,[c,-17,2],elementInfo);
% fmc = fmc + FMC(waveInfo,[c,-17,3],elementInfo);
% fmc = fmc + FMC(waveInfo,[c,-17,4],elementInfo);
% fmc = fmc + FMC(waveInfo,[c,-17,5],elementInfo);
% fmc = fmc + FMC(waveInfo,[c,-13,4],elementInfo);
% fmc = fmc + FMC(waveInfo,[c,-13,3],elementInfo);
% fmc = fmc + FMC(waveInfo,[c,-7,3.5],elementInfo);
% fmc = fmc + FMC(waveInfo,[c,-4,2.7],elementInfo);
% fmc = fmc + FMC(waveInfo,[c,-4,4.2],elementInfo);
% fmc = fmc + FMC(waveInfo,[c,0,2],elementInfo);
% fmc = fmc + FMC(waveInfo,[c,0,5],elementInfo);
% fmc = fmc + FMC(waveInfo,[c,5,1.5],elementInfo);
% fmc = fmc + FMC(waveInfo,[c,5,5.5],elementInfo);
% fmc = fmc + FMC(waveInfo,[c,10,2],elementInfo);
% fmc = fmc + FMC(waveInfo,[c,10,5],elementInfo);
% fmc = fmc + FMC(waveInfo,[c,13,4],elementInfo);
% fmc = fmc + FMC(waveInfo,[c,13,3],elementInfo);
% fmc = fmc + FMC(waveInfo,[c,17,3.5],elementInfo);
% fmc = fmc + FMC(waveInfo,[c,12,4.8],elementInfo);

% pi-figuur
% fmc = fmc + FMC(waveInfo,[c,-15,4],elementInfo);
% fmc = fmc + FMC(waveInfo,[c,- 7,3],elementInfo);
% fmc = fmc + FMC(waveInfo,[c,  7,3],elementInfo);
% fmc = fmc + FMC(waveInfo,[c, 15,2],elementInfo);
% fmc = fmc + FMC(waveInfo,[c,- 5,4.5],elementInfo);
% fmc = fmc + FMC(waveInfo,[c,  5,4.5],elementInfo);
% fmc = fmc + FMC(waveInfo,[c,- 5,6],elementInfo);
% fmc = fmc + FMC(waveInfo,[c,  5,6],elementInfo);
% fmc = fmc + FMC(waveInfo,[c,-6,8],elementInfo);
% fmc = fmc + FMC(waveInfo,[c, 6,8],elementInfo);
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
figure
I = planeScan(fmc,t,x,z,D,c,arraySetup);
imagesc(x, z, I/max(max(I)))
plotTitle = ['PlaneBScan at position (', num2str(xref), ',' , num2str(zref), ')' ];
title(plotTitle)
xlabel('x-coordinate in mm')
ylabel('z-coordinate in mm')
cb = colorbar;
cb.Label.String = 'Intensity of the wave in the receiving transducers';
file = string(['PlaneBScan_at_position_(', num2str(xref), ',' , num2str(zref), ').png' ]);
saveas(gcf, file)

%% sectorScan testing
figure
I = sectorScan(fmc,t,x,z,c,arraySetup);
imagesc(x,z,I/max(max(I)))
plotTitle = ['SectorScan at position (', num2str(xref), ',' , num2str(zref), ')' ];
title(plotTitle)
xlabel('x-coordinate in mm')
ylabel('z-coordinate in mm')
cb = colorbar;
cb.Label.String = 'Intensity of the wave in the receiving transducers';
file = string(['SectorScan_at_position_(', num2str(xref), ',' , num2str(zref), ').png' ]);
saveas(gcf, file)

%% focusedScan testing
figure
I = focusedScan(fmc,t,x,z,D,c,arraySetup);
imagesc(x,z,I/max(max(I)))
plotTitle = ['FocusedScan at position (', num2str(xref), ',' , num2str(zref), ')' ];
title(plotTitle)
xlabel('x-coordinate in mm')
ylabel('z-coordinate in mm')
cb = colorbar;
cb.Label.String = 'Intensity of the wave in the receiving transducers';
file = string(['FocusedScan_at_position_(', num2str(xref), ',' , num2str(zref), ').png' ]);
saveas(gcf, file)

%% TFM testing
figure
I = tfm(fmc,t,x,z, c, arraySetup);
imagesc(x,z,I/max(max(I)))
plotTitle = ['TFM at position (', num2str(xref), ',' , num2str(zref), ')' ];
title(plotTitle)
xlabel('x-coordinate in mm')
ylabel('z-coordinate in mm')
cb = colorbar;
cb.Label.String = 'Intensity of the wave in the receiving transducers';
file = string(['TFM_at_position_(', num2str(xref), ',' , num2str(zref), ').png' ]);
saveas(gcf, file)

%% PWI testing (single layer)
% testparameters:
t = linspace(-1e-4, 1e-4, 2^14); 
c = 6.3e6;
xref = -3;
zref = 15;
numElements = 64;
elementWidth = 0.53;
pitch = 0.63;
waveInfo = [1, 5e6,t]; %gaussian window best op 1000
elementInfo = [numElements,elementWidth,pitch];
arraySetup = (-(numElements-1)*pitch/2:pitch:(numElements-1)*pitch/2);

% FMC simulatie
[~,S] = FMC(waveInfo,[c,xref,zref],elementInfo);
[~,S1] = FMC(waveInfo,[c,-2,15],elementInfo);
S = S + S1;
[~,S1] = FMC(waveInfo,[c,-1,15],elementInfo);
S = S + S1;
[~,S1] = FMC(waveInfo,[c, 0,15],elementInfo);
S = S + S1;
[~,S1] = FMC(waveInfo,[c, 1,15],elementInfo);
S = S + S1;
[~,S1] = FMC(waveInfo,[c, 2,15],elementInfo);
S = S + S1;
[~,S1] = FMC(waveInfo,[c, 3,15],elementInfo);
S = S + S1;

% PWI simulatie
angles = linspace(-pi/3,pi/3,120);
aantalx = 64;
aantalz = 64;
zmin = arraySetup(end)/tan(angles(end));
zmax = 20;
xmin = -(numElements-1)*pitch/2;
xmax = (numElements-1)*pitch/2;
z = linspace(zmin,zmax,aantalz);
x = linspace(xmin,xmax,aantalx);

pwi = PWI(t,S,angles,pitch,c);

% figuur
figure
I = PWI_image(pwi,t, x, z, c, arraySetup,angles);
imagesc(x,z,I/max(max(I)))
plotTitle = ['PWIsingle at position (', num2str(xref), ',' , num2str(zref), ')' ];
title(plotTitle)
xlabel('x-coordinate in mm')
ylabel('z-coordinate in mm')
cb = colorbar;
cb.Label.String = 'Intensity of the wave in the receiving transducers';
file = string(['PWIsingle_at_position_(', num2str(xref), ',' , num2str(zref), ').png' ]);
saveas(gcf, file)
