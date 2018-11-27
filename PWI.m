function M = PWI(t,H,angles,pitch,c)
% PWI Simulates the Plane Wave Imaging matrix of a phased array based on the Full Matrix Capture.
% INPUT:
    % t      = time sequence from the Full Matrix Capture
    % H      = frequency domain matrix from Full Matrix Capture
    % angles = vector containing the initial and final angle and the number of
    %          angles at which the waves are transmitted.
    % pitch  = the pitch of the phased array.
    % c      = velocity of the wave in the material.
% OUTPUT:
    % M = matrix of time-domain signals

N = size(H,1); % Number of elements
W = lenth(t); 

startBeta = angles(1);
endBeta = angles(2);
number = angles(3);
betas = linespace(startBeta,endBeta,number);

d = pitch ;

tau = (1:N)'*d*sin(betas)/c - min((1:N)'*d*sin(betas));
m = repmat(zeros(1),number,N,N);
for w=1:W
    m(:,:,w) = (H*exp(-1j*(2*pi/t(w))*tau))';
end
M = m;

% complex hilberttransform
M = permute(M,[3,1,2]); 
Mr = real(M);
Mi = imag(M);
Mr = imag(hilbert(Mr));
Mi = imag(hilbert(Mi));
M = Mr + 1i* Mi;

PWI = permute(M,[2,3,1]);
