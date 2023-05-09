%Reshape
simEdge = reshape(out.edge, [width height])';
simAngle = double(reshape(out.orientation, [width height])');

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
angle = rad2deg(angle);

for i = 1:height
    for j = 1:width
        if magAdjust(i, j) >= sobelThreshold
            edge(i, j) = 1;
        end
        if angle(i, j) < 0
            angle(i, j) = floor(angle(i, j) + 180);
        else
            angle(i, j) = floor(angle(i, j));
        end
        if angle(i, j) == 180
            angle(i, j) = 179;
        end
    end
end

%Get difference
fprintf('Difference between software and simulation is (edge): %f\r\n', ...
    max(abs(simEdge(:)-edge(:))));
fprintf('Difference between software and simulation is (angle): %f\r\n', ...
    max(abs(simAngle(:)-angle(:))));
