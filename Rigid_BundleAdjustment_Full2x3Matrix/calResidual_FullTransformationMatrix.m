%% Function for calculate residual
function res = calResidual_FullTransformationMatrix (X, agg)

%% Split agg to set of rotation matrices R and set of points P
no_cams = size(X,1)/2;
R_arr = agg(1:3*3*no_cams, 1);
P_arr = agg(3*3*no_cams+1:end, 1);
R = reshape(R_arr, 3, 3, []);
P = reshape(P_arr, 3, []);

%% Doing transformation and calculate the reprojection error
residual = [];
for iCam = 1:size(R,3)
    % Transform P using R
    trP = R(:,:,iCam)*P;
    x = trP(1,:);
    y = trP(2,:);
    deltaX = x - X(2*iCam - 1,:);
    deltaY = y - X(2*iCam,:);
    residual = [residual; [deltaX deltaY]];
end

res = residual(:);

end