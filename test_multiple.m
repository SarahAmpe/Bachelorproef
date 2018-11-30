clear;
close all;
% addpath('0. Hulpfuncties')
% addpath('1. Originele FMC en PWI')
% addpath('2. Project lijm')

%% FMC multiple input (+ test wavefunctie)
t = linspace(-1e-5, 1e-5, 2048); % niet aanpassen! tfm is hiervan afhankelijk
plot(t,wave(1,5e6,t));
c_a = 7e6;
c_b = 5e6;
c = [c_a c_b c_b c_a];
xref = -3;
zref = 5.5;
z_in = 5;
numElements = 64;
elementWidth = 0.53;
pitch = 0.63;
waveInfo = [1, 5e6,t];
materialInfo = [xref,zref, z_in,c];
elementInfo = [numElements,elementWidth,pitch];

[fmc,S] = FMC_multiple(waveInfo,materialInfo,elementInfo);

%% Algemene testparameters
% Invoerwaarden
aantalx = 64; % Nauwkeurigheid (aantal punten dat je wilt plotten)
aantalz = 64;
zmin = 0; % Testgrenzen voor z
zmax = 10;

% Andere nodige waarden
xmin = -(numElements-1)*pitch/2;
xmax = (numElements-1)*pitch/2;
arraySetup = (-(numElements-1)*pitch/2:pitch:(numElements-1)*pitch/2);
stepx = (numElements-1)*pitch/aantalx;
stepz = (zmax-zmin)/aantalz;
z = zmin:stepz:zmax;
x = xmin:stepx:xmax;

%% TFM multiple testing
I = zeros(20);
arraySetup = (-(numElements-1)*pitch/2:pitch:(numElements-1)*pitch/2);
aantalx= 20;% nauwkeurigheid (aantal punten dat je wilt plotten)
aantalz= 20;
xmin = -(numElements-1)*pitch/2;
xmax = (numElements-1)*pitch/2;
zmin = 0.05;
zmax = 8;
stepx = (numElements-1)*pitch/aantalx;
stepz = (zmax-zmin)/aantalz;
for m = 1:aantalx+1
    for n = 1:aantalz+1
        x = xmin + (m-1)*stepx;
        z = zmin + (n-1)*stepz;
        I(n,m) = tfm_multiple(fmc,t, x, z, z_in, c_a, c_b, arraySetup);
    end
end
imagesc(xmin:stepx:xmax,zmin:stepz:zmax,I)
colorbar
hold on
plot([xmin,xmax],[z_in,z_in],'r','LineWidth',2)
hold off

%% PWI simulation en testing
angles = linspace(-60,60,120);
pwi = PWI(t,S,angles,pitch,c);
I = PWI_image(pwi,t, x, z, z_in, c_a, c_b, arraySetup,angles);
imagesc(xmin:stepx:xmax,zmin:stepz:zmax,I)
colorbar
hold on
plot([xmin,xmax],[z_in,z_in],'r','LineWidth',2)
hold off