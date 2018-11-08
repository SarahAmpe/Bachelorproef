function fmc = FMC(golfInfo,materiaalInfo,elementInfo)

% benoeming van alle verschillende parameters nodig voor het algoritme
A = golfInfo(1);
f = golfInfo(2);
t = golfInfo(3);
N = golfInfo(4);

c = materiaalInfo(1);
xref = materiaalInfo(2);
zref = materiaalInfo(3);

numElements = elementInfo(1);
elementWidth = elementInfo(2);
pitch = elementInfo(3);

% constructie van het signaal
signaal = wave(A,f,t,N);

% Fourriertransformatie
F = 2*pi*fourier(signaal);

% tussenberekeningen
xt = (0:numElements)*pitch;  
xr = xt';
dt = sqrt((xref-xt)^2 + zref^2);
dr = sqrt((xref-xr)^2 + zref^2);
d = dt + dr;

pt = sinc(pi*elementWidth*((xref-xt)./dt)/lambda);
pr = sinc(pi*elementWidth*((xref-xr)./dr)/lambda);
A = A/sqrt(dr*dt);

% complex spectrum voor elk transducer-receiver paar
G = repmat(zeros(1),length(xr),length(xt),lenth(F)); % 3D matrices op voorhand aanmaken met nullen
H = G;
for w=0:length(F)-1
    G(:,:,w) = F(w).*exp(-iw/c*d);
    H = pr*pt.*A.*G(:,:,w);
end

% complexe hilberttransformatie
fmc = 1/pi*integrate(H,0,inf); % hoe complexe hilberttransformatie?
