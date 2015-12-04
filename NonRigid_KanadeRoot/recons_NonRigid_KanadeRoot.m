% This function computes the Tranformation matrices and Non-Rigid 3D points using
% Bundle Adjustment (Levenberg-Marquardt)
% The matrices are formularized as for orthographic projections => we used
% Angle-Axis (with 3 dof for rotation transformation)

function recons_NonRigid_KanadeRoot ()

addpath('../');
addpath('../Toolbox');

% Read points from file
M = dlmread('../../Data/landmark_d2.txt');
M = M(:,2:end);     % Eliminate the first number of each frame

selectedFrames = 1:20:size(M,1);
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

% Optimization the reconstructed model for each camera
for iCam = 1:no_cams
    
end

end




