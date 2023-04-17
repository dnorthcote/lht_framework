function hps = plot3DHPS( HPS )

[maxRho, maxTheta] = size(HPS);
xSize = floor(-maxRho/2):floor(maxRho/2)-1;
ySize = 1:(maxTheta);
[xx, yy] = meshgrid(ySize, xSize);
figure; hps = mesh(xx, yy, HPS);
xlim([1 maxTheta]);
ylim([floor(-maxRho/2) floor(maxRho/2)]);

end
