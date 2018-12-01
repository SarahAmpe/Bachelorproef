function [intensity] = tfm_multiple(fullMat,t,xref,zref,z_in, c_a, c_b, arraySetup)
% TFM_MULTIPLE Calculates intensity of the Total Focusing Method at (x,z) for a multiple-layered material
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
        xt = arraySetup(transmitter);
        xr = arraySetup(receiver);
        
        func = @(x) c_b/c_a*((x-xt)*((x-xt)^2 + z_in^2)^(-1/2)) - (xref - x)*((xref -x)^2 + (zref-z_in)^2)^(-1/2);
        x_in = fzero(func, (xt + xref)/2); %Position where ingoing wave transits into the other material 

        func = @(x) c_a/c_b*((x-xref)*((x-xref)^2 + (zref-z_in)^2)^(-1/2)) - (xr-x)*((xr-x)^2 + z_in^2)^(-1/2);
        x_out = fzero(func, (xr + xref)/2); %Position where outgoing wave transits into the other material 
        
        timeIn = sqrt((xt-x_in)^2 + z_in^2)/c_a + sqrt((xref - x_in)^2 + (z_in - zref)^2)/c_b;
        timeOut = sqrt((xr-x_out)^2 + z_in^2)/c_a + sqrt((xref - x_out)^2 + (z_in - zref)^2)/c_b;
        time = timeIn + timeOut;
        
        signal = permute(fullMat(transmitter, receiver, :), [3 1 2]);
        signal = envelope(signal(:,:));
        I = interp1(t,signal,time); % Linearly interpolating time
        intensity = intensity + I;
    end
end

% trans = length(arraySetup);
% intensity = zeros(length(zref),length(xref));
% x_in = intensity;
% x_out = x_in;
% 
% for transmitter = 1:trans
%     transmitter
%     for receiver = 1:trans
%         xt = arraySetup(transmitter);
%         xr = arraySetup(receiver);
%         
%         func_in = @(x,x_p,z_p) c_b/c_a*((x-xt)*((x-xt)^2 + z_in^2)^(-1/2)) - (x_p - x)*((x_p -x)^2 + (z_p-z_in)^2)^(-1/2);
%         func_out = @(x,x_p,z_p) c_a/c_b*((x-x_p)*((x-x_p)^2 + (z_p-z_in)^2)^(-1/2)) - (xr-x)*((xr-x)^2 + z_in^2)^(-1/2);
%         
%         for m = 1:length(xref)
%             for n = 1:length(zref)
%                 x_in(n,m) = fzero(@(x) func_in(x,xref(m),zref(n)), (xt + xref(m))/2); 
%                 x_out(n,m) = fzero(@(x) func_out(x,xref(m),zref(n)), (xr + xref(n))/2); 
%             end
%         end
%         timeIn = sqrt((xt-x_in).^2 + z_in^2)/c_a + sqrt((xref - x_in).^2 + (z_in - zref).^2)/c_b;
%         timeOut = sqrt((xr-x_out).^2 + z_in^2)/c_a + sqrt((xref - x_out).^2 + (z_in - zref).^2)/c_b;
%         time = timeIn + timeOut;
%         
%         signal = permute(fullMat(transmitter, receiver, :), [3 1 2]);
%         signal = envelope(signal(:,:));
%         I = interp1(t,signal,time); % Linearly interpolating time
%         intensity = intensity + I;
%     end
% end