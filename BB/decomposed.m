function [Result DecomResult] = decomposed(B0,in_num,P0,D0)
global ai;
global decom_list;
t = in_num;
%% start
[~, B0order] = sort(D0(B0));
B =B0(B0order);

n = size(B,2);
s = find(B == max(B));
DecomResult = [];
Result = [];
count1 = 0;
count2 = 0;
count3 = 0;
for i = s:n
    temp = B(s);
    tempB = B;
    tempB(s) = [];
    modifiedB = [tempB(1,1:i-1) temp tempB(1,i:end)];
	SumBeforei = sum(P0(modifiedB(1,1:i)));
    Ci = GetTimeLearning(SumBeforei + t,1,0,ai);
    isEliminate = false;
    %% rule1
    if i<=n-1 && i>=s &&  Ci>= D0(modifiedB(i+1))
        count1 = count1+1;
        isEliminate = true;
    end
    %% rule2
    for j = s+1:i
        if Ci< D0(modifiedB(j-1)) + GetTimeLearning(P0(modifiedB(j-1)),1,SumBeforei- P0(modifiedB(j-1))+t,ai)
            count3 = count3 + 1;
            isEliminate = true;
            break;
        end
    end
    if isEliminate
        continue;
    end
    
    DecomResult = [DecomResult i];
    Result = [Result;modifiedB];    
end
decom_list = [decom_list;n s count1 count3 size(DecomResult,2)];
DecomResult;