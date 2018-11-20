function signal = wave(A,f,t)
% This function constructs an Gaussian windowed ouput signal

% INPUT:
% A = amplitude of the signal
% f = frequentie of the signal
% t = time-sequence for the signal

% OUTPUT:
% signal = gaussian windowed cosinus signal.

wave = A*cos(2*pi*f*t);
signal = gausswin(length(wave))'.*wave;
