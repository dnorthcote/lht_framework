%Defined Threshold
T = 100;

%Defined the Sobel kernels
sobelGy = double([1 2 1; 0 0 0; -1 -2 -1]);
sobelGx = double([1 0 -1; 2 0 -2; 1 0 -1]);

%Get the image height and width
[height, width] = size(Y);

%Initialise the edge image
edge = zeros(size(Y));

%Get Gradient and Orientation
Gx = imfilter(double(Y), sobelGx, 'symmetric');
Gy = imfilter(double(Y), sobelGy, 'symmetric');
[~, mag] = cordiccart2pol(Gx, Gy, 9, 'ScaleOutput', true);
magscaled = mag./4;

%Get edge image and correct orientation
% for i = 1:height
%     for j = 1:width
%         mag(i,j) = mag(i,j)/4;
%         % Compare with the threshold and derive the edge image
%         if mag(i,j) >= T
%             edge(i,j) = 1;
%         else
%             edge(i,j) = 0;
%         end        
%     end
% end

A = double(reshape(out.simout, [width, height])');
diff = abs(A-magscaled);
