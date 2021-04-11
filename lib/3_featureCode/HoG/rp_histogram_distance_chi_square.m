function [rank, distance] = rp_histogram_distance_chi_square(instance, matrix)
% Calculates distance between a single histogram instance and a set of
% histograms. Both must have the same histogram descriptor length.
%
% Chi_square(P, Q) = SUMi( (Pi - Qi) ^2 / (Pi + Qi) )
%
% Syntax: 
%       [] = rp_histogram_distance_chi_square(instance, matrix);
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

instance_matrix = repmat(instance, dim2(1, 1), 1);

min_matrix = (instance_matrix - matrix) .^ 2;
plus_matrix = instance_matrix + matrix;
plus_matrix(plus_matrix < 0.0001) = 0.0001;
instance_matrix = min_matrix ./ plus_matrix;

distance = sqrt(sum((instance_matrix .^ 2)')');

[sorted, rank] = sort(distance);

end