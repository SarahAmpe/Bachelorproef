function F = fourier2(signal)
% Fourriertransform based on FFT
% and by dividing the real data in the odd and even subsequence to reduce
% the computation time with a factor 2.

f = signal(1:2:end-1)+ 1i*signal(2:2:end);
X = fft(f);
N = length(f)/2;
F = zeros(2*N,1);
A = zeros(N,1);
B = zeros(N,1);
for n = 1:N
    A(n) = (X(n)+conj(X(end-n)))/2;
    B(n) = (X(n)-conj(X(end-n)))/(2i);
    F(n) = A(n) + exp(pi*1i/N)*B(n);
    F(N+n) = A(n) - exp(pi*1i/N)*B(n);
end
