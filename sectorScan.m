function [intensity] = sectorScan(fmc, t, x, z, c, arrSetup)
% SECTORSCAN Calculates intensity of the plane B-scan image for each point in a grid
% INPUT: 
    % fmc      = full matrix of time domain signals
    % t        = time sequence of fullMat
    % x        = array with positions of the points of interest along the array axis
    % z        = array with positions of the points of interest normal to the array surface
    % c        = sound speed in the medium
    % arrSetup = vector of x coordinates of the array elements
% OUTPUT:
    % intensity = matrix with intensity for each (x,z) position

% arrCenter = median(arrSetup);
% fmc = permute(fmc, [3 1 2]); % LET OP FMC IS PERMUTED
% intensity = zeros(length(z), length(x));
% r = sqrt( (x - arrCenter).^2 + z'.^2 ); % Matrix with propagation distances from array center
% th = atan(z'./(x - arrCenter)); % Matrix with beam steer angles (with respect to array normal)
% for m = 1:length(x)
%     for n = 1:length(z)
%         time = 2*r(m,n) + (arrSetup + arrSetup')*sin(th(m,n));
%         time = time/c;
%         for transmit = 1:length(arrSetup)
%             for receive = 1:length(arrSetup)
%                 signal = envelope(fmc(:,transmit,receive)); % Let op, fmc is permuted
%                 signal = interp1(t,signal,time(transmit,receive));
%                 intensity(n,m) = intensity(n,m) + signal;
%             end
%         end
%     end
% end

fmc = permute(fmc, [3 1 2]); % LET OP FMC IS PERMUTED
intensity = zeros(length(z), length(x));
r = sqrt((x).^2 + z'.^2); % Matrix with propagation distances from array center
for transmit = 1:length(arrSetup)
    for receive = 1:length(arrSetup)
        time = (2*r + (arrSetup(transmit) + arrSetup(receive)).*(x./r))/c;
        signal = envelope(fmc(:,transmit,receive)); % Let op, fmc is permuted
        I = interp1(t,signal,time);
        intensity = intensity + I;
    end
end

end
