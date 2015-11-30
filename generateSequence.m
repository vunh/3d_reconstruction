function generateSequence ()

data = load(['/Users/vunguyen/Documents/Study/CSE 527 - Introduction to Computer Vision'...
            '/Project/RealData/HumanFace/face/face01.mat']);
        
X = data.surface.X;
Y = data.surface.Y;
Z = data.surface.Z;
Itens = data.surface.I;
TRIV = data.surface.TRIV;

% Refine X,Y and Z to integer
X = int16(X' * 1000);       % X, Y, Z are converted to row vectors
Y = int16(Y' * 1000);
Z = int16(Z' * 1000);
P = [X; Y; Z];

% Transformation before rendering
trX = [];
trY = [];
trZ = [];

% First rotate -pi/4 to the start position
beginMat = [cos(-pi/4) 0 -sin(-pi/4); 0 1 0; sin(-pi/4) 0 cos(-pi/4)];
P = beginMat*P;

% Rotation for transformation
delta_angle = pi/16;
start_angle = -pi/4
end_angle = pi/4;

iShape = 1;
for angle = start_angle:delta_angle:end_angle
    rotmat = [cos(angle) 0 -sin(angle); 0 1 0; sin(angle) 0 cos(angle)];
    arrP(:,:,iShape) = rotmat*P;
    iShape = iShape + 1;
end
pX = X;
pY = Y;
pZ = Z;

% 
minX = min(pX(:));
minY = min(pY(:));
deltaX = 1 - minX;
deltaY = 1 - minY;

pX = pX + deltaX;
pY = pY + deltaY;


end