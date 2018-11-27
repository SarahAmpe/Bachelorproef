%% FMC multiple input (+ test wavefunctie)
t = linspace(-1e-5, 1e-5, 1000); % niet aanpassen! tfm is hiervan afhankelijk
plot(t,wave(2,5e6,t));
c_a = 7e6;
c_b = 5e6;
c = [c_a c_b c_b c_a];
xref = -2;
zref = 5.5;
z_in = 5;
numElements = 15;
elementWidth = 0.53;
pitch = 0.63;
waveInfo = [1, 5e6,t];
materialInfo = [xref,zref, z_in,c];
elementInfo = [numElements,elementWidth,pitch];

[fmc,S] = FMC_multiple(waveInfo,materialInfo,elementInfo);

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