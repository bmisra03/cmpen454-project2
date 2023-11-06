% Task 3c
% Andrei Dawinan - abd5635@psu.edu

% load parameters for Camera1
load("Parameters_V1_1.mat");
param1 = Parameters;

% load parameters for Camera2
load("Parameters_V2_1.mat");
param2 = Parameters;

% initialize array of pixel locations in im1
im1Doorway = [1127 291; 1116 546];
im1Person = [573 390; 546 715];
im1Cam = [1462 257];

% initialize array of pixel locations in im2
im2Doorway = [222 177; 250 514];
im2Person = [1041 346; 1042 775];
im2Cam = [716 154];

% initialize array of world locations;
worldDoorway = zeros(2, 3);
worldPerson = zeros(2, 3);
worldCam = zeros(1, 3);

% GETTING HEIGHT OF DOORWAY

% get world coords from pixel coords
worldDoorway = triangulation(im1Doorway, im2Doorway, worldDoorway, param1, param2);

% find difference in the 2 world points (discontinued)
%doorwayDiff = [(worldDoorway(1, 1) - worldDoorway(2, 1)) (worldDoorway(1, 2) - worldDoorway(2, 2)) (worldDoorway(1, 3) - worldDoorway(2, 3))];

% find difference in Z-axis
doorwayDiff = worldDoorway(1, 3) - worldDoorway(2, 3);

% find height of doorway
doorwayHeight = norm(doorwayDiff);
fprintf('Height of door: %f mm\n', doorwayHeight);

% GETTING HEIGHT OF PERSON

% get world coords from pixel coords
worldPerson = triangulation(im1Person, im2Person, worldPerson, param1, param2);

% find difference in the 2 world points (discontinued)
%personDiff = [(worldPerson(1, 1) - worldPerson(2, 1)) (worldPerson(1, 2) - worldPerson(2, 2)) (worldPerson(1, 3) - worldPerson(2, 3))];

% find difference in Z-axis
personDiff = worldPerson(1, 3) - worldPerson(2, 3);

% find height of doorway
personHeight = norm(personDiff);
fprintf('Height of person: %f mm\n', personHeight);

% GETTING 3D LOCATION OF CAMERA
worldCam = triangulation(im1Cam, im2Cam, worldCam, param1, param2);

fprintf('3D Location of camera: %f  %f  %f\n', [worldCam]);

% helper function triangulate: take input matrix of pixel coordinates and
% return world coordinates via triangulation
function [world] = triangulation(im1Locations, im2Locations, emptyWorld, param1, param2)
    for point = 1:length(im1Locations(:, 1))
    
        % find P(pixel), K, t, and c for im1 with Camera1
        pixel1 = [im1Locations(point, 1); im1Locations(point, 2); 1];
        r1 = param1.Rmat;
        k1 = param1.Kmat;
        t1 = param1.Pmat(:, 4);
        v1 = r1.' * k1^-1 * pixel1;
        v1 = v1 / norm(v1);
        c1 = -1 * r1.' * t1;
    
        % find P(pixel), K, t, and c for im1 with Camera2
        pixel2 = [im2Locations(point, 1); im2Locations(point, 2); 1];
        r2 = param2.Rmat;
        k2 = param2.Kmat;
        t2 = param2.Pmat(:, 4);
        v2 = r2.' * k2^-1 * pixel2;
        v2 = v2 / norm(v2);
        c2 = -1 * r2.' * t2;
    
        % find cross product of v1 and v2
        v3 = cross(v1, v2);
        v3 = v3 / norm(v3);
    
        % a v1 + c v3 - b v2 = T
        % T = c2 - c1
        % solve system of equations to find scale factor for each
        % vector
        vectors = [v1 -1*v2 v3];
        scales = linsolve(vectors, c2 - c1);
    
        % getting world coordinates
        % get midpoint between c1 + (a v1) and c2 (b v2)
        worldPoint = 0.5 * ((c1 + (scales(1) * v1) + (c2 + (scales(2) * v2))));
        emptyWorld(point, :) = worldPoint.';
    end

    world = emptyWorld;

end
