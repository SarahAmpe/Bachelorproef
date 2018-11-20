function [intensity] = planeScan(fullMat, t, x, z, D, c, arrSetup)
% Calculates intensity of the plane B-scan image at (x,z)
% Input fullMat = full matrix of time domain signals
%       t = time sequence of fullMat
%       x = position of the point of interest along the array axis
%       z = position of the point of interest normal to the array surface
%       D = aperture width
%       c = sound speed in the medium
%       arrSetup = vector of x coordinates of the array elements

arrElems = abs(arrSetup - x) <= D/2; % Array elements that matter
time = 2*z/c; % Appropriate time
%lowerTime = floor(time*100)/100;
%upperTime = ceil(time*100)/100;
%if lowerTime ==0
%    lowerTime = t(1);
%elseif upperTime >= t(end)
%    upperTime = t(end);
%end
if any(t <= time)
    lowerTime = find(t <= time, 1, 'last');
else
    lowerTime = 1;
end
upperTime = min(lowerTime+1, length(t));

lowerSignal = fullMat(arrElems, arrElems, lowerTime);
upperSignal = fullMat(arrElems, arrElems, upperTime);
signals = (lowerSignal + upperSignal)/2; % Linearly interpolating time

intensity = abs(sum(sum(signals)));
end
