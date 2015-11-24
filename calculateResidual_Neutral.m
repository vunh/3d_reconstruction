% This function is used to calculate residual by every rigid 3d 
% reconstruction method (neutral)

function res = calculateResidual_Neutral (X, Tr, P)

St_T = [];
nTr = size(Tr, 3);
for i = 1:nTr
    St_T = [St_T; Tr(:,:,i)];
end

prP = St_T * P;
prP = prP(1:2,:);
delta = X - prP;

res = sum(delta(:) .^2);

end