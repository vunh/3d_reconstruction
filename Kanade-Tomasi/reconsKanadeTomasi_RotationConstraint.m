function reconsKanadeTomasi_RotationConstraint()

% Read points from file
M = dlmread('../../Data/landmark_d1.txt');
M = M(:,2:end);     % Eliminate the first number of each frame

X =[];
for i = 1:size(M,1)
    X(2*i - 1,:) = M(i,1:2:end);
    X(2*i, :) = M(i,2:2:end);
end

X_avg = sum(X,2) ./ size(X,2);
X_avg = repmat(X_avg, 1, size(X,2));
X = X - X_avg;

[U, S, V] = svd(X, 0);
U1 = U(:,1:3);
S1 = S(1:3,1:3);
sqrt_S1 = sqrt(S1);
K = V';
K1 = K(1:3,:);

% Calculate 3x3 transformation matrix Q where R = UQ and P = Q^-1*S*V'
Q = solveForQ(U1);

R = U1*Q;
S = inv(Q)*S1*K1;

ptX = S(1,:);
ptY = S(2,:);
ptZ = S(3,:);

figure;
scatter3(ptX, ptY, ptZ);

a = 3;

end

function res = solveForQ (U)

no_cams = size(U, 1)/2;
for iCam = 1:no_cams
    u11 = U(2*iCam - 1, 1);
    u12 = U(2*iCam - 1, 2);
    u13 = U(2*iCam - 1, 3);
    u21 = U(2*iCam, 1);
    u22 = U(2*iCam, 2);
    u23 = U(2*iCam, 3);
    A(3*iCam - 2,:) = [u11^2 u12^2 u13^2 u11^2 u12^2 u13^2 u11^2 u12^2 u13^2];
    A(3*iCam - 1,:) = [u21^2 u22^2 u23^2 u21^2 u22^2 u23^2 u21^2 u22^2 u23^2];
    A(3*iCam, :) = [u11*u21 u12*u21 u13*u21 u11*u22 u12*u22 u13*u22 u11*u23 u12*u23 u13*u23];
    b(3*iCam - 2: 3*iCam, 1) = [1; 1; 0];
end

q = A\b;

CQ = [q(1) q(2) q(3); q(4) q(5) q(6); q(7) q(8) q(9)];
Q = chol(CQ);
res = Q;

end








