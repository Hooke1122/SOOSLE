function Lower = LBoundByDP(B0,in_num,P0,D0) 

global ai;
B0 = sort(B0);
Pi = P0(B0);
Di = D0(B0);
JobAll = sum(Pi);
P = GetTimeLearning(1,1,JobAll-1 + in_num,ai);
t = GetTimeLearning(in_num,1,0,ai);
Px = Pi*P;

[Order Lower] = mainBBDPStartt(Px,Di,t);


