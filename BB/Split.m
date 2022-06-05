function [B_end B_NumEndOut B_num_end] = Split(B0,in_num,P0,D0) 
global split_list1or2;
global ai;
B0 = sort(B0);
Pi = P0(B0);
Di = D0(B0);

%% split1
n = size(Pi,2);
Markmat = zeros(n,n);
N = sum(Pi)+in_num;
NL = N*ones(1,n);
NE = Pi+in_num;
ML = GetTimeLearning(N,1,0,ai);
L = ML*ones(1,n);
E = [];
for i = 1:n
    E = [E GetTimeLearning(NE(i),1,0,ai)];
end

countall = 0;
count1 = 0;
count11 = 0;
count12 = 0;
count2 = 0;


mark = 1;
while mark == 1
    countall = countall + 1;
    mark = 0;
    for i = 1 : n
        for j = i+1 : n
            if Markmat(i,j)==1
                continue;
            end
            if Di(i)<=Di(j) || E(j)>=Di(i)                
                count1 = count1 + 1;
                if Di(i)<=Di(j)
                    count11 = count11 + 1;
                end
                if E(j)>=Di(i)
                    count12 = count12 + 1;
                end
                Markmat(i,j) = 1;
                NE(j) = NE(j) + Pi(i);
                NL(i) = NL(i) - Pi(j);
                mark = 1;
                E(j) = GetTimeLearning(NE(j),1,0,ai);
                L(i) = ML-GetTimeLearning(N-NL(i),1,NL(i),ai);
            end
            if Di(i)>Di(j) && L(j)<=Di(i)+GetTimeLearning(Pi(i),1,NL(j)-Pi(i),ai) && E(j)<Di(i)
                count2 = count2 + 1;
                Markmat(i,j) = 1;
                NL(j) = NL(j) - Pi(i);
                NE(i) = NE(i) + Pi(j);
                mark = 1;
                E(i) = GetTimeLearning(NE(i),1,0,ai);
                L(j) = ML-GetTimeLearning(N-NL(j),1,NL(j),ai);
            end
        end
    end
end
split_list1or2 = [split_list1or2; size(B0,2) countall count1 count11 count12 count2];

[EDDEi,SplitEi] = sort(NE);
    y1 = [];
    y2 = [];
    for x = 1:n
        if abs(NE(x)-NL(x))< 0.00001
            y1 = [x y1];
            y2 = [find(SplitEi == x) y2];
        end
    end    
y2 = sort(y2);
m = size(y2,2);

if m ==0
    B_end = {B0};
    B_num_end = n;
    B_NumEndOut = in_num;
    return;
end

B = {};
B_num = [];%% single Block
B_NumEnd = [];
for i = 1 : m
    if i ==1 && y2(1)==1
        B = [B B0(SplitEi(1,y2(1)))];
        B_num = [B_num 1];
        B_NumEnd = [B_NumEnd in_num];
    end
    if i ==1 && y2(1)~=1
        B = [B B0(SplitEi(1,1:y2(1)-1)) B0(SplitEi(1,y2(1)))];
        BeforeNum = SplitEi(1,y2(1));
        B_num = [B_num y2(1)-1 1];
        B_NumEnd = [B_NumEnd in_num NE(BeforeNum)-Pi(BeforeNum)];
    end
    if i > 1 && y2(i)-y2(i-1)==1
        B = [B B0(SplitEi(1,y2(i)))];
        BeforeNum = SplitEi(1,y2(i));
        B_num = [B_num 1];
        B_NumEnd = [B_NumEnd NE(BeforeNum)-Pi(BeforeNum)];
    end
    if i > 1 && y2(i)-y2(i-1)>1
        B = [B B0(SplitEi(1,y2(i-1)+1:y2(i)-1)) B0(SplitEi(1,y2(i)))];
        BeforeNum1 = SplitEi(1,y2(i-1));
        BeforeNum = SplitEi(1,y2(i));
        B_num = [B_num y2(i)-y2(i-1)-1 1];
        B_NumEnd = [B_NumEnd NE(BeforeNum1) NE(BeforeNum)-Pi(BeforeNum)];
    end
    if m == i && y2(m) ~= n
        B = [B B0(SplitEi(1,y2(m)+1:n))];
        BeforeNum = SplitEi(1,y2(m));
        B_num = [B_num n-y2(i)];
        B_NumEnd = [B_NumEnd NE(BeforeNum)];
    end
end

B_end = B;
B_num_end = B_num;
B_NumEndOut = B_NumEnd;
return;
