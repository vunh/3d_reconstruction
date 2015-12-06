function weight = getWeights2D()

%% Static points
weight([1:2 14:16]) = 1;
weight(27:30) = 1;
weight(17:21) = 1;
weight(22:26) = 1;
weight(31:35) = 1;
weight(36:41) = 1;
weight(42:47) = 1;

%% Dynamic points
weight(3:13) = 10;
weight(48:54) = 10;
weight(60:64) = 10;
weight(55:59) = 10;
weight(65:67) = 10;


end