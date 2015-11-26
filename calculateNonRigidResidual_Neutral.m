function res = calculateNonRigidResidual_Neutral (X, R, P)

res = X - R*P;
res = res(:);

end