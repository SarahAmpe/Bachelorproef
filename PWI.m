function M = PWI(t,H,angles,pitch,c,z_in)
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
c_a = c(1);
c_b = c(2);

N = size(H,1); % Number of elements
T = size(H,3);
freq = permute((0:T-1)/T/(t(2)-t(1)),[1,3,2]);
tau = (1:N)'*d*sin(angles)/c_a - min((1:N)'*d*sin(angles)/c_a); %c_a of c_b?
M = repmat(zeros,length(angles),N);
for w = 1:N
    M(:,:,w) = (H(:,:,w)*exp(-1j*freq(w)*tau))';
end
M = real(ifft(M,[],3));
