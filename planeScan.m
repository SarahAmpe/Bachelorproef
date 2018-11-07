function [intensity] = planeScan(fullMat, x, z, D, c, arrSetup)
% Calculates intensity of the plane B-scan image at (x,z)
% Input fullMat = full matrix of time domain signals
%       x = position of the point of interest along the array axis
%       z = position of the point of interest normal to the array surface
%       D = aperture width
%       c = sound speed in the medium
%       arrSetup = vector of x coordinates of the array elements

arrElems = abs(arrSetup - x) <= D/2; % Array elements that matter
time = 2*z/c; % Appropriate time
signals = fullMat(arrElems, arrElems, time); % Signals that matter
intensity = sum(sum(signals));
end
