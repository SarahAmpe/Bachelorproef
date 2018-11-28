function [intensity] = tfm(fullMat,t,x,z, c, arraySetup)
% Calculates intensity of the Total Focusing Method at (x,z)
% Input fullMat = full matrix of time domain signals
%       t = time sequence of fullMat
%       x = positions of the point of interest along the array axis
%       z = positions of the point of interest normal to the array surface
%       c = sound speed in the medium
%       arraySetup = vector of x coordinates of the array elements

I = zeros(length(z),length(x));
for n = 1:length(z)
    for m = 1:length(x)
        xtx = arraySetup;
        xrx = xtx';
        time = sqrt((xtx-x(m)).^2+z(n)^2) + sqrt((xrx-x(m)).^2+z(n)^2);
        time = time/c;
        signal = permute(fullMat,[3,1,2]);
        signal = envelope(signal(:,:));
        S = interp1(t,signal,time);
        S = reshape(S,length(arraySetup),[]);
        A = S(:,1:length(arraySetup)+1:end);
        I(n,m) = sum(sum(A));
    end
end
intensity = I;