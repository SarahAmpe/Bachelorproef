function signal = wave(A,f,t)
% WAVE Constructs a Gaussian windowed output signal
% INPUT:
    % A = amplitude of the signal
    % f = frequency of the signal
    % t = time-sequence for the signal
% OUTPUT:
    % signal = gaussian windowed cosinus signal.

wave = A*cos(2*pi*f*t);
signal = gausswin(length(wave),100)'.*wave;

end
