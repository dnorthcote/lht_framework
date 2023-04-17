function [rho, theta] = HoughMax(hps, nlines)

%Get the maximum Rho
[maxRho, ~] = size(hps);

%Get the maximum Rho
[Avec, Ind] = sort(hps(:),1,'descend');
linesFound = sum(Avec > 0);
linesExtract = min(linesFound, nlines);
[rhoY, thetaX] = ind2sub(size(hps),Ind(1:linesExtract));

rho = rhoY - maxRho/2;
theta = thetaX - 1;

end
