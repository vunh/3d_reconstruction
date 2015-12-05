% This function is used to calculate the residual when trying to determine
% the rotation transformation given the 2D points and a root 3D model

function residual = residualRotation (X, P, R)

weight = getWeights();

residual = [];

trP = AngleAxisRotatePts(R, P);
x = trP(1,:);
y = trP(2,:);
deltaX = x - X(1,:);
deltaY = y - X(2,:);
residual = [residual; [deltaX.*weight deltaY.*weight]];

residual = residual(:);

end