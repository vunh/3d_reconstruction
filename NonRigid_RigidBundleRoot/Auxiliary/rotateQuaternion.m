function rotationMatrix = rotateQuaternion (axis, angle)

normaxis = axis/sqrt(sum(axis.^2));
ax = normaxis(1); ay = normaxis(2); az = normaxis(3);
c = cos(angle);
s = sin(angle);

rotationMatrix = [c + ax^2*(1 - c), ax*ay*(1-c) - az*s, ax*az*(1-c) + ay*s;...
                    ay*ax*(1-c) + az*s, c+ ay^2*(1-c), ay*az*(1-c) - ax*s;...
                    az*ax*(1-c) - ay*s, az*ay*(1-c) + ax*s, c + az^2*(1-c)];


end