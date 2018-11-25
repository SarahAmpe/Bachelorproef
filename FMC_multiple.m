function [fmc,S] = FMC_multiple(waveInfo,materialInfo,elementInfo)
% FMC simulates the full matrix capture of a phased array for a material with a given scatterpoint.
%
% INPUT:
% waveInfo     = Amplitude, frequency and timesequence for the simulated signal (cosine wave)
% materialInfo = Velocity of the wave in the materials ([c_a, c_b, c_c, c_d]) and x,y-coordinates ([xref,yref]) of the defect (pointscatterer)
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

c = materialInfo(1)
c_a = c(1,1);
c_b = c(1,2);
c_c = c(1,3); %When considering longitudinal? waves these velocities will be the same
c_d = c(1,4);
xref = materialInfo(2); % Defect
zref = materialInfo(3);
z_in = materialInfo(4); %Thickness of first material

numElements = elementInfo(1); 
elementWidth = elementInfo(2);
pitch = elementInfo(3);

lambda = c/f;

% Construction of the signal and its Fouriertransform (via FFT)
signal = wave(A,f,t);
N = length(t);
F = fft(signal,2*N); 
freq = (0:N-1)/N/(t(2)-t(1));


% Calculating propagation distance, directivity functions and signal amplitude
xt = (-(numElements-1)*pitch/2:pitch:(numElements-1)*pitch/2);  % x=0 is the centre of the phased array
xr = xt';
func = @(x) c_a/c_b*((x-xt)*((x-xt).^2 + z_in^2)^(-1/2) - (x_ref - x)*((x_ref -x)^2 + (z_ref-z_in)^2)^(-1/2));
x = xt;
x_in = fzero(func, x); %Position where ingoing wave transits into the other material 

func = @(x) c_b/c_a*((x-x_ref)*((x-x_ref)^2 - (z_ref-z_in)^2)^(-1/2) - (xr-x)*((xr-x).^2 + z_in^2));
x = xr;
x_out = fzero(func, x); %Position where outgoing wave transits into the other material 

dr = ((xt-x_in).^2+(z_in)^2)^(1/2) + ((x_in - x_ref)^2 + (z_in - z_ref)^2)^(1/2);
dt = ((x_out-x_ref)^2 + (z_ref-z_in)^2)^(1/2) + ((xt-x_out).^2 + z_in^2)^(1/2);

pt = sinc(pi*elementWidth*(abs(xt - xref)./dt)/lambda); % Transmit directivity function
pr = sinc(pi*elementWidth*(abs(xr - xref)./dr)/lambda); % Receive directivity function
A = A./sqrt(dr*dt); % Signal amplitude after propagation

% Complex spectrum for each transmitter-receiver pair
G = zeros(numElements, numElements, N); % 3D matrix with zeros
H = G;
for w = 1:N
    G(:,:,w) = F(w).*exp(-1i*(2*pi*freq(w))*d/c); 
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
