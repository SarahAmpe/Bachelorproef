function [lowerTime,upperTime] = time2(t,time)
% function to lineair interpolate the fmc because this is constructed with
% discrete time intervals and 'time' can be continous. Therefore the upper
% en lwoer discete time value of 'time' is constructed.
% Input t = time sequence of fullMat
%       time = time of flight calculated in the post-processing algoritms

if any(t <= time)
 lowerTime = find(t <= time, 1, 'last');
else
 lowerTime = 1;
end
upperTime = min(lowerTime+1, length(t));
