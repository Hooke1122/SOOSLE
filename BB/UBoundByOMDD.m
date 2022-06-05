function [order UpperBound FromTime] = UBoundByOMDD(B0,in_num,P0,D0) %f1当前确定的目标函数值（从后向前确定）；j1确定的订单号

global ai;
B0 = sort(B0);
Bi = B0;
Pi = P0(B0);
Di = D0(B0);
FromTime = [];
%% 
n = size(Pi,2);
t = in_num;     
lastTime = GetTimeLearning(in_num,1,0,ai);
sequence = [];
order = [];
T  = [];
for i = 1 : n
    FindMax = [];
    P = [];
    for j = 1 : n + 1 - i
        Pj = GetTimeLearning(Pi(j),1,t,ai);
        FindMax = [FindMax Pj+lastTime];
        P = [P Pj];
    end
    FindMax = [FindMax;Di];
    [max_d,~]=max(FindMax);
    index = find(max_d==min(max_d));
    sequence = [sequence Pi(index(1))];
    order = [order Bi(index(1))];
    DueDate = Di(index(1));
    Pi(:,index(1))=[];
    Di(:,index(1))=[];
    Bi(:,index(1))=[];
    t = sum(sequence(1,:)) + in_num;
    FromTime = [FromTime lastTime];
    lastTime = lastTime + P(index(1));    
    T = [T max([0 (lastTime - DueDate)])];
end
UpperBound = sum(T);


