%%-------------------------------------------------%
% Author: David Northcote
% Last Updated: 13/07/2020
% Organisation: University of Strathclyde
% Location: Glasgow, Scotland
%

%% Standard LHT
% Clear workspace
clc; clear; close all;

% Set parameters
height = 720;
width = 1280;
sobelThreshold = 60;
dRho = 1;
dTheta = [0.03125, 0.0625, 0.125, 0.25, 0.5, 1, 2, 4, 6, 9, 10, 12, 15];
I = ["wall.jpg", "stairs.jpg", "window.jpg"];
r = zeros(1, numel(dTheta));

% Operate on all each images
for i = 1:numel(I)
    Y = imresize(rgb2gray(imread(I(i))), [height width]);
    for j = 1:numel(dTheta)
        edge = Sobel(Y, sobelThreshold);
        hps = StandardLHT(edge, dTheta(j), dRho);
        r(j) = max(hps(:)) / (sum(hps.*(hps>0), 'all') ./ sum(hps>0, 'all'));
    end
    line(dTheta, r, 'Marker', mark(i), 'Color', colour(i));
    hold on
end

title('Measured PMVR versus \delta_\theta of the HPS')
ylabel('Peak to Mean Vote Ratio (PMVR)')
xlabel('Discretisation Step of \theta (\delta_\theta)')
legend('Wall', 'Stairs', 'Window')