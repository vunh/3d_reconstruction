function res = removeTriangle(boundary, tri)

res = tri;
rm_id = [];

for i = 1:size(tri, 1)
    if (all(ismember(tri(i,:), boundary)) == 1)
        rm_id = [rm_id i];
    end
end

res(rm_id,:) = [];

end