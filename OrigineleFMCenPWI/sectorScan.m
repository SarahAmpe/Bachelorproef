function [intensity] = sectorScan(fmc, t, x, z, c, arrSetup)
% SECTORSCAN Calculates intensity of the plane B-scan image for each point in a grid
% INPUT: 
    % fmc      = full matrix of time domain signals
    % t        = time sequence of fullMat
    % x        = array with positions of the points of interest along the array axis
    % z        = array with positions of the points of interest normal to the array surface
    % c        = sound speed in the medium
    % arrSetup = vector of x coordinates of the array elements
% OUTPUT:
    % intensity = matrix with intensity for each (x,z) position

fmc = permute(fmc, [3 1 2]);
intensity = zeros(length(z), length(x));
r = sqrt((x).^2 + z'.^2); % Matrix with propagation distances from array center
st = x./r;
for transmit = 1:length(arrSetup)
    for receive = 1:length(arrSetup)
        xtx = arrSetup(transmit);
        xrx = arrSetup(receive);
        time =        sqrt(r.^2 + xtx^2 - 2*xtx*r.*st);
        time = time + sqrt(r.^2 + xrx^2 - 2*xrx*r.*st);
        time = time/c;
        signal = envelope(fmc(:,transmit,receive));
        I = interp1(t,signal,time);
        intensity = intensity + I;
    end
end

end
