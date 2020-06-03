function plot3DHPS( HPS )

[maxRho, maxTheta] = size(HPS);
xSize = 1:(maxRho);
ySize = 1:(maxTheta);
[xx, yy] = meshgrid(ySize, xSize);
figure; mesh(xx, yy, HPS);

end

