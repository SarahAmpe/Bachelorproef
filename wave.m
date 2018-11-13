function signal = wave(A,f,t)
% Simulates a wave as input for fmc, by multiplying the cosine with a gaussian signal


cosWave = A*cos(f*t);
signal = exp(-1/2*t.^2).*cosWave;
