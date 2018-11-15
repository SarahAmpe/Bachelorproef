function M = PWI(H,angles,pitch,c)
% This function simulates the Plane Wave Imaging matrix of a phase array
% based on the Full Matrix Capture.

% INPUT
% H = frequency domain matrix from Full Matrix Capture
% angles = vector containing the initial and final angle and the number of
%   angles at which the waves are transmitted.
% pitch = the pitch of the phased array.
% c = velocity of the wave in the material.

N = size(H,1); % Number of elements
W = size(H,3); 

startBeta = angles(1);
endBeta = angles(2);
number = angles(3);
betas = linespace(startBeta,endBeta,number);

d = pitch ;

tau = (1:N)'*d*sin(betas)/c - min((1:N)'*d*sin(betas));
m = repmat(zeros(1),number,N,N);
for w=1:W
    m(:,:,w) = (H*exp(-1j*w*tau))';
end

M = m;