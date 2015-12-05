function residual = residual3DPoints (X, rootModel, angle_axis, P_flat)
weights2D = getWeights2D();
weights3D = getWeights3D();
weights3D = repmat(weights3D, 3, 1);

P = reshape(P_flat, 3, []);

resi2D = [];
resi3D = [];

%% ReProjection Residual (2D)
trP = AngleAxisRotatePts(angle_axis, P);
x = trP(1,:);
y = trP(2,:);
deltaX = x - X(1,:);
deltaY = y - X(2,:);
resi2D = [resi2D; [deltaX.*weights2D deltaY.*weights2D]];

%% Residual compared to root (3D)
resi3D = (P - rootModel) .* weights3D;

residual = [3*resi2D(:); resi3D(:)];

end