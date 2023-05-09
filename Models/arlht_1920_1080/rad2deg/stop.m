%Reshape
simMag = reshape(out.magnitude, [width height])';
simAngle = reshape(out.orientation, [width height])';

%Defined the Sobel kernels
sobelGy = double([-1 -2 -1; 0 0 0; 1 2 1]);
sobelGx = double([-1 0 1; -2 0 2; -1 0 1]);

%Get Directional Gradient
H = imfilter(double(Y), sobelGx, 'symmetric');
V = imfilter(double(Y), sobelGy, 'symmetric');

%Get Orientation
[angle, mag] = cordiccart2pol(H, V, 12, 'ScaleOutput', true);
angle = round(180*angle/pi);

%Get difference
fprintf('Difference between software and simulation is (mag): %f\r\n', ...
    max(abs(simMag(:)-mag(:))));
fprintf('Difference between software and simulation is (angle): %f\r\n', ...
    max(abs(simAngle(:)-angle(:))));