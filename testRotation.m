function testRotation()

P = [7; 11; 11];
rot = [1/sqrt(2) -1/sqrt(2) 0; 1/sqrt(2) 1/sqrt(2) 0; 0 0 1];
angleaxis = RotationMatrix2AngleAxis(rot);

P1 = rot*P;
P2 = AngleAxisRotatePts(angleaxis, P);

a = 3;

end