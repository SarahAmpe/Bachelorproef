clear;
close all;
% addpath('0. Hulpfuncties')
% addpath('1. Originele FMC en PWI')
% addpath('2. Project lijm')

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
numElements = 64;
elementWidth = 0.53;
pitch = 0.63;
waveInfo = [1, 5e6,t];
materialInfo = [xref,zref, z_in,c];
elementInfo = [numElements,elementWidth,pitch];

[fmc,~] = FMC_multiple(waveInfo,materialInfo,elementInfo);

%% Algemene testparameters
% Invoerwaarden
aantalx = 20; % Nauwkeurigheid (aantal punten dat je wilt plotten)
aantalz = 20;
zmin = 0.05;
zmax = 8;

% Andere nodige waarden
xmin = -(numElements-1)*pitch/2;
xmax = (numElements-1)*pitch/2;
stepx = (numElements-1)*pitch/aantalx;
stepz = (zmax-zmin)/aantalz;
z = zmin:stepz:zmax;
x = xmin:stepx:xmax;
arraySetup = (-(numElements-1)*pitch/2:pitch:(numElements-1)*pitch/2);


%% TFM testing (multiple layers)
I = zeros(aantalz, aantalx);
for m = 1:aantalx
    for n = 1:aantalz
        I(n,m) = tfm_multiple(fmc,t, x(m), z(n), z_in, c_a, c_b, arraySetup);
    end
end
imagesc(xmin:stepx:xmax,zmin:stepz:zmax,I)
colorbar
hold on
plot([xmin,xmax],[z_in,z_in],'r','LineWidth',2)
hold off

%% PWI testing (multiple layers)
angles = linspace(-60,60,120);
pwi = PWI(t,S,angles,pitch,c);

I = PWI_image(pwi,t, x, z, z_in, c_a, c_b, arraySetup,angles);
imagesc(x,z,I)
colorbar
hold on
plot([xmin,xmax],[z_in,z_in],'r','LineWidth',2)
hold off
