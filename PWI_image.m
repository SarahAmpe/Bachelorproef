function intensity = PWI_image(pwi,t, x, z, z_in, c_a, c_b, arraySetup,angles)

z = z';
intensity = zeros(length(z),length(x));
intensity1 = zeros(length(z),length(x));
alphas = asin(c_a/c_b*sin(angles));
x_in = z_in * tan(alphas);

N = size(pwi,1);
x_out = zeros(length(z),length(x));
t_out = zeros(length(z),length(x));
for n = 1:length(angles)
    t_in(:,:) = (x_in(n)*sin(alphas(n)) + z_in*cos(alphas(n)))/c_a + ((x - x_in(n))*sin(angles(n)) + (z - z_in)*cos(angles(n)))/c_b;
    for m = 1:N
        xr = arraySetup(m);
        for l = 1:length(x)
            for k = 1:length(z)
                func = @(x) c_a/c_b*((x-x(l))*((x-x(l))^2 + (z(k)-z_in)^2)^(-1/2)) - (xr-x)*((xr-x)^2 + z_in^2)^(-1/2);
                x_out(k,l) = fzero(func, (xr+x(l))/2);
                t_out(k,l) = sqrt((xr-x_out(k,l))^2 + z_in^2)/c_a + sqrt((x(l) - x_out(k,l))^2 + (z_in - z(k))^2)/c_b;
            end
        end
        time = t_in + t_out;
        signal = permute(pwi(n,m, :), [3 1 2]);
        signal = envelope(signal(:,:));
        I = interp1(t,signal,time);
        intensity1 = intensity1 + I;
    end
    intensity = intensity + intensity1;
end