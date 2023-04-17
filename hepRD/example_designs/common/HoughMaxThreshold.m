function [rho, theta] = HoughMaxThreshold(hps, threshold)

%Get the maximum Rho
[maxRho, ~] = size(hps);

%Get the indices of the maximum peaks in the HPS
[rhoY, thetaX] = ind2sub(size(hps), find((hps >= threshold)));

rho = rhoY - maxRho/2;
theta = thetaX - 1;

end

