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
<<<<<<< HEAD
stepx = (numElements-1)*pitch/aantalx;
stepz = (zmax-zmin)/aantalz;
z = zmin:stepz:zmax;
x = xmin:stepx:xmax;

I = zeros(length(z),length(x));
for m = 1:length(x)
    tt = 2*z/c;
    idx = abs(arraySetup-x(m))<=D/2;
    signal = permute(fmc(idx,idx,:),[3,1,2]);
    signal = sum(envelope(signal(:,:)),2);
    I(:,m) = interp1(t,signal,tt);
end
imagesc(xmin:stepx:xmax, (zmin:stepz:zmax), I)
plotTitle = ['PlaneBScan at position (', num2str(xref), ',' , num2str(zref), ')' ];
title(plotTitle)
xlabel('x-coordinate in mm')
ylabel('z-coordinate in mm')
cb = colorbar;
cb.Label.String = 'Intensity of the wave in the receiving transducers';
file = string(['PlaneBScan_at_position_(', num2str(xref), ',' , num2str(zref), ').png' ]);
saveas(gcf, file)



%% sectorScan testing

I = zeros(20);
arraySetup = (-(numElements-1)*pitch/2:pitch:(numElements-1)*pitch/2);
aantalx= 20;% nauwkeurigheid (aantal punten dat je wilt plotten)
aantalz= 20;
xmin = -(numElements-1)*pitch/2;
xmax = (numElements-1)*pitch/2;
zmin = 0.05;
zmax = 10;
stepx = (numElements-1)*pitch/aantalx;
stepz = (zmax-zmin)/aantalx;
for m = 1:aantalx+1
    for n = 1:aantalz+1
        x = xmin + (m-1)*stepx;
        z = zmin + (n-1)*stepz; 
        I(n,m) = sectorScan(fmc,t, x, z, c, arraySetup); % nog probleem omdat time soms negatief wordt...
    end
end
imagesc(xmin:stepx:xmax,zmin:stepz:zmax,I)
plotTitle = ['SectorScan at position (', num2str(xref), ',' , num2str(zref), ')' ];
title(plotTitle)
xlabel('x-coordinate in mm')
ylabel('z-coordinate in mm')
cb = colorbar;
cb.Label.String = 'Intensity of the wave in the receiving transducers';
file = string(['SectorScan_at_position_(', num2str(xref), ',' , num2str(zref), ').png' ]);
saveas(gcf, file)

=======
z = linspace(zmin,zmax,aantalz);
x = linspace(xmin,xmax,aantalx);


>>>>>>> 86e4a3502113f9c7b0fe27f2864bc1bd08185300
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
<<<<<<< HEAD
%% focusedScan testing
D = 5*pitch;

I = zeros(20);
arraySetup = (-(numElements-1)*pitch/2:pitch:(numElements-1)*pitch/2);
aantalx= 20;% nauwkeurigheid (aantal punten dat je wilt plotten)
aantalz= 20;
xmin = -(numElements-1)*pitch/2;
xmax = (numElements-1)*pitch/2;
zmin = 0.05;
zmax = 5;
stepx = (numElements-1)*pitch/aantalx;
stepz = (zmax-zmin)/aantalx;
for m = 1:aantalx+1
    for n = 1:aantalz+1
        x = xmin + (m-1)*stepx;
        z = zmin + (n-1)*stepz; 
        I(n,m) = focusedScan(fmc, t, x, z, D, c, arraySetup);
    end
end
imagesc(xmin:stepx:xmax,zmin:stepz:zmax,I)
=======

%% focusedScan testing
>>>>>>> 86e4a3502113f9c7b0fe27f2864bc1bd08185300
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
