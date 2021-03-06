function [intensity] = focusedScan(fmc, t, x, z, D, c, arrSetup)
% FOCUSEDSCAN Calculates intensity of the focused B-scan image for each point in a grid
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

intensity = zeros(length(z), length(x));
z = z';
for m = 1:length(x)
    arrElems = abs(arrSetup - x(m)) <= D/2; % Array elements that matter
    subMat = fmc(arrElems, arrElems, :); % Select the relevant submatrix
    subSetup = arrSetup(arrElems); % Overwrite arrSetup with relevant transducers
    for transmit = 1:size(subMat, 1)
        for receive = 1:size(subMat, 2)
            xtx = subSetup(transmit); % Transmitter position
            xrx = subSetup(receive); % Receiver position
            time = (sqrt((xtx-x(m))^2 + z.^2) + sqrt((xrx-x(m))^2 + z.^2))./c;
            signal = permute(subMat(transmit, receive, :), [3 1 2]);
            signal = envelope(signal); % Hilbert transform
            I = interp1(t,signal,time);
            intensity(:,m) = intensity(:,m) + I;
        end
    end
end

end
