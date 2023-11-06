load('ImagePointLocations.mat')
x1 = image1Locations(1, 1:8)';
y1 = image1Locations(2, 1:8)';
x2 = image2Locations(1, 1:8)';
y2 = image2Locations(2, 1:8)';

%do Hartley preconditioning
savx1 = x1; savy1 = y1; savx2 = x2; savy2 = y2;
mux = mean(x1);
muy = mean(y1);
stdxy = (std(x1)+std(y1))/2;
T1 = [1 0 -mux; 0 1 -muy; 0 0 stdxy]/stdxy;
nx1 = (x1-mux)/stdxy;
ny1 = (y1-muy)/stdxy;
mux = mean(x2);
muy = mean(y2);
stdxy = (std(x2)+std(y2))/2;
T2 = [1 0 -mux; 0 1 -muy; 0 0 stdxy]/stdxy;
nx2 = (x2-mux)/stdxy;
ny2 = (y2-muy)/stdxy;

A = [];
for i=1:length(nx1);
    A(i,:) = [nx1(i)*nx2(i) nx1(i)*ny2(i) nx1(i) ny1(i)*nx2(i) ny1(i)*ny2(i) ny1(i) nx2(i) ny2(i) 1];
end
%get eigenvector associated with smallest eigenvalue of A' * A
[u,d] = eigs(A' * A,1,'SM');
F = reshape(u,3,3);

%make F rank 2
oldF = F;
[U,D,V] = svd(F);
D(3,3) = 0;
F = U * D * V';

%unnormalize F to undo the effects of Hartley preconditioning
F = T2' * F * T1;

% Convert points to homogeneous coordinates
points1 = [x1'; y1'; ones(1, length(x1))];
points2 = [x2'; y2'; ones(1, length(x2))];

% Compute the corresponding epipolar lines in the first image
epiLines1 = F' * points2;
epiLines2 = F * points1;

% Normalize the epipolar lines
for i = 1:size(epiLines1, 2)
    epiLines1(:, i) = epiLines1(:, i) / norm(epiLines1(1:2, i));
end

% Normalize the epipolar lines so that the a^2 + b^2 = 1 in ax + by + c = 0
for i = 1:size(epiLines2, 2)
    epiLines2(:, i) = epiLines2(:, i) / norm(epiLines2(1:2, i));
end

F
epiLines1
epiLines2
