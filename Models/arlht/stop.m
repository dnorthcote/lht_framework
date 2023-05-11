[hps, Aopt, rbm] = ARLHT(edge, dirNew, dTheta, 1, 0, 4);
%hpsThresh = max(hps(:))*0.6;
%hps(hps<hpsThresh) = 0;
plot3DHPS(hps);

simHps = reshape(out.simout, [nRho, nTheta]);
%simHpsThresh = max(simHps(:))*0.6;
%simHps(simHps<simHpsThresh) = 0;

plot3DHPS(simHps);
