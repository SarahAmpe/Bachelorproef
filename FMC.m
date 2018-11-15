function [fmc,S] = FMC(waveInfo,materialInfo,elementInfo)
% Function to simulate the full matrix capture of a phased array for a material with a given scatterpoint.

% INPUT:
% waveInfo = Amplitude, frequency and timesequence for the simulated signal (cosinuswave)
% materialInfo = velocity of the wave in the material and x,y-coordinates ([xref,yref]) of the defect (poinscatterer)
% elementInfo = number of elements, the width and the pitch of the elements in the array setup

% OUTPUT:
% S = a 3D-matrix with the resulting spectrum for each transmitter-receiver pair.
%       (dimensions: transmitter, receiver, frequency)
% fmc = 3D-matrix with the resulting time-domain signal for each transmitter-receiver pair obtained with the complex Hilbert transform.
%       (dimensions: transmitter, receiver, time)

% parameters
A = waveInfo(1);
f = waveInfo(2);
t = waveInfo(3:end); %t zal toch als een arry meegegeven worden dus wss kan je hier enkel 3 zetten, lik anders ga je hier ook geen lijst maken ofzo hoe dat nu sta

c = materialInfo(1);
xref = materialInfo(2); %Het punt waar we het defect vermoeden
zref = materialInfo(3);

numElements = elementInfo(1); %Ik vermoed dat dit hier de array setup is
elementWidth = elementInfo(2);
pitch = elementInfo(3);

lambda = c/f;
% construction of the signal
signal = wave(A,f,t);

% Fourriertransform (FFT)
N = length(t);
F = fft(signal); 

% intermediate calculations
xt = (0:(numElements-1)) - (numElements-1)*ElementsWidth/2;  % x=0 is the centrum of the phased array
xr = xt';
dt = sqrt((xref-xt).^2 + zref.^2);
dr = sqrt((xref-xr).^2 + zref.^2);
d = dt + dr;

pt = sinc(pi*elementWidth*(abs(xt - xref)./dt)/lambda);
pr = sinc(pi*elementWidth*(abs(xr - xref)./dr)/lambda);
A = A./sqrt(dr*dt);

% complex spectrum of each transducer-receiver pair
G = repmat(zeros(1),numElements,numElements,N); % 3D matrices with zeros
H = G;
for w=1:N
    G(:,:,w) = F(w).*exp(-1i*w*d/c);
    H(:,:,w) = pr*pt.*A.*G(:,:,w);
end
S = H; % just to have a clear output

% complex hilberttransform
H = permute(H,[3,1,2]); % because the function hilbert works columwise
Hr = real(H); % because the function hilbert only works with real input
Hi = imag(H);
Hr = imag(hilbert(Hr));
Hi = imag(hilbert(Hi));
H = Hr + 1i* Hi;

fmc = permute(H,[2,3,1]);

