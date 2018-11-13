function F = fourier2(signal)
% Fourriertransform based on FFT
% and by dividing the real data in the odd and even subsequence to reduce
% the computation time with a factor 2.

f = signal(1:2:end-1)+ 1i*signal(2:2:end);
X = fft(f);
N = length(signal);
F = zeros(1,N);
A = zeros(1,N/2);
B = zeros(1,N/2);
for n = 1:N/2
    A(n) = (X(n)+conj(X(end-(n-1))))/2;
    B(n) = (X(n)-conj(X(end-(n-1))))/(2i);
    F(n) = A(n) + exp(2*pi*(n-1)*1i/N)*B(n);
    F(N/2+n) = A(n) - exp(2*pi*(n-1)*1i/N)*B(n);
end
