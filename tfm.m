function [intensity] = tfm(fullMat,t,x,z, c, arraySetup)
% TFM Calculates intensity of the Total Focusing Method at (x,z)
% INPUT:
    % fullMat    = full matrix of time domain signals
    % t          = time sequence of fullMat
    % x          = position of the point of interest along the array axis
    % z          = position of the point of interest normal to the array surface
    % c          = sound speed in the medium
    % arraySetup = vector of x coordinates of the array elements
% OUTPUT:
    % intensity = value of the intensity of the TFM image at (x,z)

trans = length(arraySetup);
intensity = 0;
for transmitter = 1:trans
    for receiver = 1:trans
        xtx = arraySetup(transmitter);
        xrx = arraySetup(receiver);
        time = sqrt((xtx-x)^2+z^2) + sqrt((xrx-x)^2+z^2);
        time = time/c;
        [lowerTime,upperTime] = time2(t,time);
        lowerSignal = fullMat(transmitter, receiver, lowerTime);
        upperSignal = fullMat(transmitter, receiver, upperTime);
        signals = (lowerSignal + upperSignal)/2; % Linearly interpolating time
        intensity = intensity + signals;
    end
end
