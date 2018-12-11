function [H,S] = FMC_multiple(waveInfo,materialInfo,elementInfo)
% FMC_MULTIPLE Simulates the full matrix capture of a phased array for a multiple-layered material with a given scatterpoint.
% INPUT:
    % waveInfo     = Amplitude, frequency and timesequence for the simulated signal (cosine wave)
    % materialInfo = x,y-Coordinates ([xref,yref]) of the defect (pointscatterer) and 
    %                velocity of the wave in the materials ([c_a, c_b, c_c, c_d])
    %                (2 transversal and 2 longitudinal velocities)
    % elementInfo  = Number of elements, the width and the pitch of the elements in the array setup
% OUTPUT:
    % S   = 3D-matrix with the resulting spectrum for each transmitter-receiver pair.
    %       (dimensions: transmitter, receiver, frequency)
    % fmc = 3D-matrix with the resulting time-domain signal for each transmitter-receiver pair obtained with the complex Hilbert transform.
    %       (dimensions: transmitter, receiver, time)

% Parameters
A0 = waveInfo(1);
f = waveInfo(2);
t = waveInfo(3:end);


xref = materialInfo(1); % Defect
zref = materialInfo(2);
z_in = materialInfo(3:4); %Thickness of first material
c = materialInfo(5:end);
c_a = c(1);
c_b = c(2);
R_a = 2700*10^(-9)*c_a;
R_b = 1000*10^(-9)*c_b;

numElements = elementInfo(1); 
elementWidth = elementInfo(2);
pitch = elementInfo(3);

lambda1 = c_a/f;
lambda2 = c_b/f;

% Construction of the signal and its Fouriertransform (via FFT)
signal = wave(A0,f,t);
N = length(t);
F = permute(fft(signal,N),[1,3,2]); 
freq = permute((0:N-1)/N/(t(2)-t(1)),[1,3,2]);


% Calculating propagation distance, directivity functions and signal amplitude
xt = (-(numElements-1)*pitch/2:pitch:(numElements-1)*pitch/2);  % x=0 is the centre of the phased array
xr = xt';

% reflections on defect
x = (xt + xref)./2;
x_in = zeros(1,numElements);
for n = 1:numElements
    func = @(x) c_b/c_a*((x-xt(n))*((x-xt(n))^2 + z_in(1)^2)^(-1/2)) - (xref - x)*((xref -x)^2 + (zref-z_in(1))^2)^(-1/2);
    x_in(n) = fzero(func, x(n)); %Position where ingoing wave transits into the other material 
end

x = (xref + xr)./2;
x_out = zeros(numElements,1);
for n = 1:numElements
    func = @(x) c_a/c_b*((x-xref)*((x-xref)^2 + (zref-z_in(1))^2)^(-1/2)) - (xr(n)-x)*((xr(n)-x)^2 + z_in(1)^2)^(-1/2);
    x_out(n) = fzero(func, x(n)); %Position where outgoing wave transits into the other material 
end

dt1 = ((xt-x_in).^2+(z_in(1))^2).^(1/2);
dt2 = ((x_in - xref).^2 + (z_in(1) - zref)^2).^(1/2);
dr1 = ((xr-x_out).^2 + z_in(1)^2).^(1/2);
dr2 = ((x_out-xref).^2 + (zref-z_in(1))^2).^(1/2);
d1 = dt1 + dr1; % Propagation distance
d2 = dt2 + dr2;

pt1 = sinc(pi*elementWidth*(abs(xt - x_in)./dt1)/lambda1); % Transmit directivity function
pt2 = sinc(pi*elementWidth*(abs(x_in - xref)./dt2)/lambda2);
pt = pt1 .* pt2;
pr1 = sinc(pi*elementWidth*(abs(xr - x_out)./dr1)/lambda1);
pr2 = sinc(pi*elementWidth*(abs(x_out - xref)./dr2)/lambda2); % Receive directivity function
pr = pr1 .* pr2;
A = A0./sqrt((dr1+dr2)*(dt1+dt2)); % Signal amplitude after propagation

