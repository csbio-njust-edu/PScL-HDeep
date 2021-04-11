function [rank, distance] = rp_histogram_distance_cosine(instance, matrix)
% Calculates distance between a single histogram instance and a set of
% histograms. Both must have the same histogram descriptor length.
%
% cosine(P, Q) = sqrt(SUMi ((Pi - Qi)^2))
%
% Syntax: 
%       [] = rp_histogram_distance_cosine(instance, matrix);
%
% Variables:    
%   instance   - single histogram instance of length n
%   matrix     - matrix of m histogram instances (m x n)


dim1 = size(instance);
dim2 = size(matrix);

if (dim1(1, 1) ~= 1)
    error('First argument should be one row');
end
if (dim1(1, 2) ~= dim2(1, 2))
    error('Length of histogram vectors do not match');
end

instance_length = sqrt(sum(instance' .^ 2));
matrix_length = instance_length .* sqrt(sum(instance' .^2));

distance = ones(1, dim2) - ((instance * matrix') ./ matrix_length);

[sorted, rank] = sort(distance);

end