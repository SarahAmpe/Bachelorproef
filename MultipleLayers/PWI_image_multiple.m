function intensity = PWI_image_multiple(pwi,t,gridx,gridz,z_in,c,arraySetup,angles)
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

gridz = gridz';
trans = length(arraySetup);
intensity = zeros(length(gridz),length(gridx));
x_in = intensity;
x_out = x_in;
timeIn = x_out;
timeOut = timeIn;
time = timeOut;

c_a = c(1);
c_b = c(2);
betas = asin(c_b/c_a*sin(angles));

for m = 1:trans
    xr = arraySetup(m);
    func_out = @(x,x_p,z_p) c_a/c_b*((x-x_p)*((x-x_p)^2 + (z_p-z_in)^2)^(-1/2)) - (xr-x)*((xr-x)^2 + z_in^2)^(-1/2);
    for n = 1:length(angles)
        for l = 1:length(gridz)
            if gridz(l) > z_in
                timeIn(l,:) = z_in/cos(angles(n))/c_a + (gridz(l) - z_in)/cos(betas(n))/c_b ;
                for k = 1:length(gridx)
                    x_out(l,k) = fzero(@(x) func_out(x,gridx(k),gridz(l)), (xr + gridx(k))/2); 
                end
                timeOut(l,:) = sqrt((gridx-x_out(l,:)).^2 + (z_in-gridz(l)).^2)/c_b + sqrt((x_out(l,:)-xr).^2 + (z_in).^2)/c_a;
                time(l,:) = timeIn(l,:) + timeOut(l,:);
            else
                time(l,:) = (gridz(l)/cos(angles(n)) + sqrt((gridx-xr).^2 + (gridz(l)).^2))/c_a;
            end
        end
        signal = permute(pwi(n,m, :), [3 1 2]);
        signal = envelope(signal(:,:));
        I = interp1(t,signal,time);
        intensity = intensity + I;
    end
end
% (gridx*sin(angles(n)) + gridz*cos(angles(n)))/c
% sqrt(gridx.^2 + gridz.^2)/c
