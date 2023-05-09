% Clear workspace
clc; clear; close all;

fs = 250e6;

% Set parameters
height = 480;
width = 640;
sobelThreshold = 30;
theta = (0:1:179);
maxRho = ceil(sqrt((height/2)^2+(width/2)^2));
nRho = maxRho*2;
nTheta = length(theta);

% Read in image and resize
I = imread('chess.jpg');
Ir = imresize(I, [height, width]);

% Get greyscale
Y = rgb2gray(Ir);

% Create input array
inarray = Y;
