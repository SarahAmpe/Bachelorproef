function [intensity] = tfm(fullMat ,x,z, c, arraySetup)
trans = length(arraySetup);
intensity = 0;
t = randomint(0,5);
for transmitter = 1:trans
    for receiver = 1:trans
        time = sqrt((transmitter-x)^2+z^2) + sqrt((receiver-x)^2+z^2);
        time = time/c;
        intensity = intensity + fullMat(transmitter,receiver,t)*time;
    end
end
intensity = abs(intensity);
        
