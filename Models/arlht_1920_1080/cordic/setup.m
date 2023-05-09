% Clear workspace
clc; clear; close all;

fs = 250e6;

% Set parameters
height = 480;
width = 640;
sobelThreshold = 100;

% Read in image and resize
I = imread('chess.jpg');
Ir = imresize(I, [height, width]);

% Get greyscale
Y = rgb2gray(Ir);

% Create input array
inarray = Y;
