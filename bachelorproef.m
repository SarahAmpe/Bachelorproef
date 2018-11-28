clear;
close all;
% addpath('0. Hulpfuncties')
% addpath('1. Originele FMC en PWI')
% addpath('2. Project lijm')

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
plot(t,wave(2,5e6,t));
waveInfo = [1, 5e6,t];
materialInfo = [c,xref,zref];
elementInfo = [numElements,elementWidth,pitch];
[fmc,S] = FMC(waveInfo,materialInfo,elementInfo);

% Extra defecten toevoegen
% fmc = fmc + FMC(waveInfo,[c,-15,2],elementInfo);
% fmc = fmc + FMC(waveInfo,[c,-10,5],elementInfo);
% fmc = fmc + FMC(waveInfo,[c,0,3],elementInfo);
% fmc = fmc + FMC(waveInfo,[c,15,7],elementInfo);


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
stepx = (numElements-1)*pitch/aantalx;
stepz = (zmax-zmin)/aantalz;
z = zmin:stepz:zmax;
x = xmin:stepx:xmax;


%% planeScan testing
I = planeScan(fmc,t,x,z,D,c,arraySetup);
imagesc(xmin:stepx:xmax, (zmin:stepz:zmax), I)
colorbar

%% sectorScan testing
I = sectorScan(fmc,t,x,z,c,arraySetup);
imagesc(x,z,I)
colorbar

%% focusedScan testing
I = focusedScan(fmc,t,x,z,D,c,arraySetup);
imagesc(x,z,I)
colorbar

%% TFM testing
I = tfm(fmc,t,x,z, c, arraySetup);
imagesc(x,z,I)
colorbar
