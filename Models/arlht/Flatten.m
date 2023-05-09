function [ output ] = Flatten( input )

[h, w, d] = size(input);
output = zeros(h, w*d);

for i = 1:w
    for k = 0:d-1
        output(:, i + k*(w)) = input(:, i, k+1);
    end
end


end

