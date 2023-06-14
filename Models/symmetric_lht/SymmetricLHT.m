function [hps] = SymmetricLHT(edge)
%SymmetricLHT is a resource-efficient implementation of the Standard LHT.
%   The Standard Line Hough Transform (LHT) as defined by Duda & Hart [1],
%   is applied to binary edge images using this function. The Symmetric LHT
%   is a resource-efficient implementation of the Standard LHT. It exploits
%   spatial domain symmetry to reduce computation and memory consumption of
%   the Hough Parameter Space (HPS) in FPGA devices. The HPS is produced by
%   applying the analytical function for lines as described in [1]. The HPS
%   is returned as a double precision array.
%
%   [1]  -  R. O. Duda, P. E. Hart, "Use of the Hough transformation to 
%           detect lines and curves in pictures", Commun. ACM, vol. 15,
%           no. 1, pp. 11-15, Jan. 1972.
%

%Check arguments (no dRho as hardware model is dRho=1 for rounding)
switch nargin
    case 0
        error('Not enough input arguments.');
    case 1
        % Do Nothing
    otherwise
        error('Error occurred.');
end

%Get the dimensions of the input image.
[height, width] = size(edge);

%Get the maximum Rho
maxRho = ceil(sqrt((height/2)^2+(width/2)^2));

%Get theta
theta = 0:1:179;

% Initialise quantised cos & sin
cosQ = double(fi(cos(deg2rad(theta)), 1, 16, 14));
sinQ = double(fi(sin(deg2rad(theta)), 1, 16, 14));

%Get HPS dimensions
[~, m] = size(theta);
n = maxRho*2;

%Initialise the Accumulator array (A)
A = zeros(n, m);

% Setup x and y coordinates
xco = [-(width/2:-1:1), (1:1:width/2)];
yco = [-(height/2:-1:1), (1:1:height/2)];

%Get HPS by iterating through the binary edge image and operating on
%feature points.
for y = 1:height
    for x = 1:width
        
        % Iterate over binary edge pixels
        if edge(y,x) > 0
            
            % Adjust Cartesian Positions
            xTemp = xco(x);
            yTemp = yco(y);
                 
            % Get Hough Parameters
            rho = round(round(xTemp*cosQ) + round(yTemp*sinQ)) + maxRho;
            
            % Apply votes to HPS
            for i = 1:m
                A(rho(1,i), i) = A(rho(1,i), i) + 1;
            end
        end
    end
end

%Assign the accumulator array to the HPS output array
hps = A;

end