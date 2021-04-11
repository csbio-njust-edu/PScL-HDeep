function distance = rp_histogram_distance_manhattan(instance, matrix)
% Calculates distance between a single histogram instance and a set of
% histograms. Both must have the same histogram descriptor length.
%
% Manhattan(P, Q) = SUMi (Pi - Qi)
%
% Syntax: 
%       [] = rp_histogram_distance_manhattan(instance, matrix);
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

instance_matrix = abs(instance_matrix - matrix);
distance = sum(instance_matrix')';

end