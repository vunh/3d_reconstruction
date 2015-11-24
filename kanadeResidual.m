function res = kanadeResidual(X, TR, P)

%% Split agg to set of rotation matrices R and set of points P
no_cams = size(X,1)/2;

%% Doing transformation and calculate the reprojection error
reproj = TR*P;
delta = X - reproj;
res1 = delta(:);

residual = [];
for iCam = 1:no_cams
    % Transform P using R
    trMat = TR([2*iCam - 1, 2*iCam],:);
    pt2d = trMat*P;
    x = pt2d(1,:);
    y = pt2d(2,:);
    deltaX = x - X(2*iCam - 1,:);
    deltaY = y - X(2*iCam,:);
    residual = [residual; [deltaX deltaY]];
end
res = residual(:);



end