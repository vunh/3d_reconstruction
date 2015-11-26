function residual = calResidualNonRigidFullMatrix (X, agg)

wPS = 500;
wVarPS = 500;

no_pts = size(X,2);
no_cams = size(X,1)/2;

R = agg(1:2*no_cams*3*no_cams);
R = reshape(R, 2*no_cams, 3*no_cams);
P = agg(2*no_cams*3*no_cams + 1:end);
P = reshape(P, 3*no_cams, no_pts);

PS = [];
for i = 1:no_cams
    PS(i,:) = [P(3*i-2,:), P(3*i-1,:), P(3*i,:)];
end
singularVals = svds(PS, min(no_cams, 3*no_pts));
singularVals = singularVals(:);
varPS = var(PS);


residual = X - R*P;
residual = residual(:);
% Display penalty values for observing
disp('---------------');
disp(sum(wVarPS*varPS(:) .^2));
disp(sum(wPS*PS(:) .^2));
disp(sum(residual(:) .^2));

% Aggregate Residual
residual = [residual; wPS*singularVals; wVarPS*varPS(:)];
end