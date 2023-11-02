% Compute epipolar lines for points in image 2 using points from image 1
lines = epipolarLine(F, pt1);
distances = zeros(1, numel(pt1));

for i = 1:size(pts1, 1)
    x = pts2(i, 1);
    y = pts2(i, 2);
    a = lines(i, 1);
    b = lines(i, 2);
    c = lines(i, 3);
    distances(i) = (a * x + b * y + c)^2 / (a^2 + b^2);
end

% Compute epipolar lines for points in image 1 using points from image 2
lines1 = epipolarLine(F', pts2);

for i = 1:size(pts2, 1)
    x = pts1(i, 1);
    y = pts1(i, 2);
    a = lines1(i, 1);
    b = lines1(i, 2);
    c = lines1(i, 3);
    distances(i + size(pts1, 1)) = (a * x + b * y + c)^2 / (a^2 + b^2);
end

% Compute mean symmetric epipolar distance
mean_distance = mean(distances);
