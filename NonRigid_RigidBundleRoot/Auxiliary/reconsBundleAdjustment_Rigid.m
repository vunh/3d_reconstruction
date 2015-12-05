% This function computes the Tranformation matrices and 3D points using
% Bundle Adjustment (Levenberg-Marquardt)
% The matrices are formularized as for orthographic projections => we used
% the upper 2x3 of 3x3 rotation matrices. The 3x3 rotation matrices are
% parameterized using axis_angle representation (3 degrees of freedom)

% This function return the set of points 3xn and set of rotation matrices
% in form of 3xF

function [Points, AngleAxis] = reconsBundleAdjustment_Rigid (X)



%% Initilize matrices and 3D points
no_pts = size(X,2);
no_cams = size(X,1)/2;

initMat = [1/sqrt(2) -1/sqrt(2) 0; 1/sqrt(2) 1/sqrt(2) 0; 0 0 1];
init_angleaxis = RotationMatrix2AngleAxis(initMat);
% For matrices
for iCam = 1:no_cams
    Ag(:,iCam) = init_angleaxis';
end

% For 3D points
P(1:2,:) = X(1:2,:);
P(3,:) = 1;
P = ones(3, no_pts);

%% Doing optimization
agg = [Ag(:); P(:)];
options = optimoptions(@lsqnonlin,'Algorithm','levenberg-marquardt','Display','off');

[optm_res, resnorm] = lsqnonlin(@(variable) calResidual(X,variable), agg,[],[],options);
%disp(resnorm);



R_arr = optm_res(1:3*no_cams, 1);
P_arr = optm_res(3*no_cams+1:end, 1);
R_opt = reshape(R_arr, 3, []);
P_opt = reshape(P_arr, 3, []);

Points = P_opt;
AngleAxis = R_opt;

end




