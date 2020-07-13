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
height = 480;
width = 640;
sobelThreshold = 60;
dRho = 1;
dTheta = [1, 2];
I = imread('dirtyroof.bmp');
Y = imresize(rgb2gray(I), [height width]);
edge = Sobel(Y, sobelThreshold);
r = zeros(1, numel(dTheta));
m = zeros(1, numel(dTheta));
n = zeros(1, numel(dTheta));

mark = ['*', 's', 'd'];
colour = ["blue", "magenta", "red"];

% Operate on all each images
for i = 1:numel(dTheta)
    hps = StandardLHT(edge, dTheta(i), dRho);
    m(i) = max(hps(:));
    n(i) = sum(hps.*(hps>0), 'all') ./ sum(hps>0, 'all');
    r(i) = m(i) / n(i);
    plot3DHPS(hps);
    title(['Hough Parameter Space (\delta_\theta = ', int2str(dTheta(i)), '^\circ)']);
    ylabel('Votes')
    xlabel('Orientation (\theta)')
end