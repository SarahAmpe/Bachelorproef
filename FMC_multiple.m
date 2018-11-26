function [fmc,S] = FMC_multiple(waveInfo,materialInfo,elementInfo)
% FMC simulates the full matrix capture of a phased array for a material with a given scatterpoint.
%
% INPUT:
% waveInfo     = Amplitude, frequency and timesequence for the simulated signal (cosine wave)
% materialInfo = x,y-Coordinates ([xref,yref]) of the defect (pointscatterer) and velocity of the wave in the materials ([c_a, c_b, c_c, c_d])
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
t = waveInfo(3:end);


xref = materialInfo(1); % Defect
zref = materialInfo(2);
z_in = materialInfo(3); %Thickness of first material
c = materialInfo(4:end);
c_a = c(1);
c_b = c(2);
%c_c = c(3); %When considering longitudinal? waves these velocities will be the same
%c_d = c(4);

numElements = elementInfo(1); 
elementWidth = elementInfo(2);
pitch = elementInfo(3);

lambda1 = c_a/f;
lambda2 = c_b/f;

% Construction of the signal and its Fouriertransform (via FFT)
signal = wave(A,f,t);
N = length(t);
F = fft(signal,2*N); 
freq = (0:N-1)/N/(t(2)-t(1));


% Calculating propagation distance, directivity functions and signal amplitude
xt = (-(numElements-1)*pitch/2:pitch:(numElements-1)*pitch/2);  % x=0 is the centre of the phased array
xr = xt';
x = xt;
x_in = zeros(1,numElements);
for n = 1:numElements
    func = @(x) c_b/c_a*((x-xt(n))*((x-xt(n))^2 + z_in^2)^(-1/2)) - (xref - x)*((xref -x)^2 + (zref-z_in)^2)^(-1/2);
    x_in(n) = fzero(func, x(n)); %Position where ingoing wave transits into the other material 
end

x = xr;
x_out = zeros(numElements,1);
for n = 1:numElements
    func = @(x) c_a/c_b*((x-xref)*((x-xref)^2 + (zref-z_in)^2)^(-1/2)) + (xr(n)-x)*((xr(n)-x)^2 + z_in^2)^(-1/2);
    x_out(n) = fzero(func, x(n)); %Position where outgoing wave transits into the other material 
end

dt1 = ((xt-x_in).^2+(z_in)^2).^(1/2);
dt2 = ((x_in - xref).^2 + (z_in - zref)^2).^(1/2);
dr1 = ((xr-x_out).^2 + z_in^2).^(1/2);
dr2 = ((x_out-xref).^2 + (zref-z_in)^2).^(1/2);
d1 = dt1 + dr1; % Propagation distance
d2 = dt2 + dr2;

pt1 = sinc(pi*elementWidth*(abs(xt - x_in)./dt1)/lambda1); % Transmit directivity function
pt2 = sinc(pi*elementWidth*(abs(x_in - xref)./dt2)/lambda2);
pt = pt1 .* pt2;
pr1 = sinc(pi*elementWidth*(abs(xr - x_out)./dr1)/lambda1);
pr2 = sinc(pi*elementWidth*(abs(x_out - xref)./dr2)/lambda2); % Receive directivity function
pr = pr1 .* pr2;
A = A./sqrt((dr1+dr2)*(dt1+dt2)); % Signal amplitude after propagation

% Complex spectrum for each transmitter-receiver pair
G = zeros(numElements, numElements, N); % 3D matrix with zeros
H = G;
for w = 1:N
    G(:,:,w) = F(w).*exp(-1i*(2*pi*freq(w))*(d1/c_a + d2/c_b)); 
    H(:,:,w) = pr*pt.*A.*G(:,:,w);
end
S = H; % needed for input of PWI

% Time-domain signal for each transmitter-receiver pair
H = permute(H,[3,1,2]); % because the function hilbert works columnwise
% Hr = real(H); % because the function hilbert only works with real input
% Hi = imag(H);
% Hr = imag(hilbert(Hr));
% Hi = imag(hilbert(Hi));
% H = Hr + 1i* Hi;

H = ifft(H);
H = imag(hilbert(real(H)));
%H = reshape(envelope(reshape(real(H),1000,numElements^2)),1000,numElements,numElements);
fmc = abs(permute(H,[2,3,1]));
