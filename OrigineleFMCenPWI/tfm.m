function [intensity] = tfm(fullMat,t,x,z, c, arraySetup)
% TFM Calculates intensity of the Total Focusing Method
% INPUT:
    % fullMat    = full matrix of time domain signals
    % t          = time sequence of fullMat
    % x          = positions of the point of interest along the array axis
    % z          = positions of the point of interest normal to the array surface
    % c          = sound speed in the medium
    % arraySetup = vector of x coordinates of the array elements
% OUTPUT:
    % intensity = value of the intensity of the TFM image at (x,z)

intensity = zeros(length(z), length(x));
z = z';
for transmit = 1:size(fullMat, 1)
    for receive = 1:size(fullMat, 2)
        xtx = arraySetup(transmit); % Transmitter position
        xrx = arraySetup(receive); % Receiver position
        time = ( sqrt((xtx-x).^2 + z.^2) + sqrt((xrx-x).^2 + z.^2) )/c;
        signal = permute(fullMat(transmit, receive, :), [3 1 2]);
        signal = envelope(signal);
        I = interp1(t,signal,time);
        intensity = intensity + I;
    end
end

end
