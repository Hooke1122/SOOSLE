function [ResultOrder Result] = DealwithB_FROMBB(B0,t,P0,D0)
Pi = P0(B0);
Di = D0(B0);

[B B_FromTime B_num] = Split_FROMBB(B0,t,P0,D0); 
Bsize = size(B,2);

if size(find(B_num>1),2)==0
    ResultOrder = cell2mat(B);
    Result = B_FromTime;
    return;
end

B_return = [];
B_FromTime_return = [];

for i = 1 : Bsize
    BsizeSub = size(B{1,i},2);
    if BsizeSub>1
        [ResultDecomposed DecomResult] = decomposed_FROMBB(B{1,i},B_FromTime(1,i),P0,D0);
        T_comparision = [];
        B_temp_prime = [];
        B_FromTime_temp_prime = [];
        for j = 1:size(ResultDecomposed,1)    
            B_temp = [];
            B_FromTime_temp = [];           
          %% Part1
            Part1 = ResultDecomposed(j,1:DecomResult(j)-1);
            if size(Part1,2)==1
                B_temp = [B_temp ResultDecomposed(j,DecomResult(j)-1)];
                B_FromTime_temp = [B_FromTime_temp B_FromTime(1,i)];               
            elseif size(Part1,2)>1
                [ResultOrderi Resulti] = DealwithB_FROMBB(Part1,B_FromTime(1,i),P0,D0);   
                B_temp = [B_temp ResultOrderi];
                B_FromTime_temp = [B_FromTime_temp Resulti];                
            end
            
          %% Part2            
            B_temp = [B_temp ResultDecomposed(j,DecomResult(j))];
            if size(B_FromTime_temp,2) == 0
                B_FromTime_temp = [B_FromTime_temp B_FromTime(1,i)];
            else
                B_FromTime_temp = [B_FromTime_temp B_FromTime_temp(1,end)+P0(B_temp(1,end-1))];
            end
          %% Part3 
            Part3 = ResultDecomposed(j,DecomResult(j)+1:end);
            if size(Part3,2)==1
                B_temp = [B_temp ResultDecomposed(j,DecomResult(j)+1)];
                B_FromTime_temp = [B_FromTime_temp B_FromTime_temp(1,end)+P0(B_temp(1,end-1))]; 
            elseif size(Part3,2)>1
                [ResultOrderi Resulti] = DealwithB_FROMBB(Part3,B_FromTime_temp(1,end)+P0(ResultDecomposed(j,DecomResult(j))),P0,D0);   
                B_temp = [B_temp ResultOrderi];
                B_FromTime_temp = [B_FromTime_temp Resulti];                
            end  
            cumsumTemp = B_FromTime_temp + P0(B_temp) - D0(B_temp);
            T_comparision = [T_comparision sum(cumsumTemp(find(cumsumTemp > 0)))];
            B_temp_prime = [B_temp_prime;B_temp];
            B_FromTime_temp_prime = [B_FromTime_temp_prime;B_FromTime_temp];
        end
        decide = find(T_comparision==min(T_comparision));     
        B_return = [B_return B_temp_prime(decide(1),1:end)];
        B_FromTime_return = [B_FromTime_return B_FromTime_temp_prime(decide(1),1:end)];
    else
        B_return = [B_return B{1,i}];
        B_FromTime_return = [B_FromTime_return B_FromTime(1,i)];
    end    
end
ResultOrder = B_return;
Result = B_FromTime_return;
