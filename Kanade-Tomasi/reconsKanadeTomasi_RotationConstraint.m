function reconsKanadeTomasi_RotationConstraint()

% Read points from file
M = dlmread('../Data/landmark_d1.txt');
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


%R = U1*sqrt_S1;
%S = sqrt_S1*K1;

ptX = S(1,:);
ptY = S(2,:);
ptZ = S(3,:);

figure;
scatter3(ptX, ptY, ptZ);

a = 3;

end