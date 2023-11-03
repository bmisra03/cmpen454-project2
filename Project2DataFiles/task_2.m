%Load the motion captured 3D points
load("mocapPoints3D.mat");

%Load the parameters for camera 1
load("Parameters_V1_1.mat");
Parameters1 = Parameters;

%Load the parameters for camera 2
load("Parameters_V2_1.mat");
Parameters2 = Parameters;

%Load the pixel locations of images
load("ImagePointLocations.mat");

%initialize an empty array of results
triangulationResults = zeros(3,39);

%iterate through all point correspondences
for i=1:size(image1Locations,2)
    %We know that Pw = c+lambda*v
    %To find the world point, we find the normalized direction vector v and
    %translation point c for both the left point and right point
    P1 = [image1Locations(:,i); 1];
    K1 = Parameters1.Kmat;
    t1 = Parameters1.Rmat*-1*Parameters1.position';
    v1 = Parameters1.Rmat'*inv(K1)*P1;
    v1 = v1/norm(v1);
    c1 = -1*Parameters1.Rmat'*t1;

    P2 = [image2Locations(:,i); 1];
    K2 = Parameters2.Kmat;
    t2 = Parameters2.Rmat*-1*Parameters2.position';
    v2 = Parameters2.Rmat'*inv(K2)*P2;
    v2 = v2/norm(v2);
    c2 = -1*Parameters2.Rmat'*t2;

    %We calculate the direction vector that joins v1 and v2
    v3 = cross(v1, v2);
    v3 = v3/norm(v3);
    
    %Solve for the lengths of the vectors
    %Identify the world point as the midpoint between the vector endpoints
    x = linsolve([v1, -1*v2, v3], c2-c1);
    y = 0.5*(Parameters1.position'+x(1)*v1+Parameters1.position'+c2-c1+x(2)*v2);
    triangulationResults(:,i) = y;
end

%calculate mean squared error
err = immse(triangulationResults, pts3D);
disp(err);

