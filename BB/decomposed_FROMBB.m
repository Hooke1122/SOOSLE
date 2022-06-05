function [Result DecomResult] = decomposed_FROMBB(B0,t,P0,D0)
[~, B0order] = sort(D0(B0));
B =B0(B0order);

%% start
n = size(B,2);
s = find(B == max(B));
DecomResult = [];
Result = [];
for i = s:n
    temp = B(s);
    tempB = B;
    tempB(s) = [];
    modifiedB = [tempB(1,1:i-1) temp tempB(1,i:end)];
    Ci = cumsum(P0(modifiedB(1,1:i))) + t;
    Tall = cumsum(P0(modifiedB(1,end))) + t - D0(modifiedB(1,1:end));
    TT = sum(Tall(find(Tall > 0)));
    %% rule1
    if i<=n-1 && i>=s &&  Ci(end)> D0(modifiedB(i+1));
        continue;
    end
    %% rule2
    if i<=n && i>=s + 1  &&  Ci(end)<= D0(modifiedB(i-1)) + P0(modifiedB(i-1));
        continue;
    end
    %% rule3
    for j = s + 1:i-1
        if Ci(end)<= D0(modifiedB(j-1)) + P0(modifiedB(j-1))
            continue;
        end
    end
    %% rule4
    if i < n 
        modifiedBPlus = [tempB(1,1:i) temp tempB(1,i+1:end)];
        Plus = cumsum(P0(modifiedBPlus(1,1:end))) + t - D0(modifiedBPlus(1,1:end));
        CiPlus = sum(Plus(find(Plus>0)));
        if CiPlus < TT
            continue;
        end
    end
    if i > s 
            modifiedBMinus = [tempB(1,1:i-1) temp tempB(1,i-1:end)];
            Minus = cumsum(P0(modifiedBMinus(1,1:end))) + t - D0(modifiedBMinus(1,1:end));
            CiMinus = sum(Minus(find(Minus>0)));
        if CiMinus <= TT
            continue;
        end
    end
    for j = s:i-1
        modifiedBj = [tempB(1,1:j-1) temp tempB(1,j:end)];
        Cj = cumsum(P0(modifiedBj(1,end))) + t - D0(modifiedBj(1,1:end));
        TTj = sum(Cj(find(Cj > 0)));
        if TTj <= TT
            continue;
        end
    end        
    DecomResult = [DecomResult i];
    Result = [Result;modifiedB];
    
end
DecomResult;