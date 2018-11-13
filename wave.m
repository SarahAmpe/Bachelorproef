function signal = wave(A,f,t)

wave = A*cos(f*t);
signal = exp(-1/2*t.^2).*wave;