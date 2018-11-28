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

arrCenter = median(arrSetup);
signal = permute(fmc, [3 1 2]);
signal = sum(envelope(signal(:,:)),2); % Take the Hilbert transform and sum it
intensity = zeros(length(z), length(x));
for m = 1:length(x)
    for n = 1:length(z)
        r = sqrt( (x(m) - arrCenter)^2 + z(n)^2 ); % Propagation distances from array center
        th = atan(z(n)/(x(m) - arrCenter)); % Required beam steer angles with respect to the array normal
        time = 2*r + (arrSetup + arrSetup')*sin(th);
        time = time/c;
        intensity(n,m) = sum(sum(interp1(t,signal,time)));
    end
end

end
