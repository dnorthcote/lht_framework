%Reshape
simH = reshape(out.gradH, [width height])';
simV = reshape(out.gradV, [width height])';

%Defined the Sobel kernels
sobelGy = double([-1 -2 -1; 0 0 0; 1 2 1]);
sobelGx = double([-1 0 1; -2 0 2; -1 0 1]);

%Get Directioin Gradient
H = imfilter(double(Y), sobelGx, 'symmetric');
V = imfilter(double(Y), sobelGy, 'symmetric');

%Get difference
fprintf('Difference between software and simulation is (H): %f\r\n', ...
    max(abs(simH(:)-H(:))));
fprintf('Difference between software and simulation is (V): %f\r\n', ...
    max(abs(simV(:)-V(:))));
