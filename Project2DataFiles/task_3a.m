% Task 3a
% Andrei Dawinan - abd5635@psu.edu

% load parameters for Camera1
load("Parameters_V1_1.mat");
param1 = Parameters;

% load parameters for Camera2
load("Parameters_V2_1.mat");
param2 = Parameters;

% initialize 3x2 arrays for pixel locations
% row = point #, col1 = x, col2 = y
% point #'s correspond across both images

% initialize array of pixel locations in im1
im1Locations = [932 602; 336 709; 977 935];

% initialize array of pixel locations in im2
im2Locations = [499 598; 929 891; 1712 698];

% initialize array of world locations
worldLocations = zeros(3, 3);

% triangulation
% lambda P(pixel) = K [R | t] (P(world) / 1) 
% -> P(world) = -(R^T)(t) + lambda (R^T)(K^-1) P(pixel)
% c(camera in world) = -(R^T)(t), v(viewing ray/direction vector to world point) = (R^T)(K^-1) P(pixel), want to normalize v

% iterate through points 1-3 in each image
for point = 1:3
    
    % find P(pixel), K, t, and c for im1 with Camera1
    pixel1 = [im1Locations(point, 1); im1Locations(point, 2); 1];
    r1 = param1.Rmat;
    k1 = param1.Kmat;
    t1 = param1.Pmat(:, 4);
    %v1 = normalize(r1.' * k1^-1 * pixel1);
    v1 = r1.' * k1^-1 * pixel1;
    v1 = v1 / norm(v1);
    c1 = -1 * r1.' * t1;

    % find P(pixel), K, t, and c for im1 with Camera2
    pixel2 = [im2Locations(point, 1); im2Locations(point, 2); 1];
    r2 = param2.Rmat;
    k2 = param2.Kmat;
    t2 = param2.Pmat(:, 4);
    %v2 = normalize(r2.' * k2^-1 * pixel2);
    v2 = r2.' * k2^-1 * pixel2;
    v2 = v2 / norm(v2);
    c2 = -1 * r2.' * t2;

    % find cross product of v1 and v2 (normal vector)
    %v3 = normalize(cross(v1, v2));
    v3 = cross(v1, v2);
    v3 = v3 / norm(v3);

    % a v1 + c v3 - b v2 = T
    % T = c2 - c1
    % solve system of equations to find scale factor for each
    % vector
    %vectors = [v1 v2 v3; v1 v2 v3; v1 v2 v3];
    vectors = [v1 -1*v2 v3];
    scales = linsolve(vectors, c2 - c1);

    % getting world coordinates
    % get midpoint between c1 + (a v1) and c2 (b v2)
    worldPoint = 0.5 * ((c1 + (scales(1) * v1) + (c2 + (scales(2) * v2))));
    %worldLocations(point, :) = ((c1.' + scales(1) * v1.') + (c2.' + scales(2) * v2.')) / 2;
    worldLocations(point, :) = worldPoint.';
end

% finding equation of plane
% ax + by + cz + d = 0

% find vectors from 3 world points
%v12 = worldLocations(1, :) - worldLocations(2, :);
%v13 = worldLocations(1, :) - worldLocations(3, :);
v21 = worldLocations(2, :) - worldLocations(1, :);
v23 = worldLocations(2, :) - worldLocations(3, :);

% find cross-product of v12 and v13 (normal vector)
% gives us a, b, and c
planeCoefficients = cross(v21, v23);

% find d
% use planeCoefficients and one of the world points
d = -1 * (planeCoefficients(1) * worldLocations(1, 1) + planeCoefficients(2) * worldLocations(1, 2) + planeCoefficients(3) * worldLocations(1, 3));

fprintf('%fx + %fy + %fz + %d = 0', planeCoefficients(1), planeCoefficients(2), planeCoefficients(3), d);