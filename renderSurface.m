function renderSurface(pX, pY, Itens, TRIV, imgWidth, imgHeight)

img = zeros(imgHeight, imgWidth);
img_depth = zeros(imgHeight, imgWidth);

nTriang = size(TRIV, 1);
for iTri = 1:nTriang
    p1 = [pY(TRIV(iTri, 1)) pX(TRIV(iTri, 1))];
    p2 = [pY(TRIV(iTri, 2)) pX(TRIV(iTri, 2))];
    p3 = [pY(TRIV(iTri, 3)) pX(TRIV(iTri, 3))];
    
    avgColor = mean([Itens(TRIV(iTri, 1)) Itens(TRIV(iTri, 2)) Itens(TRIV(iTri, 3))]);
    
    smallX = min([p1(2), p2(2), p3(2)]);
    largeX = max([p1(2), p2(2), p3(2)]);
    smallY = min([p1(1), p2(1), p3(1)]);
    largeY = max([p1(1), p2(1), p3(1)]);
    
    for iX = smallX:largeX
        for iY = smallY:largeY
            p = [iY, iX];
            if (checkSameSide(p, p3, p1, p2) == 1 && ...
                checkSameSide(p, p2, p1, p3) == 1 && ...
                checkSameSide(p, p1, p2, p3) == 1)

                % imgHeight - iY: to change from camera (y-axis up)
                % to pixel coordinatte (y-axis down)
                img(imgHeight - iY + 1, iX) = avgColor; 
                
                
            end
        end
    end
end

% figure;
% imshow(img);

end

function res = checkSameSide (pt1, pt2, org1, org2)
res = 0;
ax = pt1(2);
ay = pt1(1);
bx = pt2(2);
by = pt2(1);
x1 = org1(2);
y1 = org1(1);
x2 = org2(2);
y2 = org2(1);
if (((y1-y2)*(ax-x1)+(x2-x1)*(ay-y1))*((y1-y2)*(bx-x1)+(x2-x1)*(by-y1)) >= 0)
    res = 1;
else
    res = 0;
end


end





