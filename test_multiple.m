clear;
close all;
addpath('Hulpfuncties')
addpath('OrigineleFMCenPWI')
addpath('MultipleLayers')

%% FMC multiple input (+ test wavefunctie)
t = linspace(-1e-5, 1e-5, 2048); 
plot(t,wave(1,5e6,t));
c_a = 6.3e6; % Longitudinaal in aluminium
c_b = 1.5e6; % Sound velocity in water
c_c = 3.1e6; % Transversaal in aluminium
c = [c_a c_b c_b c_c];
xref = -3;
zref = 5.5;
z_in = 5;
numElements = 32;
elementWidth = 0.53;
pitch = 0.63;
waveInfo = [1, 5e6,t];
materialInfo = [xref,zref, z_in,c];
elementInfo = [numElements,elementWidth,pitch];

[fmc,~] = FMC_multiple(waveInfo,materialInfo,elementInfo);

%% Algemene testparameters
arraySetup = (-(numElements-1)*pitch/2:pitch:(numElements-1)*pitch/2);
% Invoerwaarden
aantalx = 10; % Nauwkeurigheid (aantal punten dat je wilt plotten)
aantalz = 10;
zmin = arraySetup(end)/tan(pi/3);
zmax = 15;

% Andere nodige waarden
xmin = -(numElements-1)*pitch/2;
xmax = (numElements-1)*pitch/2;
z = linspace(zmin,zmax,aantalz);
x = linspace(xmin,xmax,aantalx);



%% TFM testing (multiple layers)
% testparameters:
arraySetup = (-(numElements-1)*pitch/2:pitch:(numElements-1)*pitch/2);
aantalx = 10; % Nauwkeurigheid (aantal punten dat je wilt plotten)
aantalz = 10;
zmin = 0.05;
zmax = 15;
xmin = -(numElements-1)*pitch/2;
xmax = (numElements-1)*pitch/2;
z = linspace(zmin,zmax,aantalz);
x = linspace(xmin,xmax,aantalx);

% figuur
figure
I = tfm_multiple(fmc,t, x, z, z_in, [c_a,c_b], arraySetup);
imagesc(x,z,I)
colorbar
hold on
plot([xmin,xmax],[z_in,z_in],'r','LineWidth',2)
hold off

%% PWI testing (single layer)
% testparameters:
t = linspace(-1e-4, 1e-4, 2048); 
c = 6.3e6;
xref = 5;
zref = 12;
numElements = 64;
elementWidth = 0.53;
pitch = 0.63;
waveInfo = [1, 5e6,t]; %gaussian window best op 1000
materialInfo = [c,xref,zref];
elementInfo = [numElements,elementWidth,pitch];
arraySetup = (-(numElements-1)*pitch/2:pitch:(numElements-1)*pitch/2);

% FMC simulatie
[~,S] = FMC(waveInfo,materialInfo,elementInfo);

% PWI simulatie
angles = linspace(-pi/3,pi/3,120);
aantalx = 20;
aantalz = 20;
zmin = arraySetup(end)/tan(angles(end));
zmax = 15;
xmin = -(numElements-1)*pitch/2;
xmax = (numElements-1)*pitch/2;
z = linspace(zmin,zmax,aantalz);
x = linspace(xmin,xmax,aantalx);

pwi = PWI(t,S,angles,pitch,c);

% figuur
figure
I = PWI_image(pwi,t, x, z, c, arraySetup,angles);
imagesc(x,z,I/max(max(I)))
colorbar
