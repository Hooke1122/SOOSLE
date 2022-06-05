function [ResultOrder T_comparision] = mainBBDPStartt(P0,D0,t);


[P0 SPT] = sort(P0);
D0 = D0(SPT);

N = size(P0,2);
B = 1:N;

% tic
[ResultOrder Result] = DealwithB_FROMBB(B,t,P0,D0);
cumsumTemp = Result + P0(ResultOrder) - D0(ResultOrder);
T_comparision = sum(cumsumTemp(find(cumsumTemp > 0)));
% toc