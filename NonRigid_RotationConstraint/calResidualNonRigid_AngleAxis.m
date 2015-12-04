function res = calResidualNonRigid_AngleAxis(X, agg)

wPS = 50;
wVarPS = 50;

no_pts = size(X, 2);
no_cams = size(X, 1)/2;

% Separate and reshape agg
angle_axis_arr = agg(1:3*no_cams, 1);
P_arr = agg(3*no_cams + 1:end,1);
R = reshape(angle_axis_arr, 3, []);
P = reshape(P_arr, 3*no_cams, no_pts);

%% Rand of PS and variance of PS
PS = [];
for i = 1:no_cams
    PS(i,:) = [P(3*i-2,:), P(3*i-1,:), P(3*i,:)];
end
singularVals = svds(PS, min(no_cams, 3*no_pts));
singularVals = singularVals(:);
varPS = var(PS);

%% ReProjection Error
reprj = [];
for i = 1:no_cams
    pt = P(3*i - 2:3*i,:);
    trP = AngleAxisRotatePts(R(:,i), pt);
    reprj = [reprj; trP(1:2,:)];
%     x = trP(1,:);
%     y = trP(2,:);
%     deltaX = x - X(2*iCam - 1,:);
%     deltaY = y - X(2*iCam,:);
%     residual = [residual; [deltaX deltaY]];
end
residual = X - reprj;

%% Combine
res = [residual(:); wPS*singularVals; wVarPS*varPS(:)];
%res = residual(:);

end