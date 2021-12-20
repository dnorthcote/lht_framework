%Get theta and rho
theta = 0:dTheta:180-dTheta;

A = reshape(out.simout, [maxRho*2, numel(theta)]);

plot3DHPS(A);