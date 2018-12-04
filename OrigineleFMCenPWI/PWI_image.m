function intensity = PWI_image(pwi,t, gridx, gridz, z_in, c, arraySetup, angles)
% PWI_IMAGE Calculates intensity of the PWI-technique at all (x,z) pairs for a multiple-layered material
% INPUT:
    % pwi        = pwi matrix of time domain signals
    % t          = time sequence of fullMat
    % gridx      = positions of the points of interest along the array axis
    % gridz      = positions of the points of interest normal to the array surface
    % c          = sound speed in the media
    % arraySetup = vector of x coordinates of the array elements
    % angles     = vector with all different angels used for transmission
% OUTPUT:
    % intensity  = values of the intensity of the PWI image

c_a = c(1);
c_b = c(2);
gridz = gridz';
trans = length(arraySetup);

intensity = zeros(length(gridz),length(gridx));
x_out = intensity;

x_in = z_in * tan(angles);
betas = asin(c_b/c_a*sin(angles));

for n = 1:length(angles)
    n
    t_in(:,:) = (x_in(n)*sin(angles(n)) + z_in*cos(angles(n)))/c_a + ((gridx - x_in(n))*sin(betas(n)) + (gridz - z_in)*cos(betas(n)))/c_b;
    for m = 1:trans
        xr = arraySetup(m);
        func = @(x,x_p,z_p) c_a/c_b*((x-x_p)*((x-x_p)^2 + (z_p-z_in)^2)^(-1/2)) - (xr-x)*((xr-x)^2 + z_in^2)^(-1/2);
        for l = 1:length(gridx)
            for k = 1:length(gridz)
                x_out(k,l) = fzero(@(x) func(x,gridx(l),gridz(k)), (gridx(l) + xr)/2);
            end
        end
        t_out = sqrt((xr-x_out).^2 + z_in^2)/c_a + sqrt((gridx - x_out).^2 + (z_in - gridz).^2)/c_b;
        time = t_in + t_out;
        signal = permute(pwi(n,m, :), [3 1 2]);
        signal = envelope(signal(:,:));
        I = interp1(t,signal,time);
        intensity = intensity + I;
    end
end
