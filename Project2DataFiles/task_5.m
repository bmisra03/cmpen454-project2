%Load fundamental matrix
load('F.mat')

%Load pixel values
load("ImagePointLocations.mat");

totalDistance = 0;

for i = 1:size(image1Locations,2)
    % convert point to homogeneous coordinates
    point1 = [image1Locations(:,i);1];
    point2 = [image2Locations(:,i);1]; 
    
    % compute epipolar lines
    l2 = F*point1;
    l1 = F'*point2;

    % calculate square geometric distance
    dist1 = dot(l1, point1)^2/(l1(1)^2+l1(2)^2);
    dist2 = dot(l2, point2)^2/(l2(1)^2+l2(2)^2);

    totalDistance = totalDistance + dist1 + dist2;
end

% to get mean distance, we get the total distance and divide by 
% the total number of points (2*39=78 points in this case)
meanDistance = totalDistance/(2*size(image1Locations, 2));
disp(meanDistance);
