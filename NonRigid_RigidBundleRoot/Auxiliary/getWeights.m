% This is the weight for optimize rotation matrix, so we do not care about
% the dynamic parts of the face

function weight = getWeights()

%% Static points
weight([1:2 14:16]) = 10;
weight(27:30) = 10;
weight(17:21) = 10;
weight(22:26) = 10;
weight(31:35) = 10;
weight(36:41) = 10;
weight(42:47) = 10;

%% Dynamic points
weight(3:13) = 3;
weight(48:54) = 1;
weight(60:64) = 1;
weight(55:59) = 1;
weight(65:67) = 1;


end