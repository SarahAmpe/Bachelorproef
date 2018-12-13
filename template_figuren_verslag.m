x = linspace(-10.08, 10.08, 64);
z = linspace(5, 6, 64);

imagesc(x,z,I)
imagesc(x,z(z>5.2),I(z>5.2,:));
imagesc(x,z(z>5.25 & z<5.8),I(z>5.25 & z<5.75,:));

surf(x,z,I)
surf(x,z(z>5.2),I(z>5.2,:));
surf(x,z(z>5.25 & z<5.75),I(z>5.25 & z<5.75,:));

title('')
xlabel('x-coordinate in mm')
ylabel('z-coordinate in mm')