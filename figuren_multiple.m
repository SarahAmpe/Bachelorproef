clear;
close all;
addpath('Hulpfuncties')
addpath('OrigineleFMCenPWI')
addpath('MultipleLayers')

%% FIGUURPARAMETERS -- Defecten op meshgrid(xx,zz)
xx = linspace(-3,3,7); %[-3,-2,-1,0,1,2,3]
zz = 5.5*ones(1,7);

%% CONSTRUCTIE FIGUUR
% Opbouw full matrix
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
for i = 1:length(xx)
    fmc = fmc + FMC_multiple(waveInfo, [xx(i),zz(i),z_in,c], elementInfo);
end

%% Testparameters
aantalx = 16; % Nauwkeurigheid (aantal punten dat je wilt plotten)
aantalz = 16;
zmin = 5; % Testgrenzen voor z
zmax = 6;

xmin = -(numElements-1)*pitch/2;
xmax = (numElements-1)*pitch/2;
arraySetup = (-(numElements-1)*pitch/2:pitch:(numElements-1)*pitch/2);
z = linspace(zmin,zmax,aantalz);
x = linspace(xmin,xmax,aantalx);

% Figuur maken
I = tfm_multiple(fmc,t,x,z,z_in(1),c,arraySetup);
plotTitle = ['TFM for multiple layers'];
fileName = ['TFM_multiple.png'];
intensityPlot(x,z,xx,zz,I,plotTitle,fileName)
