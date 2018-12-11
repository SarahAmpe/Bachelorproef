clear;
close all;
addpath('Hulpfuncties')
addpath('OrigineleFMCenPWI')
addpath('MultipleLayers')

%% FMC multiple input (+ test wavefunctie)
t = linspace(-1e-5, 1e-5, 2^15); 
plot(t,wave(1,5e6,t));
c_a = 6.3e6; % Longitudinaal in aluminium
c_b = 1.5e6; % Sound velocity in water
c = [c_a c_b c_a];
xref = 3;
zref = 5.5;
z_in = [5,6];
numElements = 16;
elementWidth = 0.53;
pitch = 0.63;
waveInfo = [1, 5e6,t];
materialInfo = [xref,zref, z_in,c];
elementInfo = [numElements,elementWidth,pitch];

fmc = FMC_multiple(waveInfo,materialInfo,elementInfo);
fmc = fmc + FMC_multiple(waveInfo,[2,5.5, z_in,c],elementInfo);
fmc = fmc + FMC_multiple(waveInfo,[1,5.5, z_in,c],elementInfo);
fmc = fmc + FMC_multiple(waveInfo,[0,5.5, z_in,c],elementInfo);
fmc = fmc + FMC_multiple(waveInfo,[-1,5.5, z_in,c],elementInfo);
fmc = fmc + FMC_multiple(waveInfo,[-2,5.5, z_in,c],elementInfo);
fmc = fmc + FMC_multiple(waveInfo,[-3,5.5, z_in,c],elementInfo);

%% TFM testing (multiple layers)
% testparameters:
arraySetup = (-(numElements-1)*pitch/2:pitch:(numElements-1)*pitch/2);
aantalx = 256; % Nauwkeurigheid (aantal punten dat je wilt plotten)
aantalz = 256;
zmin = 0;
zmax = 6;
xmin = -(numElements-1)*pitch/2;
xmax = (numElements-1)*pitch/2;
z = linspace(zmin,zmax,aantalz);
x = linspace(xmin,xmax,aantalx);

% figuur
figure
I = tfm_multiple(fmc,t, x, z, z_in(1), [c_a,c_b], arraySetup);
imagesc(x,z,I)
colorbar
hold on
plot([xmin,xmax],[z_in(1),z_in(1)],'r','LineWidth',2)
plot([xmin,xmax],[z_in(2),z_in(2)],'r','LineWidth',2)
hold off


%% PWI testing (multiple layers)
% testparameters:
t = linspace(-1e-4, 1e-4, 2^15); 
c_a = 6.3e6; 
c_b = 1.5e6;
c = [c_a,c_b,c_a];
z_in = [5,6];
xref = 0;
zref = 5.5;
numElements = 16;
elementWidth = 0.53;
pitch = 0.63;
waveInfo = [1, 5e6,t];
materialInfo = [xref,zref,z_in,c];
elementInfo = [numElements,elementWidth,pitch,c];
arraySetup = (-(numElements-1)*pitch/2:pitch:(numElements-1)*pitch/2);

% FMC simulatie
[~,S] = FMC_multiple(waveInfo,materialInfo,elementInfo);
[~,S1] = FMC_multiple(waveInfo,[-3,zref,z_in,c],elementInfo);
S = S + S1;
[~,S1] = FMC_multiple(waveInfo,[ 3,zref,z_in,c],elementInfo);
S = S + S1;

% PWI simulatie
aantalx = 70;
aantalz = 55;
zmin = 4;
zmax = 7;
xmin = -(numElements-1)*pitch/2;
xmax = (numElements-1)*pitch/2;
z = linspace(zmin,zmax,aantalz);
x = linspace(xmin,xmax,aantalx);
thetamax = atan(zmin/arraySetup(end));
angles = linspace(-thetamax,thetamax,60);

pwi = PWI(t,S,angles,pitch,c(1));

% figuur
figure
I = PWI_image_multiple(pwi,t, x, z, z_in(1), c, arraySetup,angles);
imagesc(x,z,I/max(max(I)))
plotTitle = ['PWImultiple at position (', num2str(xref), ',' , num2str(zref), ')' ];
title(plotTitle)
xlabel('x-coordinate in mm')
ylabel('z-coordinate in mm')
cb = colorbar;
cb.Label.String = 'Intensity of the wave in the receiving transducers';
hold on
plot([xmin,xmax],[z_in(1),z_in(1)],'r','LineWidth',2)
plot([xmin,xmax],[z_in(2),z_in(2)],'r','LineWidth',2)
hold off
file = string(['PWImultiple_at_position_(', num2str(xref), ',' , num2str(zref), ').png' ]);
saveas(gcf, file)

