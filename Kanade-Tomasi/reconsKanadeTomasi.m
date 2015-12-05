function reconsKanadeTomasi()

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

R = U1*sqrt_S1;
S = sqrt_S1*K1;

ptSet = 1:size(X,2);
rm_set = [];
ptSet(rm_set) = [];

ptX = S(1,ptSet);
ptY = S(2,ptSet);
ptZ = S(3,ptSet);

figure(1);

% Added code to test delaunay triangulation generator
TRI = delaunay(S(1,:), S(2,:));
grid off;
TRI = removeTriangle(36:41, TRI);
TRI = removeTriangle(42:47, TRI);
TRI = removeTriangle(60:67, TRI);
trimesh(TRI, ptX, ptY, ptZ);

figure(2);
scatter3(ptX, ptY, ptZ);
axis equal;

hold;
% Draw labels
for i = 1:size(X,2);
    text(ptX(1,i), ptY(1,i), ptZ(1,i), num2str(i));
end

a = 3;

end