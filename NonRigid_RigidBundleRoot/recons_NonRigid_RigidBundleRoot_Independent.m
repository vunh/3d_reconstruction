% This function computes the Tranformation matrices and Non-Rigid 3D points using
% Bundle Adjustment (Levenberg-Marquardt)
% The matrices are formularized as for orthographic projections => we used
% Angle-Axis (with 3 dof for rotation transformation)

function recons_NonRigid_RigidBundleRoot_Independent ()

addpath('../');
addpath('../Toolbox');
addpath('./Auxiliary');

% Params
rigid_root_path = '/Users/vunguyen/Documents/Study/CSE 527 - Introduction to Computer Vision/Project/Results/NonRigid_RigidBundleRoot/RigidBundleInit_Results';
figure_image_path = '/Users/vunguyen/Documents/Study/CSE 527 - Introduction to Computer Vision/Project/Results/NonRigid_RigidBundleRoot/FigurePlot';
landmark_file = '../../Data/landmark_d5.txt';
frame_rigid_step = 1;
frame_step = 10;

% Read points from file
M = dlmread(landmark_file);
M = M(:,2:end);     % Eliminate the first number of each frame

selectedFrames = 1:frame_step:size(M,1);
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

% Extract a subset to build root model
rigidFrames = 1:frame_rigid_step:size(X,1)/2;
X_rigid = [];
for i = 1:size(rigidFrames, 2)
    id = rigidFrames(i);
    X_rigid(2*i-1:2*i,:) = X(2*id-1:2*id,:);
end

no_pts = size(X,2);
no_cams = size(X,1)/2;

%% Initilize matrices and 3D points by Rigid-Bundle Adjustment
[path, name, ext] = fileparts(landmark_file);
rigid_root_file = fullfile(rigid_root_path, [name '_rigidstep' num2str(frame_rigid_step*frame_step) '.mat']);
if (exist(rigid_root_file, 'file') == 2)
    load(rigid_root_file);
else
    [P_root, angle_axis_rigid] = reconsBundleAdjustment_Rigid (X_rigid);
    % Save P_root and angle_axis
    save(rigid_root_file, 'P_root');
end

%% Optimization the reconstructed model for each camera

% Fix model, optimize rotation matrix
angle_axis = [];
for iCam = 1:no_cams
    % Fix the model and adjust the rotation so that reprojection error is
    % minimum
    
    initMat = [1 0 0; 0 1 0; 0 0 1];
    init_angleaxis = RotationMatrix2AngleAxis(initMat);
    options = optimoptions(@lsqnonlin,'Algorithm','levenberg-marquardt','Display','off');
    [optm_res, resnorm] = lsqnonlin(@(variable) residualRotation(X(2*iCam-1:2*iCam,:),P_root,variable), init_angleaxis',[],[],options);
    angle_axis(:, iCam) = optm_res;
    disp(iCam);
end

% Fix rotation and optimize the 3D points/model
P_opt = [];
for iCam = 1:no_cams
    options = optimoptions(@lsqnonlin,'Algorithm','levenberg-marquardt','Display','off');
    P = P_root;
    [optm_res, resnorm] = lsqnonlin(@(variable) residual3DPoints(X(2*iCam-1:2*iCam,:),P_root,angle_axis(:, iCam),variable), P(:),[],[],options);
    P_opt(:,:,iCam) = reshape(optm_res, 3, []);
    disp(iCam);
end

load('FaceTriangulation.mat');
%figure('Visible', 'Off');



for iCam = 1:3:no_cams
%for iCam = 1:no_cams
    %clf;
    figure;
    rx = [1 0 0; 0 -1 0; 0 0 -1];
    ry = [-1 0 0; 0 1 0; 0 0 -1];
    rz = [-1 0 0; 0 -1 0; 0 0 1];
    
    rot2 = rotateQuaternion([1 1 0], pi/2);
    rot3 = rotateQuaternion([0 0 1], 8*pi/5);
    rot4 = rotateQuaternion([0 1 0], pi/6);
    rot5 = rotateQuaternion([0 1 0], -pi/8);
    
    normP_opt = rot5*rot4*rot3*rot2*rx*P_opt(:,:,iCam);
    %normP_opt = AngleAxisRotatePts([0 0 0]', P_opt(:,:,iCam));
    ptX = normP_opt(1,:);
    ptY = normP_opt(2,:);
    ptZ = normP_opt(3,:);

    %view(0, 90);
    %trimesh(TRI, ptX, ptY, ptZ);
    
    trisurf(TRI, ptX, ptY, ptZ);
    %scatter3(ptX, ptY, ptZ);
    %scatter(X(1,:), X(2,:))
    %scatter3(S(1,:), S(2,:), S(3,:));
    
    %xlabel('x');
    %ylabel('y');
    %zlabel('z');
    
    axis equal;
    
    % Save image to file
    imgpath = fullfile(figure_image_path,...
        [name '_Step' num2str(frame_step)], sprintf('%.5d', selectedFrames(iCam)));
    %print(imgpath, '-djpeg');
end

a = 3;

end




