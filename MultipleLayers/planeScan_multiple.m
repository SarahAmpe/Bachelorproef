function [intensity] = planeScan_multiple(fmc, t, x, z, z_in, D, c, arrSetup)
% PLANESCAN Calculates intensity of the plane B-scan image for each point in a grid
% INPUT: 
    % fmc      = full matrix of time domain signals
    % t        = time sequence of fullMat
    % x        = array with positions of the points of interest along the array axis
    % z        = array with positions of the points of interest normal to the array surface
    % z_in     = position of the first interface
    % D        = aperture width
    % c        = sound speed in the medium
    % arrSetup = vector of x coordinates of the array elements
% OUTPUT:
    % intensity = matrix with intensity for each (x,z) position

c_a = c(1);
c_b = c(2);
% Building the intensity matrix columnwise
z_far = z > z_in;
time(z_far) = 2*z_in/c_a + 2*(z(z_far)-z_in)/c_b;
time(not(z_far)) = 2*z(not(z_far))/c_a;
intensity = zeros(length(z), length(x));
for m = 1:length(x)
    arrElems = abs(arrSetup - x(m)) <= D/2; % Array elements that matter
    signal = permute(fmc(arrElems,arrElems,:),[3,1,2]);
    signal = sum(envelope(signal(:,:)),2); % Take the Hilbert transform and sum for each transmitter (?)
    intensity(:,m) = interp1(t,signal,time);
end

end
