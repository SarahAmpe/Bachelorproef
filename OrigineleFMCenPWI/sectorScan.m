function [intensity] = sectorScan(fmc, t, x, z, c, arrSetup)
% SECTORSCAN Calculates intensity of the sector scan image for each point in a grid
% INPUT: 
    % fmc      = full matrix of time domain signals
    % t        = time sequence of fullMat
    % x        = array with positions of the points of interest along the array axis
    % z        = array with positions of the points of interest normal to the array surface
    % c        = sound speed in the medium
    % arrSetup = vector of x coordinates of the array elements
% OUTPUT:
    % intensity = matrix with intensity for each (x,z) position

intensity = zeros(length(z), length(x));
r = sqrt((x).^2 + z'.^2); % Matrix with propagation distances from array center
st = x./r;
for transmit = 1:size(fmc,1)
    for receive = 1:size(fmc,2)
        xtx = arrSetup(transmit);
        xrx = arrSetup(receive);
        time = 2.*r + st.*xtx + st.*xrx;
        time = time./c;
        signal = permute(fmc(transmit, receive, :), [3 1 2]);
        signal = envelope(signal);
        I = interp1(t,signal,time);
        intensity = intensity + I;
    end
end

end
