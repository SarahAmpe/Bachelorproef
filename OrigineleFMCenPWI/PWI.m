function M = PWI(t,H,angles,pitch,c)
% PWI Simulates the Plane Wave Imaging matrix of a phased array based on the Full Matrix Capture.
% INPUT:
    % t      = time sequence from the Full Matrix Capture
    % H      = frequency domain matrix from Full Matrix Capture
    % angles = vector containing the angles at which the waves are transmitted.
    % pitch  = the pitch of the phased array.
    % c      = velocity of the wave in the material.
% OUTPUT:
    % M = matrix of time-domain signals

d = pitch ;

N = size(H,1); % Number of elements
T = size(H,3);
freq = (0:T-1)/T/(t(2)-t(1));
tau = (1:N)'*d*angles/c - min((1:N)'*d*angles/c); 
M = repmat(zeros,length(angles),N);
for w = 1:T
    M(:,:,w) = conj(H(:,:,w)*exp(-1j*freq(w)*tau))';
end
M = real(ifft(M,[],3));
