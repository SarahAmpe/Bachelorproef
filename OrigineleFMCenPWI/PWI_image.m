function intensity = PWI_image(pwi,t, gridx, gridz, c, arraySetup, angles)
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

for n = 1:length(angles)
    for m = 1:trans
        xr = arraySetup(m);
        time =  sqrt((gridx).^2 + gridz.^2)/c + sqrt((gridx-xr).^2 + (gridz).^2)/c;
        signal = permute(pwi(n,m, :), [3 1 2]);
        signal = envelope(signal(:,:));
        I = interp1(t,signal,time);
        intensity = intensity + I;
    end
end

