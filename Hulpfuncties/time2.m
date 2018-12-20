function [lowerTime,upperTime] = time2(t,time)
% TIME2 Gives the closest values in t to the value 'time'. Used in FMC because
% the full matrix is constructed with discrete time intervals
% INPUT
    % t    = time sequence (of the full matrix)
    % time = time-of-flight calculated in the post-processing algorithms
% OUTPUT
    % lowerTime = highest value of t which is less than time
    % upperTime = lowest value of t which is bigger than time
    
if any(t <= time)
    lowerTime = find(t <= time, 1, 'last');
else
    lowerTime = 1;
end
upperTime = min(lowerTime+1, length(t));

end
