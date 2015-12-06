function weight = getWeights3D()

%% Static points
weight([1:2 14:16]) = 10;
weight(27:30) = 10;
weight(17:21) = 10;
weight(22:26) = 10;
weight(31:35) = 10;
weight(36:41) = 10;
weight(42:47) = 10;

%% Dynamic points
weight(3:13) = 10;
weight(48:54) = 10;
weight(60:64) = 10;
weight(55:59) = 10;
weight(65:67) = 10;


end