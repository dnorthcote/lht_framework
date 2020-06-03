% Clear workspace
clc; clear; close all;

% Set parameters
height = 720;
width = 1280;
sobelThreshold = 30;
dTheta = 1;
dRho = 1;

% Read in image and resize
I = imread('dirtyroof.bmp');
Ir = imresize(I, [height, width]);

% Get greyscale
Y = rgb2gray(Ir);

% Get Edge and Gradient Orientation image
[edge] = Sobel(Y, sobelThreshold);

% Create input array
inarray = uint8(fi(edge, 0, 1, 0));

hdlset_param(gcs, 'GenerateValidationModel', 'on');