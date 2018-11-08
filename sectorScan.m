function [intensity] = sectorScan(fullMat, x, z, c, arrSetup)
% Calculates intensity of the plane B-scan image at (x,z)
% Input fullMat = full matrix of time domain signals
%       x = position of the point of interest along the array axis
%       z = position of the point of interest normal to the array surface
%       c = sound speed in the medium
%       arrSetup = vector of x coordinates of the array elements

arrCenter = median(arrSetup);
r = sqrt( (x - arrCenter)^2 + z^2 ); % Propagation distance from array center
intensity = 0;
for transmit = 1:size(fullMat, 1)
    for receive = 1:size(fullMat, 2)
        th = % Required beam steer angle with respect to the array normal
        xtx = arrSetup(transmit); % Transmitter position
        xrx = arrSetup(receive); % Receiver position
        time = 2*r + (xtx + xrx)*sin(th);
        time = time/c;
        intensity = intensity + fullMat(transmit, receive, time);
    end
end

end