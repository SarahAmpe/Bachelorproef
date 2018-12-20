clear
close all
addpath('Hulpfuncties')
addpath('OrigineleFMCenPWI')
addpath('MultipleLayers')

%% FMC en post-processing 
% Parameters
t = linspace(-1.2e-5, 1.2e-5, 4096);
c = 7e6;
xref = -3; % Plaats van het defect
zref = 7;
numElements = 64;
elementWidth = 0.53;
pitch = 0.63;

% Full matrix en PWI matrix berekenen
waveInfo = [1, 5e6,t];
materialInfo = [c,xref,zref];
elementInfo = [numElements,elementWidth,pitch];
[fmc,S] = FMC(waveInfo,materialInfo,elementInfo);
angles = linspace(-pi/3,pi/3,120);
pwi = PWI(t,S,angles,pitch,c);

% Inputparameters post-processing
D = 5*pitch; % Aperture width
aantalx = 32; % Nauwkeurigheid (aantal punten dat je wilt plotten)
aantalz = 32;
zmin = 0.01; % Testgrenzen voor z
zmax = 10;

xmin = -(numElements-1)*pitch/2;
xmax = (numElements-1)*pitch/2;
arraySetup = (-(numElements-1)*pitch/2:pitch:(numElements-1)*pitch/2);
z = linspace(zmin,zmax,aantalz);
x = linspace(xmin,xmax,aantalx);

thetamax = atan(zmin/arraySetup(end));
angles = linspace(-thetamax,thetamax,60);

% Figuren
close all
figure
I = planeScan(fmc,t,x,z,D,c,arraySetup);
imagesc(x,z,I)
title("Plane scan")

figure
I = sectorScan(fmc,t,x,z,c,arraySetup);
imagesc(x,z,I)
title("Sector scan")

figure
I = focusedScan(fmc,t,x,z,D,c,arraySetup);
imagesc(x,z,I)
title("Focused scan")

figure
I = tfm(fmc,t,x,z, c, arraySetup);
imagesc(x,z,I)
title("Total focusing method")

figure
I = PWI_image(pwi,t, x, z, c, arraySetup,angles);
imagesc(x,z,I)
title("Plane wave imaging")


%% Multiple layers
% Glasvezellocaties
xx = linspace(-3,3,3);
zz = 5.5*ones(1,3);

% Opbouw full matrix en PWI matrix
t = linspace(-1e-5, 1e-5, 2^15); 
c_a = 6.3e6; % Longitudinaal in aluminium
c_b = 1.5e6; % Sound velocity in water
c = [c_a c_b c_a];
z_in = [5,6];
numElements = 16;
elementWidth = 0.53;
pitch = 0.63;
waveInfo = [1, 5e6,t];
elementInfo = [numElements,elementWidth,pitch];
fmc = zeros(numElements);
S = fmc;
for i = 1:length(xx)
    [fmcTemp,STemp] =  FMC_multiple(waveInfo, [xx(i),zz(i),z_in,c], elementInfo);
    fmc = fmc + fmcTemp;
    S = S + STemp;
end
clear('fmcTemp','STemp') % Memory cleaning
angles = linspace(-pi/3,pi/3,120);
pwi = PWI(t,S,angles,pitch,c(1));

% Inputparameters post-processing
aantalx = 64; % Nauwkeurigheid (aantal punten dat je wilt plotten)
aantalz = 64;
zmin = 5; % Testgrenzen voor z
zmax = 6;

xmin = -(numElements-1)*pitch/2;
xmax = (numElements-1)*pitch/2;
arraySetup = (-(numElements-1)*pitch/2:pitch:(numElements-1)*pitch/2);
z = linspace(zmin,zmax,aantalz);
x = linspace(xmin,xmax,aantalx);

thetamax = atan(zmin/arraySetup(end));
angles = linspace(-thetamax,thetamax,60);

% Figuren
figure
I = tfm_multiple(fmc,t,x,z,z_in(1),c,arraySetup);
imagesc(x,z,I)
title("TFM multiple layers")

figure
I = PWI_image_multiple(pwi,t,x,z,z_in(1),c,arraySetup,angles);
imagesc(x,z,I)
title("PWI multiple layers")