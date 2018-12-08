function signal = wave(A,f,t)
% WAVE Constructs a Gaussian windowed output signal
% INPUT:
    % A = amplitude of the signal
    % f = frequency of the signal
    % t = time-sequence for the signal
% OUTPUT:
    % signal = gaussian windowed cosinus signal.

wave = A*cos(2*pi*f*t);
% wave = A*sinc(pi*t);
signal = gausswin(length(wave),2000)'.*wave;

end
