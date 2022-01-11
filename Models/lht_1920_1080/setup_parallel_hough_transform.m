% Clear workspace
clc; clear; close all;

% Set parameters
height = 1080;
width = 1920;
sobelThreshold = 30;
dTheta = 1;
dRho = 1;

% Read in image and resize
I = imread('chess.jpg');
Ir = imresize(I, [height, width]);

% Get greyscale
Y = rgb2gray(Ir);

% Get Edge and Gradient Orientation image
[edge] = Sobel(Y, sobelThreshold);

% Create input array
inarray = uint8(fi(edge, 0, 1, 0));

hdlset_param(gcs, 'GenerateValidationModel', 'on');

% Memory
maxRho = ceil(sqrt((height/2)^2+(width/2)^2));
bitsRho = ceil(log2(maxRho*2));