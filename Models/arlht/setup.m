% Clear workspace
clc; clear; close all;

fs = 250e6;

% Set parameters
height = 512;
width = 512;
sobelThreshold = 30;
theta = (0:1:179);

% Derive variables
maxRho = ceil(sqrt((height/2)^2+(width/2)^2));
nRho = maxRho*2;
nTheta = length(theta);

% Read in image and resize
I = imread('chess.jpg');
Ir = imresize(I, [height, width]);

% Get greyscale
Y = rgb2gray(Ir);

% Get Sobel and Gradient
[edge, dir, mag] = Sobel(Y, 100);
dirNew = floor(dir);
simDirNew = dirNew;
simDirNew(edge==0) = 255;

% Create input array
inarray = uint8(simDirNew);
