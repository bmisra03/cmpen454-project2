load("ImagePointLocations.mat");

load("Parameters_V1_1.mat");
Rl = Parameters.Rmat;
Tl = Rl*(-1*Parameters.position');

load("Parameters_V2_1.mat");
Rr = Parameters.Rmat;
Tr = Rr*(-1*Parameters.position)';

R = Rr*Rl';
T = Tl-R'*Tr;

pl = [image1Locations(:, 1); 1];
pr = [image2Locations(:, 1); 1];

A = [pl,R'*pr,cross(pl, R'*pr)];
X = linsolve(A, T);



