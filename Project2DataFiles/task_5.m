totalDistance = 0;

for i = 1:length(x1)
    % homogeneous coordinates
    point1 = [x1(i); y1(i); 1];
    point2 = [x2(i); y2(i); 1]; 

    % calculate square geometric distance
    distance1 = ((epiLines1(1)*x1(i) + epiLines1(2)*y1(i) + epiLines1(3))^2) / (epiLines1(1)^2 + epiLines1(2)^2);
    distance2 = ((epiLines2(1)*x2(i) + epiLines2(2)*y2(i) + epiLines2(3))^2) / (epiLines2(1)^2 + epiLines2(2)^2);
   
    symmEpiDist = distance1 + distance2; 
    totalDistance = totalDistance + symmEpiDist;
end

meanSymmetricEpipolarDistance = totalDistance / length(x1)
