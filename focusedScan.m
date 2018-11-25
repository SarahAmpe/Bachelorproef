function [intensity] = focusedScan(fullMat,t, x, z, D, c, arrSetup)
% Calculates intensity of the plane B-scan image at (x,z)
% Input fullMat = full matrix of time domain signals
%       t = time sequence of fullMat
%       x = position of the point of interest along the array axis
%       z = position of the point of interest normal to the array surface
%       D = aperture width
%       c = sound speed in the medium
%       arrSetup = vector of x coordinates of the array elements

arrElems = abs(arrSetup - x) <= D/2; % Array elements that matter
subMat = fullMat(arrElems, arrElems, :); % Select the relevant submatrix
arrSetup = arrSetup(arrElems); % Overwrite arrSetup with relevant transducers
intensity = 0;
for transmit = 1:size(subMat, 1)
    for receive = 1:size(subMat, 2)
        xtx = arrSetup(transmit); % Transmitter position
        xrx = arrSetup(receive); % Receiver position
        time = ( sqrt((xtx-x)^2 + z^2) + sqrt((xrx-x)^2 + z^2) )/c;
        [lowerTime,upperTime] = time2(t,time);
        lowerSignal = subMat(transmit, receive, lowerTime);
        upperSignal = subMat(transmit, receive, upperTime);
        signals = (lowerSignal + upperSignal)/2; 
        intensity = intensity + signals;
    end
end

end