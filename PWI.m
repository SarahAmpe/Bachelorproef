function M = PWI(H,angles,pitch,c)

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