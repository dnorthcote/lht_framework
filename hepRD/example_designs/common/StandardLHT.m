function [hps] = StandardLHT(edge, dTheta, dRho)
%StandardLHT Applies the Standard Line Hough Transform to binary images.
%   The Standard Line Hough Transform (LHT) as defined by Duda & Hart [1],
%   is applied to binary edge images using this function. The
%   discretisation step of theta and rho are set using the respective
%   arguments. The Hough Parameter Space (HPS) is produced by applying the
%   analytical function for lines as described in [1]. The HPS is returned
%   as a double precision array.
%
%   [1]  -  R. O. Duda, P. E. Hart, "Use of the Hough transformation to 
%           detect lines and curves in pictures", Commun. ACM, vol. 15,
%           no. 1, pp. 11-15, Jan. 1972.

%Check arguments
switch nargin
    case 0
        error('Not enough input arguments.');
    case 1
        dTheta = 1;
        dRho = 1;
    case 2
        dRho = 1;
    case 3
        % Do nothing
    otherwise
        error('Error occurred.');
end

%TODO Insert checks to ensure that dRho and dTheta are good.

%Get the dimensions of the input image.
[height, width] = size(edge);

%Get the maximum Rho
maxRho = ceil(sqrt((height/2)^2+(width/2)^2));

%Get theta and rho
theta = 0:dTheta:180-dTheta;
%   Remove the zero element in the middle as the formula will never give a
%   zero value.
vrho = cat(2,(-maxRho:dRho:-dRho), (dRho:dRho:maxRho));

if isempty(vrho)
    vrho = 1;
end

%Get HPS dimensions
[~, m] = size(theta);
[~, n] = size(vrho);

%Initialise the Accumulator array (A)
A = zeros(n, m);

%Get HPS by iterating through the binary edge image and operating on
%feature points.
for y = 1:height
    for x = 1:width
        
        % Iterate over binary edge pixels
        if edge(y,x) > 0
            
            % Adjust Cartesian Positions
            xTemp = x-width/2;
            yTemp = y-height/2;
                 
            % Get Hough Parameters
            rho = round((xTemp*cos(deg2rad(theta))+yTemp*sin(deg2rad(theta))+maxRho));
            
            rhotemp = floor(rho/dRho)+1;
            
            % Apply votes to HPS
            for i = 1:m
                A(rhotemp(1,i), (theta(1,i)/dTheta)+1) = A(rhotemp(1,i), (theta(1,i)/dTheta)+1) + 1;
            end
            
        end
    end
end

%Assign the accumulator array to the HPS output array
hps = A;

end