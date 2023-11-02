load('Image1PointLocations.jpg');
load('Image2PointLocations.jpg');
% Compute the Fundamental matrix using 8-point algorithm
F = estimateFundamentalMatrix(Image1PointLocations, Image2PointLocations, 'Method', 'Norm8Point');
