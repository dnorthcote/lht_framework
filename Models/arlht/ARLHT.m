function [hps, Aopt, rbm] = ARLHT(edge, Gdir, dTheta, dRho, lambda, regions)
%ARLHT Applies the Angular Regions - Line Hough Transform to binary images.
%   The Angular Regions - Line Hough Transform (AR-LHT), as defined by
%   Northcote et al. [1], is applied to a binary edge image using this
%   function. The number of regions to operate across is selected by
%   setting the regions argument up to a maximum of 4. The discretisation
%   step of theta and rho are set using the respective arguments. The Hough
%   Parameter Space (HPS) is produced by applying the analytical function
%   for lines as described in [2]. The HPS is returned as a double
%   precision array. The gradient technique is used as detailed in [3] to
%   reduce the total computation of the AR-LHT.
%
%   [1]  -  D. Northcote, L.H. Crockett, and P.Murray, "FPGA implementation
%           of a memory-efficient hough parameter space for the detection 
%           of lines," in 2018 IEEE International Symposium on Circuits and
%           Systems (ISCAS), May 2018, pp. 1-5.
%
%   [2]  -  R. O. Duda, P. E. Hart, "Use of the Hough transformation to 
%           detect lines and curves in pictures", Commun. ACM, vol. 15,
%           no. 1, pp. 11-15, Jan. 1972.
%
%   [3]  -  F. O'Gorman and M. B. Clowes, "Finding picture edges through
%           collinearity of greature points," IEEE Transactions on
%           Computers, vol. C-25, no. 4, pp. 449-456, April 1976.

%Check arguments
switch nargin
    case 0
        error('Not enough input arguments.');
    case 1
        error('Not enough input arguments.');
    case 2
        dTheta = 1;
        dRho = 1;
        lambda = 0;
        regions = 4;
    case 3
        dRho = 1;
        lambda = 0;
        regions = 4;
    case 4
        lambda = 0;
        regions = 4;
    case 5
        regions = 4;
    case 6
        % Do nothing
    otherwise
        error('Error occurred.');
end

%TODO Insert checks to ensure that dTheta, dRho, and Lambda are good.

%Get the dimensions of the input image.
[height, width] = size(edge);

%Get the maximum Rho
maxRho = ceil(sqrt((height/2)^2+(width/2)^2));

%Get theta and rho
theta = (0:dTheta:180-dTheta);
thetaMax = theta(end);

%Remove the zero element in the middle as the formula will never give a
%zero value.
vrho = cat(2,(-maxRho:dRho:-dRho), (dRho:dRho:maxRho));

%Get HPS dimensions
[~, m] = size(theta);
[~, n] = size(vrho);

%Initialise the Accumulator array (A)
A = zeros(n, m/regions);

%Initialise the Region-Bit-Map (RBM)
B = zeros(n, m);

%If the number of theta is odd, then we need to adjust the operational
%range for the theta index. Also check if lambda is zero so we can ignore
%this issue.
subflag = ~mod(m, 2)*(lambda~=0);

% Get the angular length
K = floor(((thetaMax+dTheta)/regions));

% Get the index length for the optimised HPS.
mr = m/regions;
cosQ = double(fi(cos(deg2rad(theta)), 1, 16, 14));
sinQ = double(fi(sin(deg2rad(theta)), 1, 16, 14));

%Get HPS by iterating through the binary edge image and operating on
%feature points.
for y = 1:height
    for x = 1:width
        
        % Iterate over binary edge pixels
        if edge(y,x) > 0
            
            % Adjust Cartesian Positions
            xTemp = x-width/2-1;
            yTemp = y-height/2-1;
            
            % Get the index of the gradient orientation in relation to the
            % operational range of theta
            g_idx = round(Gdir(y,x)/dTheta)+1;
                        
            % Iterate across values of theta around gradient theta
            for i = g_idx-lambda:1:g_idx+lambda-subflag
                
                % Get a temporary index for manipulation
                i_temp = i;
                
                % Check the theta index for limits
                if i_temp < 1
                    i_temp = i_temp + m;
                end
                if i_temp > m
                    i_temp = i_temp - m;
                end
                
                % Obtain the value of theta relative to our temporary index
                theta_i = theta(i_temp);
                
                % Get Hough Parameters
                rho = round(round(xTemp*cosQ(i_temp))+round(yTemp*...
                    sinQ(i_temp))+maxRho)/dRho + 1;
                
                % Get the adjusted orientation for voting
                aTheta = theta_i - floor(theta_i/K)*K;
                a_idx = round(aTheta/dTheta)+1;

                % Apply vote to HPS
                A(rho, a_idx) = A(rho, a_idx) + 1;
                
                % Apply a vote to the RBM. Only the gradient orientation
                % should be applied. The full range of theta given by
                % lambda is ignored.
                if i == g_idx
                    B(rho, g_idx) = 1;
                end
            end
        end
    end
end

%Reconstruct the accumulator array using the optimised HPS and the RBM.
%Start by applying a morphological opening to the RBM.
if regions > 1
    Bopen = imdilate(imerode(B, ones(3)), ones(3));
else
    Bopen = B;
end

%Restructure the RBM (open) into regions for simple matrix multiplication.
Bopen_r = Regions(Bopen, regions);

%Obtain the Reconstructed HPS Arec by multiplying across each region.
Arec_r = A .* Bopen_r;

%Flatten the Reconstructed HPS for output.
Arec = Flatten(Arec_r);

%Assign the accumulator array to the HPS output array.
Aopt = A;
rbm = B;
hps = Arec;

end