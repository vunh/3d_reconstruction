function generateSequence ()

data = load(['/Users/vunguyen/Documents/Study/CSE 527 - Introduction to Computer Vision'...
            '/Project/RealData/HumanFace/face/face01.mat']);
        
X = data.surface.X;
Y = data.surface.Y;
Z = data.surface.Z;
Itens = data.surface.I;
TRIV = data.surface.TRIV;

% Refine X,Y and Z to integer
X = X' * 1000;       % X, Y, Z are converted to row vectors
Y = Y' * 1000;
Z = Z' * 1000;
P = [X; Y; Z];

% Transformation before rendering
meanZ = mean(P(3,:));
P(3,:) = P(3,:) - meanZ;    % Translate the obj to the origin (Z = 0)

% Rotation for transformation
% And align X and Y coordinate so that these coordinates are positive(>=0)
delta_angle = pi/32;
start_angle = -pi/8
end_angle = pi/8;




iShape = 1;
for angle = start_angle:delta_angle:end_angle
    rotmat = [cos(angle) 0 -sin(angle); 0 1 0; sin(angle) 0 cos(angle)];
    rotP(:,:,iShape) = round(rotmat*P);
    iShape = iShape + 1;
end
rotP(3,:,:) = rotP(3,:,:) + meanZ;  % Translate back to the original position in terms of Z
xArr = rotP(1,:,:);
yArr = rotP(2,:,:);
minX = min(xArr(:));
minY = min(yArr(:));


deltaX = 1 - minX;
deltaY = 1 - minY;

rotP(1,:) = rotP(1,:) + deltaX;
rotP(2,:) = rotP(2,:) + deltaY;

xArr = rotP(1,:,:);     % Update xArr and yArr
yArr = rotP(2,:,:);
maxX = max(xArr(:));
maxY = max(yArr(:));
width = maxX;
height = maxY;

for i = 1:size(rotP,3)
    renderSurface(rotP(1,:,i), rotP(2,:,i), Itens, TRIV, width, height);
end

end