%Reshape
%simEdge = reshape(out.edge, [width height])';
%simAngle = double(reshape(out.orientation, [width height])');

%Defined the Sobel kernels
sobelGy = double([-1 -2 -1; 0 0 0; 1 2 1]);
sobelGx = double([-1 0 1; -2 0 2; -1 0 1]);

%Get Directional Gradient 
H = imfilter(double(Y), sobelGx, 'symmetric');
V = imfilter(double(Y), sobelGy, 'symmetric');

%Get Orientation
[angle, mag] = cordiccart2pol(H, V, 12, 'ScaleOutput', true);
magAdjust = floor((round(mag)/4));
edge = zeros(size(mag));
angle = round(rad2deg(angle));

for i = 1:height
    for j = 1:width
        if magAdjust(i, j) >= sobelThreshold
            edge(i, j) = 1;
        end
        if angle(i, j) < 0
            angle(i, j) = angle(i, j) + 180;
        end
        if angle(i, j) == 180
            angle(i, j) = 0;
        end
    end
end



A = reshape(out.simout, [nRho, nTheta]);
hpsThresh = max(A(:))*0.6;
A(A<hpsThresh) = 0;

plot3DHPS(A);
