function [intensity] = tfm_multiple(fullMat,t,xref,zref,z_in, c_a, c_b, arraySetup)
% Calculates intensity of the Total Focusing Method at (x,z)
% Input fullMat = full matrix of time domain signals
%       t = time sequence of fullMat
%       x = position of the point of interest along the array axis
%       z = position of the point of interest normal to the array surface
%       c = sound speed in the medium
%       arraySetup = vector of x coordinates of the array elements

trans = length(arraySetup);
intensity = 0;
for transmitter = 1:trans
    for receiver = 1:trans
        xt = arraySetup(transmitter);
        xr = arraySetup(receiver);
        
        func = @(x) c_b/c_a*((x-xt)*((x-xt)^2 + z_in^2)^(-1/2)) - (xref - x)*((xref -x)^2 + (zref-z_in)^2)^(-1/2);
        x_in = fzero(func, (xt + xref)/2); %Position where ingoing wave transits into the other material 

        func = @(x) c_a/c_b*((x-xref)*((x-xref)^2 + (zref-z_in)^2)^(-1/2)) - (xr-x)*((xr-x)^2 + z_in^2)^(-1/2);
        x_out = fzero(func, (xr + xref)/2); %Position where outgoing wave transits into the other material 
        
        timeIn = sqrt((xt-x_in)^2 + z_in^2)/c_a + sqrt((xref - x_in)^2 + (z_in - zref)^2)/c_b;
        timeOut = sqrt((xr-x_out)^2 + z_in^2)/c_a + sqrt((xref - x_out)^2 + (z_in - zref)^2)/c_b;
        time = timeIn + timeOut;
        
        [lowerTime,upperTime] = time2(t,time);
        lowerSignal = fullMat(transmitter, receiver, lowerTime);
        upperSignal = fullMat(transmitter, receiver, upperTime);
        signals = (lowerSignal + upperSignal)/2; % Linearly interpolating time
        intensity = intensity + signals;
    end
end