% Transmission coefficient (in)
costi = z_in(1)./dt1;
costt = (zref-z_in(1))./dt2;
t_in = (R_a*costt)./(R_b*costi).*((2*R_b*costi)./(R_a*costt + R_b*costi)).^2;

% Transmisson coefficent (out)
costi = (zref-z_in(1))./dr2;
costt = z_in(1)./dr1;
t_out = (R_b*costt)./(R_a*costi).*((2*R_a*costi)./(R_b*costt + R_a*costi)).^2;

t = t_in .* t_out;

% Complex spectrum for each transmitter-receiver pair
G = F.*exp(-1i*(2*pi*freq).*(d1/c_a + d2/c_b)); 
H = t.*(pr*pt.*A.*G);

% reflections on first layer:
dt = sqrt(((xt-xr)/2).^2 + (z_in(1)).^2); 
dr = dt;
d = dt + dr;
pt = sinc(pi*elementWidth*(abs(xt -xr)/2./dt)/lambda1);
pr = pt;
A = A0./sqrt(dt.*dr);

% Reflection coefficient
costi = z_in(1)./dt;
costt = cos(asin(c_b/c_a*sin(acos(costi))));
r = ((R_b * costi - R_a * costt)./(R_b * costi + R_a * costt)).^2;

% Complex spectrum for each transmitter-receiver pair
G = F.*exp(-1i*(2*pi*freq).*(d/c_a)); 
H = H + r.*pr.*pt.*A.*G;

% reflections on second layer:
xref = (xt(1) + xr)'/2;
x = (xt(1) + xref)./2;
x_in = zeros(1,numElements);
for m = 1:numElements
    func = @(x) c_b/c_a*((x-xt(1))*((x-xt(1))^2 + z_in(1)^2)^(-1/2)) - (xref(m) - x)*((xref(m) -x)^2 + (z_in(2)-z_in(1))^2)^(-1/2);
    x_in(m) = fzero(func, x(n)); %Position where ingoing wave transits into the other material 
end
x_in = x_in - xt(1);
x_in = toeplitz(x_in);

dt1 = sqrt((x_in).^2+(z_in(1))^2);
dt2 = sqrt((abs(xt-xref)-x_in).^2 + (z_in(1) - z_in(2))^2);
d = dt1 + dt2;

pt1 = sinc(pi*elementWidth*(x_in./dt1)/lambda1); % Transmit directivity function
pt2 = sinc(pi*elementWidth*((abs(xt-xref)-x_in)./dt2)/lambda2);
pt = pt1 .* pt2;
pr = pt;
A = A0./sqrt(d.*d); % Signal amplitude after propagation

% Transmission coefficient (in)
costi = z_in(1)./dt1;
costt = (z_in(2)-z_in(1))./dt2;
t_in = (R_a*costt)./(R_b*costi).*((2*R_b*costi)./(R_a*costt + R_b*costi)).^2;

% Reflection coefficient
costi = costt;
costt = cos(asin(c_b/c_a*sin(acos(costi))));
r = ((R_b * costi - R_a * costt)./(R_b * costi + R_a * costt)).^2;

% Transmission coefficient (out)
costi = (z_in(2)-z_in(1))./dt2;
costt = z_in(1)./dt1;
t_out = (R_b*costt)./(R_a*costi).*((2*R_a*costi)./(R_b*costt + R_a*costi)).^2;


% Complex spectrum for each transmitter-receiver pair
G = F.*exp(-1i*(2*pi*freq).*((2*dt1)/c_a + (2*dt2)/c_b)); 
H = (t_in.*r.*t_out).*(pr.*pt.*A.*G);

% back to time domain
S = H; % needed for input of PWI
H = real(ifft(H,[],3));
