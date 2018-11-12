function M = PWI(H,hoeken,pitch,c)

N = size(fmc,1); % Number of elements

beginHoek = hoeken(1);
eindHoek = hoeken(2);
aantal = hoeken(3);
betas = linespace(beginHoek,eindHoek,aantal);

d = pitch ;

tau = (1:N)'*d*sin(betas)/c - min((1:N)'*d*sin(betas));
m = repmat(zeros(1),aantal,N,N);
for w=1:N
    m(:,:,w) = (H*exp(-1j*w*tau))';
end

M = m;