function [edge, Gdir, Gmag] = Sobel(Y, T)
%Sobel Applies Sobel operators and obtains the gradient images
%   Applies Sobel operators and obtains the gradient magnitude and
%   orientation arrays. The edge array is derived by thresholding the
%   gradient magnitude. Results are given as doubles.

%Defined the Sobel kernels
sobelGy = [1 2 1; 0 0 0; -1 -2 -1];
sobelGx = [1 0 -1; 2 0 -2; 1 0 -1];

%Get the image height and width
[height, width] = size(Y);

%Initialise the edge image
edge = zeros(size(Y));

%Get Gradient and Orientation
Gx = (imfilter(double(Y), sobelGx, 'symmetric'));
Gy = (imfilter(double(Y), sobelGy, 'symmetric'));
mag = sqrt(double(Gx.^2 + Gy.^2));
dir = rad2deg(atan(Gy./Gx));

%Get edge image and correct orientation
for i = 1:height
    for j = 1:width
        mag(i,j) = mag(i,j)*2^(-2);
        % Compare with the threshold and derive the edge image
        if mag(i,j) >= T
            edge(i,j) = 1;
        else
            edge(i,j) = 0;
        end
        
        % Correct the orientation
        if dir(i,j) < 0
            dir(i,j) = dir(i,j) + 180;
        end
        
    end
end

% Set NAN to Zero
dir(isnan(dir))=0;

%% Assign outputs
Gmag = double(mag);
Gdir = double(dir);
edge = double(edge);

end

