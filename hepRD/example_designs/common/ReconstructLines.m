function [ iLines ] = ReconstructLines(rho, theta, iLines, yOrigin, xOrigin)

% If No Input Arguments
switch nargin
    case 0
        rho = -251;
        %rho = -368
        theta = 157; %0 to 179
        iLines = uint8(zeros(600,800));
        yOrigin = 150;
        %yOrigin = -150;
        xOrigin = 0;
    case 5
    otherwise
        return
end   

% Get dimensions
[height, width] = size(iLines);

% Reconstruct Lines Based on yOrigin and xOrigin
for i = 1:length(rho)
    if rho(i) ~= 0
        thetaTemp = double(theta(i));
        rhoTemp = rho(i);
        hDimNeg = -height/2+yOrigin;
        hDimPos = height/2+yOrigin-1;
        wDimNeg = -width/2+xOrigin;
        wDimPos = width/2+xOrigin-1;

        if (45 <= thetaTemp) && (thetaTemp <= 135)
            for j = wDimNeg:wDimPos
                y = (rhoTemp - j*(cos(deg2rad(thetaTemp))))/((sin(deg2rad(thetaTemp))));
                y = y + abs(hDimNeg);%%
                if (y > 0) && (y <= height)
                    iLines(ceil(y) , j+abs(wDimNeg)+1) = 1;
                end
            end
        else
            for j = hDimNeg:hDimPos
                x = (rhoTemp - j*(sin(deg2rad(thetaTemp))))/((cos(deg2rad(thetaTemp))));
                x = x + abs(wDimNeg);%%
                if (x > 0) && (x <=width)
                    iLines(j+abs(hDimNeg)+1, ceil(x)) = 1;
                end
            end
        end
    end
end
%imtool(iLines);
