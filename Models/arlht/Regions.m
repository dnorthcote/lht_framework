function [ output ] = Regions( input, R )

[h, w] = size(input);
output = zeros(h, w/R, R);

for i = 1:w/R
    for k = 0:R-1
        output(:, i, k+1) = input(:, i + k*w/R);
    end
end


end

