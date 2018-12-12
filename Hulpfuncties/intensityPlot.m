function intensityPlot(x,z,xx,zz,intensityMat,plotTitle,fileName)
%INTENSITYPLOT Makes a detailed intensity plot of the 4 scanning methods
%INPUT
    % x         = Grid x-coordinates
    % z         = Grid z-coordinates
    % xx        = Defect x-coordinates
    % zz        = Defect z-coordinates
    % I         = matrix with intensity at each point
    % plotTitle = title to be displayed above figure
    % fileName  = what name to give the plot

figure
imagesc(x,z,intensityMat)
title(plotTitle)
hold on
%plot(xx,zz,'k.') % Defect locations
xlabel('x-coordinate in mm')
ylabel('z-coordinate in mm')
cb = colorbar;
cb.Label.String = 'Intensity of the wave in the receiving transducers';
saveas(gcf, fileName)

end
