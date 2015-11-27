% This function computes the Tranformation matrices and Non-Rigid 3D points using
% Bundle Adjustment (Levenberg-Marquardt)
% The matrices are formularized as for orthographic projections => we used
% Angle-Axis (with 3 dof for rotation transformation)

function reconsBundleAdjustment_NonRigid_RotationConstraintMatrix ()

addpath('../');
addpath('../Toolbox');

% Read points from file
M = dlmread('../../Data/landmark_d2.txt');
M = M(:,2:end);     % Eliminate the first number of each frame

selectedFrames = 1:20:size(M,1);
M = M(selectedFrames, :);

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

initMat = [1/sqrt(2) -1/sqrt(2) 0; 1/sqrt(2) 1/sqrt(2) 0; 0 0 1];
init_angleaxis = RotationMatrix2AngleAxis(initMat);
% For matrices
Ag = zeros(3, no_cams);
for iCam = 1:no_cams
    Ag(:,iCam) = init_angleaxis;
end

% For 3D points
for iCam = 1:no_cams
    P(3*iCam-2:3*iCam-1,:) = X(2*iCam - 1: 2*iCam,:);
    P(3*iCam,:) = 1;
end
%P = ones(3, no_pts);

% Residual and ReProjection Error before optimization
%initialResidual = calculateResidual_Neutral(X, R, P);
%disp(sum(initialResidual(:) .^2));

%% Doing optimization
agg = [Ag(:); P(:)];
options = optimoptions(@lsqnonlin,'Algorithm','levenberg-marquardt','Display','off');

[optm_res, resnorm] = lsqnonlin(@(variable) calResidualNonRigid_AngleAxis(X,variable), agg,[],[],options);
disp(resnorm);

R_arr = optm_res(1:3*no_cams, 1);
P_arr = optm_res(3*no_cams + 1:end,1);
R_opt = reshape(R_arr, 3, []);
P_opt = reshape(P_arr, 3*no_cams, no_pts);

%finalResidual = calculateResidual_Neutral(X, R_opt, P_opt);
%disp(sum(finalResidual(:) .^2));

%% Kanade - Tomasi
% [U, S, V] = svd(X, 0);
% U1 = U(:,1:3);
% S1 = S(1:3,1:3);
% sqrt_S1 = sqrt(S1);
% K = V';
% K1 = K(1:3,:);
% 
% TR = U1*sqrt_S1;
% S = sqrt_S1*K1;
% 
% kanade_error = sum(kanadeResidual(X, TR, S) .^ 2);
% new_error = sum(calResidual(X, [R_opt(:); P_opt(:)]) .^ 2);
% disp(kanade_error);
% disp(new_error);

%neutral_error = calculateNonRigidResidual_Neutral(X, R_opt, P_opt);
%disp(sum(neutral_error(:) .^2));

ptX = P_opt(1,:);
ptY = P_opt(2,:);
ptZ = P_opt(3,:);
% ptX = S(1,:);
% ptY = S(2,:);
% ptZ = S(3,:);

figure;
scatter3(ptX, ptY, ptZ);

a =3 ;

end




