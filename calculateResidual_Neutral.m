% This function is used to calculate residual by every rigid 3d 
% reconstruction method (neutral)

function res = calculateResidual_Neutral (X, Tr, P)

St_T = [];
nTr = size(Tr, 3);
for i = 1:nTr
    St_T = [St_T; Tr(1:2,:,i)];
end

prP = St_T * P;
delta = X - prP;

res = delta;

end