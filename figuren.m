clear;
close all;
addpath('Hulpfuncties')
addpath('OrigineleFMCenPWI')
addpath('MultipleLayers')

%% FIGUURPARAMETERS -- Defecten op meshgrid(xx,zz)
% Lijnstuk
xx = linspace(-5,5,40);
zz = linspace(3,7,40);

% Pi-figuur
points = [
    -15,4;
     -7,3;
     0,3;
     7,3;
     15,2;
     -5,4.5;
     5,4.5;
     -5,6;
     5,6;
     -6,8;
     6,8];
xx = points(:,1);
zz = points(:,2);

% % Visje
points = [
     -17, 2;
     -17, 3;
     -17, 4;
     -17, 5;
     -13,4;
     -13,3;
     -7,3.5;
     -4,2.7;
     -4,4.2;
     0,2;
     0,5;
     5,1.5;
     5,5.5;
     10,2;
     10,5;
     13,4;
     13,3;
     17,3.5;
     12,4.8];
xx = points(:,1);
zz = points(:,2);

%% CONSTRUCTIE FIGUUR
close all
% Opbouw full matrix
t = linspace(-1.2e-5, 1.2e-5, 4096);
c = 7e6;
numElements = 64;
elementWidth = 0.53;
pitch = 0.63;
waveInfo = [1,5e6,t];
elementInfo = [numElements,elementWidth,pitch];
fmc = zeros(numElements);
for i = 1:length(xx)
    fmc = fmc + FMC(waveInfo, [c,xx(i),zz(i)], elementInfo);
end

% Testparameters
D = 5*pitch; % Aperture width
aantalx = 64; % Nauwkeurigheid (aantal punten dat je wilt plotten)
aantalz = 64;
zmin = 0.01; % Testgrenzen voor z
zmax = 10;

xmin = -(numElements-1)*pitch/2;
xmax = (numElements-1)*pitch/2;
arraySetup = (-(numElements-1)*pitch/2:pitch:(numElements-1)*pitch/2);
z = linspace(zmin,zmax,aantalz);
x = linspace(xmin,xmax,aantalx);

% Defectfiguurtje
imagesc(x,z,zeros(aantalx,aantalz))
hold on
plot(xx,zz,'kx')


% Figuren maken
I = planeScan(fmc,t,x,z,D,c,arraySetup);
plotTitle = ['PlaneBScan at position (', num2str(xx(1)), ',' , num2str(zz(1)), ')' ];
fileName = string(['PlaneBScan_at_position_(', num2str(xx(1)), ',' , num2str(zz(1)), ').png' ]);
intensityPlot(x,z,xx,zz,I,plotTitle,fileName);

I = sectorScan(fmc,t,x,z,c,arraySetup);
plotTitle = ['SectorScan at position (', num2str(xx(1)), ',' , num2str(zz(1)), ')' ];
fileName = string(['SectorScan_at_position_(', num2str(xx(1)), ',' , num2str(zz(1)), ').png' ]);
intensityPlot(x,z,xx,zz,I,plotTitle,fileName);

I = focusedScan(fmc,t,x,z,D,c,arraySetup);
plotTitle = ['FocusedScan at position (', num2str(xx(1)), ',' , num2str(zz(1)), ')' ];
fileName = string(['FocusedScan_at_position_(', num2str(xx(1)), ',' , num2str(zz(1)), ').png' ]);
intensityPlot(x,z,xx,zz,I,plotTitle,fileName);

I = tfm(fmc,t,x,z, c, arraySetup);
plotTitle = ['TFM at position (', num2str(xx(1)), ',' , num2str(zz(1)), ')' ];
fileName = string(['TFM_at_position_(', num2str(xx(1)), ',' , num2str(zz(1)), ').png' ]);
intensityPlot(x,z,xx,zz,I,plotTitle,fileName);