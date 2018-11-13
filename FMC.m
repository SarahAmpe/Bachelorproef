function [fmc,H] = FMC(wavefInfo,materialInfo,elementInfo)

% parameters
A = waveInfo(1);
f = waveInfo(2);
t = waveInfo(3:end);

c = materialInfo(1);
xref = materialInfo(2);
zref = materialInfo(3);

numElements = elementInfo(1);
elementWidth = elementInfo(2);
pitch = elementInfo(3);

lambda = c/f;
% construction of the signal
signal = wave(A,f,t);

% Fourriertransform (FFT)
F = fourier2(signal);

% intermediate calculations
xt = (0:numElements-1)*pitch;  
xr = xt';
dt = sqrt((xref-xt).^2 + zref.^2);
dr = sqrt((xref-xr).^2 + zref.^2);
d = dt + dr;

pt = sinc(pi*elementWidth*((xref-xt)./dt)/lambda);
pr = sinc(pi*elementWidth*((xref-xr)./dr)/lambda);
A = A./sqrt(dr*dt);

% complex spectrum of each transducer-receiver pair
G = repmat(zeros(1),numElements,numElements,length(F)); % 3D matrices with zeros
H = G;
for w=1:length(F)
    G(:,:,w) = F(w).*exp(-1i*w/c*d);
    H = pr*pt.*A.*G(:,:,w);
end

% complexe hilberttransform
fmc = 1/pi*integrate(H,0,inf); % how? help.
