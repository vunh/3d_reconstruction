% R is 2x3xnCam matrix

function res = calculate_NonRigidResidual_Neutral (X, R, P)

% Stacking R by diagonal
no_cams = size(X,1)/2;
stR = zeros(2*no_cams, 3*no_cams);
for iCam = 1:no_cams
    stR(2*iCam-1:2*iCam, 3*iCam-2:3*iCam) = R(1:2,:,iCam);
end

reproj = stR*P;
res = X - reproj;

end