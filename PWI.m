function M = PWI(H,hoeken,pitch,c)

N = size(H,1); % Number of elements
W = size(H,3);

beginHoek = hoeken(1);
eindHoek = hoeken(2);
aantal = hoeken(3);
betas = linespace(beginHoek,eindHoek,aantal);

d = pitch ;

tau = (1:N)'*d*sin(betas)/c - min((1:N)'*d*sin(betas));
m = repmat(zeros(1),aantal,N,N);
for w=1:W
    m(:,:,w) = (H*exp(-1j*w*tau))';
end

M = m;