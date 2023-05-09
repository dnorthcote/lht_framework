% Clear workspace
clc; clear; close all;

fs = 250e6;

% Set parameters
height = 480;
width = 640;
sobelThreshold = 100;
dTheta = 1;
dRho = 1;
Ntheta = 180;
theta = (0:dTheta:(Ntheta-1)*dTheta);

% Read in image and resize
I = imread('chess.jpg');
Ir = imresize(I, [height, width]);

% Get greyscale
Y = rgb2gray(Ir);

% Get Edge and Gradient Orientation image
[edge] = Sobel(Y, sobelThreshold);

% Create input array
inarray = Y;

%hdlset_param(gcs, 'GenerateValidationModel', 'on');

% Memory
maxRho = ceil(sqrt((height/2)^2+(width/2)^2));
Nrho = maxRho*2/dRho;
bitsRho = ceil(log2(maxRho*2));

% ARLHT
Ktheta = 4;
gamma = (theta(end)+dTheta)/Ktheta;