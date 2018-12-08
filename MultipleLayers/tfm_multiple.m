function [intensity] = tfm_multiple(fullMat,t,gridx,gridz,z_in, c, arraySetup)
% TFM_MULTIPLE Calculates intensity of the Total Focusing Method at all (x,z) pairs for a multiple-layered material
% INPUT:
    % fullMat    = full matrix of time domain signals
    % t          = time sequence of fullMat
    % gridx      = positions of the points of interest along the array axis
    % gridz      = positions of the points of interest normal to the array surface
    % c          = sound speed in the media
    % arraySetup = vector of x coordinates of the array elements
% OUTPUT:
    % intensity = values of the intensity of the TFM image
    
c_a = c(1);
c_b = c(2);
trans = length(arraySetup);
intensity = zeros(length(gridz),length(gridx));
x_in = intensity;
x_out = x_in;
timeIn = x_out;
timeOut = timeIn;
time = timeOut;

for transmitter = 1:trans
    xt = arraySetup(transmitter);
    func_in = @(x,x_p,z_p) c_b/c_a*((x-xt)*((x-xt)^2 + z_in^2)^(-1/2)) - (x_p - x)*((x_p -x)^2 + (z_p-z_in)^2)^(-1/2);
 
    for receiver = 1:trans
        xr = arraySetup(receiver);
        func_out = @(x,x_p,z_p) c_a/c_b*((x-x_p)*((x-x_p)^2 + (z_p-z_in)^2)^(-1/2)) - (xr-x)*((xr-x)^2 + z_in^2)^(-1/2);
        for n = 1:length(gridz)
            if gridz(n) > z_in
                for m = 1:length(gridx)
                    x_in(n,m) = fzero(@(x) func_in(x,gridx(m),gridz(n)), (xt + gridx(m))/2); 
                    x_out(n,m) = fzero(@(x) func_out(x,gridx(m),gridz(n)), (xr + gridx(m))/2); 
                end     

                timeIn(n,:) = sqrt((xt-x_in(n,:)).^2 + z_in^2)/c_a + sqrt((gridx - x_in(n,:)).^2 + (z_in - gridz(n)).^2)/c_b;
                timeOut(n,:) = sqrt((xr-x_out(n,:)).^2 + z_in^2)/c_a + sqrt((gridx - x_out(n,:)).^2 + (z_in - gridz(n)).^2)/c_b;
                time(n,:) = timeIn(n,:) + timeOut(n,:);
            else
                time(n,:) = ( sqrt((xt-gridx).^2 + gridz(n).^2) + sqrt((xr-gridx).^2 + gridz(n).^2) )/c_a;
            end
        end
        signal = permute(fullMat(transmitter, receiver, :), [3 1 2]);
        signal = envelope(signal(:,:));
        I = interp1(t,signal,time); % Linearly interpolating time
        intensity = intensity + I;
    end
end
