function calResidualNonRigid_AngleAxis(X, agg)

no_pts = size(X, 2);
no_cams = size(X, 1)/2;

% Separate and reshape agg
angle_axis_arr = agg(1:3*no_cams, 1);
P_arr = agg(3*no_cams + 1:end,1);
R = reshape(angle_axis_arr, 3, []);
P = reshape(P_arr, 3*no_cams, no_pts);

for i = 1:no_cams
    pt = P(3*i - 2:3*i,:);
    trP = AngleAxisRotatePts(R(:,iCam), pt);
    x = trP(1,:);
    y = trP(2,:);
end

end