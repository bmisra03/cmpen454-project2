%Load the motion captured 3D points
load("mocapPoints3D.mat");

%Load the parameters for camera 1
load("Parameters_V1_1.mat");

image1Locations = zeros(2,39);
image2Locations = zeros(2,39);

%Iterate through all 39 points for image1 and calculate pixel values
for i = 1:size(pts3D, 2)
    %Extract the world point
    worldPoint = [pts3D(:, i); 1];
    %Compute the offset matrix
    offset = [eye(3), -1*Parameters.position'; zeros(1,3), 1];
    %Compute the rotation matrix
    R = [Parameters.Rmat, zeros(3,1); zeros(1,3), 1];
    %Compute camera point by applying the rotation/offset to world point
    cameraPoint = R*offset*worldPoint;
    %Compute pixel point by applying the Kmatrix to the camera point
    pixelPoint = [Parameters.Kmat, zeros(3,1)]*cameraPoint;
    pixelPoint = pixelPoint/pixelPoint(3);
    %Save the pixel point to the locations array
    image1Locations(:, i) = pixelPoint(1:2, :);
end

%Load the parameters for camera 2
load("Parameters_V2_1.mat");

%Iterate through all 39 points for image2 and calculate pixel values
for i = 1:size(pts3D, 2)
    %Extract the world point
    worldPoint = [pts3D(:, i); 1];
    %Compute the offset matrix
    offset = [eye(3), -1*Parameters.position'; zeros(1,3), 1];
    %Compute the rotation matrix
    R = [Parameters.Rmat, zeros(3,1); zeros(1,3), 1];
    %Compute camera point by applying the rotation/offset to world point
    cameraPoint = R*offset*worldPoint;
    %Compute pixel point by applying the Kmatrix to the camera point
    pixelPoint = [Parameters.Kmat, zeros(3,1)]*cameraPoint;
    pixelPoint = pixelPoint/pixelPoint(3);
    %Save the pixel point to the locations array
    image2Locations(:, i) = pixelPoint(1:2, :);
end

%load image 1
image1 = imread('im1corrected.jpg');
figure;
imshow(image1);
title('Image1 with Point Locations');

hold on;
scatter(image1Locations(1, :), image1Locations(2, :), 'r', 'filled');
hold off;

%load image 2
image2 = imread('im2corrected.jpg');
figure;
imshow(image2);
title('Image2 with Point Locations');

hold on;
scatter(image2Locations(1, :), image2Locations(2, :), 'r', 'filled');
hold off;

