% This function computes the Tranformation matrices and 3D points using
% Bundle Adjustment (Levenberg-Marquardt)
% The matrices are formularized as for orthographic projections => we used
% 3x4 matrices for transformation (last rows are 0 0 0 1)

function reconsBundleAdjustment_Rigid ()

addpath('./Toolbox');

% Read points from file
M = dlmread('../Data/landmark_d1.txt');
M = M(:,2:end);     % Eliminate the first number of each frame

X =[];
for i = 1:size(M,1)
    X(2*i - 1,:) = M(i,1:2:end);
    X(2*i, :) = M(i,2:2:end);
end

X_avg = sum(X,2) ./ size(X,2);
X_avg = repmat(X_avg, 1, size(X,2));
X = X - X_avg;

% Initilize matrices and 3D points
no_pts = size(X,2);
no_cam = size(X,1)/2;

% For matrices
for iCam = 1:no_cam
    R(:,:,iCam) = [1 0 0; 0 1 0; 0 0 1];
end

% For 3D points
P(1:2,:) = X(1:2,:);
P(3,:) = 1;

%% Doing optimization
fun = @(Unk

end

%% Function for calculate residual
function residual = calResidual (X, R, P)



end


