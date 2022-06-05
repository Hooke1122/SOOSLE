function [ResultOrder Result] = DealwithB(B0,in_num,P0,D0,Deep)
global ai;
global Limit
global split_list;
global decom_listBA;
global decom_listDetail;
Deep = Deep + 1;

Pi = P0(B0);
Di = D0(B0);

[B B_FromNum B_num] = Split(B0,in_num,P0,D0); 
Bsize = size(B,2);
split_list = [split_list;size(B0,2) Deep Bsize size(find(B_num==1),2) size(find(B_num>1 & B_num<=11),2)...
    size(find(B_num>11 & B_num<=21),2) size(find(B_num>21 & B_num<=31),2) size(find(B_num>31 & B_num<=41),2) size(find(B_num>41 & B_num<=51),2)...
    size(find(B_num>51 & B_num<=61),2) size(find(B_num>61 & B_num<=71),2) size(find(B_num>71 & B_num<=81),2)];

if size(find(B_num>1),2)==0
    ResultOrder = cell2mat(B);
    Result = B_FromNum;
    return;
end
B_return = [];
B_FromTime_return = [];
for i = 1 : Bsize
    BsizeSub = size(B{1,i},2);
    if BsizeSub>1
        [ResultDecomposed DecomResult] = decomposed(B{1,i},B_FromNum(1,i),P0,D0);    

       %% 
        [order UB FromTime] = UBoundByOMDD(B{1,i},B_FromNum(1,i),P0,D0);
       %% limit
        if toc > Limit
            B_return = [B_return order];
            B_FromTime_return = [B_FromTime_return FromTime];
            continue;
        end
       %% limit
        nodeNum = size(ResultDecomposed,1);    
        Elimite = [];
        Lower_recorde = [];
        for j = 1:nodeNum
            T_Lower = 0;
          %% Part1
            Part1 = ResultDecomposed(j,1:DecomResult(j)-1);
            if size(Part1,2)==1
                Lower1 = max([GetTimeLearning(B_FromNum(1,i)+P0(Part1),1,0,ai)-D0(Part1) 0]);     
                T_Lower = T_Lower + Lower1;
            elseif size(Part1,2)>1
                Lower1 = LBoundByDP(Part1,B_FromNum(1,i),P0,D0);  
                T_Lower = T_Lower + Lower1;
            end
            
          %% Part2            
            Lower2 = max([GetTimeLearning(B_FromNum(1,i)+sum(P0(ResultDecomposed(j,1:DecomResult(j)))),1,0,ai)-D0(ResultDecomposed(j,DecomResult(j))) 0]);    
            T_Lower = T_Lower + Lower2;
            
          %% Part3 
            Part3 = ResultDecomposed(j,DecomResult(j)+1:end);
            if size(Part3,2)==1
                Lower3 = max([GetTimeLearning(B_FromNum(1,i)+sum(P0(ResultDecomposed(j,:)),1,0,ai))-D0(Part3) 0]);  
                T_Lower = T_Lower + Lower3;
            elseif size(Part3,2)>1
                Lower3 = LBoundByDP(Part3,B_FromNum(1,i) + sum(P0(ResultDecomposed(j,1:DecomResult(j)))),P0,D0);   
                T_Lower = T_Lower + Lower3;
            end
            Lower_recorde = [Lower_recorde T_Lower];
            isInitial = 0;
            if T_Lower > UB
                isInitial = 1;
                Elimite = [Elimite j];                
            end
            decom_listDetail = [decom_listDetail;BsizeSub Deep nodeNum DecomResult(j) isInitial];
        end 
        
        decom_listBA = [decom_listBA;BsizeSub Deep nodeNum size(Elimite,2)];
       %% LB
        nodeNum = size(ResultDecomposed,1);    
        T_comparision = [];
        B_temp_prime = [];
        B_FromTime_temp_prime = [];
        for j = 1:nodeNum
            if size(find(Elimite==j),2)>0 
                continue;
            end
            B_temp = [];
            B_FromTime_temp = [];           
          %% Part1
            Part1 = ResultDecomposed(j,1:DecomResult(j)-1);
            if size(Part1,2)==1
                B_temp = [B_temp ResultDecomposed(j,DecomResult(j)-1)];
                B_FromTime_temp = [B_FromTime_temp B_FromNum(1,i)];               
            elseif size(Part1,2)>1
                Lower = LBoundByDP(Part1,B_FromNum(1,i),P0,D0);
                [ResultOrderi Resulti] = DealwithB(Part1,B_FromNum(1,i),P0,D0,Deep);   
                B_temp = [B_temp ResultOrderi];
                B_FromTime_temp = [B_FromTime_temp Resulti];                
            end
            
          %% Part2            
            B_temp = [B_temp ResultDecomposed(j,DecomResult(j))];
            if size(B_FromTime_temp,2) == 0
                B_FromTime_temp = [B_FromTime_temp B_FromNum(1,i)];
            else
                B_FromTime_temp = [B_FromTime_temp B_FromTime_temp(1,end)+P0(B_temp(1,end-1))];
            end
            
          %% Part3 
            Part3 = ResultDecomposed(j,DecomResult(j)+1:end);
            if size(Part3,2)==1
                B_temp = [B_temp ResultDecomposed(j,DecomResult(j)+1)];
                B_FromTime_temp = [B_FromTime_temp B_FromTime_temp(1,end)+P0(B_temp(1,end-1))]; 
            elseif size(Part3,2)>1
                [ResultOrderi Resulti] = DealwithB(Part3,B_FromTime_temp(1,end)+P0(ResultDecomposed(j,DecomResult(j))),P0,D0,Deep);   
                B_temp = [B_temp ResultOrderi];
                B_FromTime_temp = [B_FromTime_temp Resulti];                
            end  
            cumsumTemp = [];
            for k = 1:size(B_FromTime_temp,2)
                cumsumTemp = [cumsumTemp GetTimeLearning(B_FromTime_temp(k) + P0(B_temp(k)),1,0,ai) - D0(B_temp(k))];
            end
            T_comparision = [T_comparision sum(cumsumTemp(find(cumsumTemp > 0)))];
            B_temp_prime = [B_temp_prime;B_temp];
            B_FromTime_temp_prime = [B_FromTime_temp_prime;B_FromTime_temp];
        end

        decide = find(T_comparision==min(T_comparision));     
        B_return = [B_return B_temp_prime(decide(1),1:end)];
        B_FromTime_return = [B_FromTime_return B_FromTime_temp_prime(decide(1),1:end)];

    else
        B_return = [B_return B{1,i}];
        B_FromTime_return = [B_FromTime_return B_FromNum(1,i)];
    end    
end
ResultOrder = B_return;
Result = B_FromTime_return;
