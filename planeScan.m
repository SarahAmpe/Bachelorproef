function [intensity] = planeScan(fmc, t, x, z, D, c, arrSetup)
% PLANESCAN Calculates intensity of the plane B-scan image for each point in a grid
% INPUT: 
    % fmc      = full matrix of time domain signals
    % t        = time sequence of fullMat
    % x        = array with positions of the points of interest along the array axis
    % z        = array with positions of the points of interest normal to the array surface
    % D        = aperture width
    % c        = sound speed in the medium
    % arrSetup = vector of x coordinates of the array elements
% OUTPUT:
    % intensity = matrix with intensity for each (x,z) position

% Building the intensity matrix columnwise
time = 2*z/c; % Appropriate times
intensity = zeros(length(z), length(x));
for m = 1:length(x)
    arrElems = abs(arrSetup - x(m)) <= D/2; % Array elements that matter
    signal = permute(fmc(arrElems,arrElems,:),[3,1,2]);
    signal = sum(envelope(signal(:,:)),2); % Take the Hilbert transform and sum for each transmitter (?)
    intensity(:,m) = interp1(t,signal,time);
end

end
