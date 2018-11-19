function [fmc,S] = FMC(waveInfo,materialInfo,elementInfo)
% FMC Simulates the full matrix capture of a phased array for a material with a given scatterpoint.
%
% INPUT:
% waveInfo     = Amplitude, frequency and timesequence for the simulated signal (cosine wave)
% materialInfo = Velocity of the wave in the material and x,y-coordinates ([xref,yref]) of the defect (pointscatterer)
% elementInfo  = Number of elements, the width and the pitch of the elements in the array setup
%
% OUTPUT:
% S   = 3D-matrix with the resulting spectrum for each transmitter-receiver pair.
%       (dimensions: transmitter, receiver, frequency)
% fmc = 3D-matrix with the resulting time-domain signal for each transmitter-receiver pair obtained with the complex Hilbert transform.
%       (dimensions: transmitter, receiver, time)

% Parameters
A = waveInfo(1);
f = waveInfo(2);
t = waveInfo(3:end); %t zal toch als een array meegegeven worden dus wss kan je hier enkel 3 zetten, lik anders ga je hier ook geen lijst maken ofzo hoe dat nu sta

c = materialInfo(1);
xref = materialInfo(2); %Het punt waar we het defect vermoeden
zref = materialInfo(3);

numElements = elementInfo(1); %Ik vermoed dat dit hier de array setup is
elementWidth = elementInfo(2);
pitch = elementInfo(3);

lambda = c/f;

% Construction of the signal and its Fouriertransform (via FFT)
signal = wave(A,f,t);
N = length(t);
F = fft(signal); 


% Calculating propagation distance, directivity functions and signal amplitude
xt = (0:(numElements-1)) - (numElements-1)*elementWidth/2;  % x=0 is the centre of the phased array
xr = xt';
dt = sqrt((xref-xt).^2 + zref.^2);
dr = sqrt((xref-xr).^2 + zref.^2);
d = dt + dr; % Propagation distance

pt = sinc(pi*elementWidth*(abs(xt - xref)./dt)/lambda); % Transmit directivity function
pr = sinc(pi*elementWidth*(abs(xr - xref)./dr)/lambda); % Receive directivity function
A = A./sqrt(dr*dt); % Signal amplitude after propagation

% Complex spectrum for each transmitter-receiver pair
G = zeros(numElements, numElements, N); % 3D matrix with zeros
H = G;
for w = 1:N
    G(:,:,w) = F(w).*exp(-1i*(2*pi/t(w))*d/c); % problem in the middle of the frequency domain
    H(:,:,w) = pr*pt.*A.*G(:,:,w);
end
S = H; % just to have a clear output

% Time-domain signal for each transmitter-receiver pair
H = permute(H,[3,1,2]); % because the function hilbert works columnwise
Hr = real(H); % because the function hilbert only works with real input
Hi = imag(H);
Hr = imag(hilbert(Hr));
Hi = imag(hilbert(Hi));
H = Hr + 1i* Hi;

fmc = abs(permute(H,[2,3,1]));

