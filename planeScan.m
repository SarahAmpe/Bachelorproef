function [intensity] = planeScan(fullMat, sampleTimes, x, z, D, c, arrSetup)
% PLANESCAN Calculates intensity of the plane B-scan image at (x,z)
%
% INPUT: 
% fullMat     = full matrix of time domain signals
% sampleTimes = time sequence of fullMat
% x           = position of the point of interest along the array axis
% z           = position of the point of interest normal to the array surface
% D           = aperture width
% c           = sound speed in the medium
% arrSetup    = vector of x coordinates of the array elements

arrElems = abs(arrSetup - x) <= D/2; % Array elements that matter
time = 2*z/c; % Appropriate time
[lowerTime,upperTime] = time2(t,time);
lowerSignal = fullMat(arrElems, arrElems, lowerTime);
upperSignal = fullMat(arrElems, arrElems, upperTime);
signals = (lowerSignal + upperSignal)/2; % Linearly interpolating time

intensity = abs(sum(sum(signals)));
end
