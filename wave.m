function signaal = wave(A,f,t,N)

golf = A*cos(f*t);
signaal = gausswin(N)*golf;