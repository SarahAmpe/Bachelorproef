function [intensity] = tfm(fullMat ,x,z, c, arraySetup)
% Calculates intensity of the Total Focusing Method at (x,z)
% Input fullMat = full matrix of time domain signals
%       x = position of the point of interest along the array axis
%       z = position of the point of interest normal to the array surface
%       c = sound speed in the medium
%       arraySetup = vector of x coordinates of the array elements

trans = length(arraySetup);
intensity = 0;
t = 2;
for transmitter = 1:trans
    for receiver = 1:trans
        xtx = arraySetup(transmitter);
        xrx = arraySetup(receiver);
        time = sqrt((xtx-x)^2+z^2) + sqrt((xrx-x)^2+z^2);
        time = time/c;
        intensity = intensity + fullMat(transmitter,receiver,t)*time;
    end
end
intensity = abs(intensity);
        
end
