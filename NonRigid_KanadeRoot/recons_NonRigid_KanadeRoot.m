% This function computes the Tranformation matrices and Non-Rigid 3D points using
% Bundle Adjustment (Levenberg-Marquardt)
% The matrices are formularized as for orthographic projections => we used
% Angle-Axis (with 3 dof for rotation transformation)

function recons_NonRigid_KanadeRoot ()

addpath('../');
addpath('../Toolbox');

% Read points from file
M = dlmread('../../Data/landmark_d5.txt');
M = M(:,2:end);     % Eliminate the first number of each frame

selectedFrames = 1:10:size(M,1);
M = M(selectedFrames, :);

%% Subtract coordinates with means to eliminate the translation element
X =[];
for i = 1:size(M,1)
    X(2*i - 1,:) = M(i,1:2:end);
    X(2*i, :) = M(i,2:2:end);
end

X_avg = sum(X,2) ./ size(X,2);
X_avg = repmat(X_avg, 1, size(X,2));
X = X - X_avg;             % Important point to note

%% Initilize matrices and 3D points
no_pts = size(X,2);
no_cams = size(X,1)/2;

% For 3D points
[U, S, V] = svd(X, 0);
U1 = U(:,1:3);
S1 = S(1:3,1:3);
sqrt_S1 = sqrt(S1);
K = V';
K1 = K(1:3,:);

R = U1*sqrt_S1;     % R is the reconstructed transformation matrix
S = sqrt_S1*K1;     % S is the coordinate of the root model

%% Optimization the reconstructed model for each camera
angle_axis = [];
for iCam = 1:no_cams
    % Fix the model and adjust the rotation so that reprojection error is
    % minimum
    
    
    initMat = [1 0 0; 0 1 0; 0 0 1];
    init_angleaxis = RotationMatrix2AngleAxis(initMat);
    options = optimoptions(@lsqnonlin,'Algorithm','levenberg-marquardt','Display','off');
    [optm_res, resnorm] = lsqnonlin(@(variable) residualRotation(X(2*iCam-1:2*iCam,:),S,variable), init_angleaxis',[],[],options);
    angle_axis(iCam, :) = optm_res';
    disp(iCam);
end

%% Fix rotation and optimize the 3D points
P_opt = [];
for iCam = 1:no_cams
    options = optimoptions(@lsqnonlin,'Algorithm','levenberg-marquardt','Display','off');
    P = S;
    [optm_res, resnorm] = lsqnonlin(@(variable) residual3DPoints(X(2*iCam-1:2*iCam,:),S,angle_axis(iCam, :)',variable), P(:),[],[],options);
    P_opt(:,:,iCam) = reshape(optm_res, 3, []);
    disp(iCam);
end

for iCam = 1:4:no_cams
    ptX = P_opt(1,:,iCam);
    ptY = P_opt(2,:,iCam);
    ptZ = P_opt(3,:,iCam);

    figure;
    %scatter3(ptX, ptY, ptZ);
    %scatter(X(1,:), X(2,:))
    scatter3(S(1,:), S(2,:), S(3,:));
end

a = 3;

end




