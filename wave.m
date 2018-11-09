function signaal = wave(A,f,t)

golf = A*cos(f*t);
signaal = exp(-1/2*t.^2).*golf;