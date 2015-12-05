% This function computes the Tranformation matrices and Non-Rigid 3D points using
% Bundle Adjustment (Levenberg-Marquardt)
% The matrices are formularized as for orthographic projections => we used
% Angle-Axis (with 3 dof for rotation transformation)

function recons_NonRigid_KanadeRoot ()

addpath('../');
addpath('../Toolbox');
addpath('./Auxiliary');

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

no_pts = size(X,2);
no_cams = size(X,1)/2;

%% Initilize matrices and 3D points by Rigid-Bundle Adjustment
[P_root, angle_axis] = reconsBundleAdjustment_Rigid (X);

%% Optimization the reconstructed model for each camera

%% Fix rotation and optimize the 3D points
P_opt = [];
for iCam = 1:no_cams
    options = optimoptions(@lsqnonlin,'Algorithm','levenberg-marquardt','Display','off');
    P = P_root;
    [optm_res, resnorm] = lsqnonlin(@(variable) residual3DPoints(X(2*iCam-1:2*iCam,:),P_root,angle_axis(:, iCam),variable), P(:),[],[],options);
    P_opt(:,:,iCam) = reshape(optm_res, 3, []);
    disp(iCam);
end

for iCam = 1:4:no_cams
    ptX = P_opt(1,:,iCam);
    ptY = P_opt(2,:,iCam);
    ptZ = P_opt(3,:,iCam);

    figure;
    scatter3(ptX, ptY, ptZ);
    %scatter(X(1,:), X(2,:))
    %scatter3(S(1,:), S(2,:), S(3,:));
end

a = 3;

end




