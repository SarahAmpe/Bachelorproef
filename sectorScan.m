function [intensity] = sectorScan(fullMat,t, x, z, c, arrSetup)
% Calculates intensity of the plane B-scan image at (x,z)
% Input fullMat = full matrix of time domain signals
%       t = time sequence of fullMat
%       x = position of the point of interest along the array axis
%       z = position of the point of interest normal to the array surface
%       c = sound speed in the medium
%       arrSetup = vector of x coordinates of the array elements

arrCenter = median(arrSetup);
r = sqrt( (x - arrCenter)^2 + z^2 ); % Propagation distance from array center
intensity = 0;
for transmit = 1:size(fullMat, 1)
    for receive = 1:size(fullMat, 2)
        th = atan(z/x); % Required beam steer angle with respect to the array normal
        xtx = arrSetup(transmit); % Transmitter position
        xrx = arrSetup(receive); % Receiver position
        time = 2*r + (xtx + xrx)*sin(th); 
        time = time/c;
        lowerTime = floor(time*100)/100;
        upperTime = ceil(time*100)/100;
        if lowerTime ==0
            lowerTime = t(1);
        elseif upperTime >= t(end)
            upperTime = t(end);
        end
        intensity = intensity + (fullMat(transmit, receive, round(lowerTime*100))+ fullMat(transmit, receive, round(upperTime*100)))/2;
    end
end

