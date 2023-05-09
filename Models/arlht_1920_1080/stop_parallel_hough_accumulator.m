% Reshape
sim = reshape(out.imageout, [width height])';

%Defined Threshold
T = 100;

%Defined the Sobel kernels
sobelGy = double([-1 -2 -1; 0 0 0; 1 2 1]);
sobelGx = double([-1 0 1; -2 0 2; -1 0 1]);

%Get Gradient and Orientation
Gx = imfilter(double(Y), sobelGx, 'symmetric');
Gy = imfilter(double(Y), sobelGy, 'symmetric');

[dir, mag] = cordiccart2pol(Gx, Gy, 9, 'ScaleOutput', true);

dir = double(rad2deg(dir));

%Get edge image and correct orientation
for i = 1:height
    for j = 1:width
        if dir(i,j) < 0
            dir(i,j) = dir(i,j) + 180;
        end
    end
end

dir = uint8(dir);

for i = 1:height
    for j = 1:width
        if dir(i,j) == 180
            dir(i,j) = 0;
        end
    end
end

imtool(dir, [min(dir(:)), max(dir(:))])
imtool(sim, [min(sim(:)), max(sim(:))])
% %Get theta and rho
% A = reshape(out.simout, [Nrho, Ntheta]);
% hpsThresh = max(A(:))*0.6;
% A(A<hpsThresh) = 0;
% 
% plot3DHPS(A);