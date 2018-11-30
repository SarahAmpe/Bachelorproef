function intensity = PWI_image(pwi,t, xref, zref, z_in, c_a, c_b, arraySetup,angles)

zref = zref';
intensity = zeros(length(zref),length(xref));
intensity1 = zeros(length(zref),length(xref));
alphas = asin(c_a/c_b*sin(angles));
x_in = z_in * tan(alphas);

N = size(pwi,2);
x_out = zeros(length(zref),length(xref));
for n = 1:length(angles)
    t_in(:,:) = (x_in(n)*sin(alphas(n)) + z_in*cos(alphas(n)))/c_a + ((xref - x_in(n))*sin(angles(n)) + (zref - z_in)*cos(angles(n)))/c_b;
    for m = 1:N
        xr = arraySetup(m);
        func = @(x,x_p,z_p) c_a/c_b*((x-x_p)*sqrt((x-x_p)^2 + (z_p-z_in)^2)) - (xr-x)*sqrt((xr-x)^2 + z_in^2);
        for l = 1:length(xref)
            for k = 1:length(zref)
                x_out(k,l) = fzero(@(x) func(x,xref(l),zref(k)), (xref(l) + xr)/2);
            end
        end
        t_out = sqrt((xr-x_out).^2 + z_in^2)./c_a + sqrt((xref - x_out).^2 + (z_in - zref).^2)./c_b;
        time = t_in + t_out;
        signal = permute(pwi(n,m, :), [3 1 2]);
        signal = envelope(signal(:,:));
        I = interp1(t,signal,time);
        intensity1 = intensity1 + I;
    end
    intensity = intensity + intensity1;
end