function [B_end B_TimeEnd B_num_end] = Split_FROMBB(B0,t,P0,D0) 

B0 = sort(B0);
Pi = P0(B0);
Di = D0(B0);

%% split1
PDi = Pi + Di;
N = size(Pi,2);
n = N;
P = sum(Pi);
Ei = Pi + t;
Li = P*ones(1,N) + t;


for j  = N:-1:1
    if j ~= N
        Pi = Pi(1,1:end-1);
        Di = Di(1,1:end-1);
        PDi = Pi + Di;
        n = size(Pi,2);
        P = sum(Pi);
    end
    
    [EDD1,EDD2] = sort(Di);
    J  = find(EDD2 == n);

    [PD1,PD2] = sort(PDi);

    %% Step1
    for i = 1 : J - 1 %EDD次序
        Ei(n) = Ei(n) + Pi(EDD2(i));
        Li(EDD2(i)) = Li(EDD2(i)) - Pi(n);
        BorA = 1;
    end

    %% Step2
    for i = J + 1 : n %EDD次序
        if Ei(n) >= Di(EDD2(i))
            Ei(n) = Ei(n) + Pi(EDD2(i));
            Li(EDD2(i)) = Li(EDD2(i)) - Pi(n); 
        else
            break;
        end    
    end

    %% Step3
    for i = n : -1 : 1 %PD次序
        if Li(n) <= Di(PD2(i)) + Pi(PD2(i))
            if Di(PD2(i)) > Ei(n) && Di(PD2(i)) > Di(n)
                Li(n) = Li(n) - Pi(PD2(i));
                Ei(PD2(i)) = Ei(PD2(i)) + Pi(n);
            end
        else
            break;
        end    
    end
end

[EDDEi,SplitEi] = sort(Ei);
    y1 = [];
    y2 = [];
    for x = 1:N
        if abs(Ei(x)-Li(x))< 0.00001
            y1 = [x y1];
            y2 = [find(SplitEi == x) y2];
        end
    end    
y2 = sort(y2);
m = size(y2,2);
if m ==0
    B_end = {B0};
    B_TimeEnd = t;
    B_num_end = N;
    return;
end
B = {};
B_FromTime = [];% 开始时间
CUMS = cumsum(P0(B0(SplitEi)));
B_num = [];%% single Block

for i = 1 : m
    if i ==1 && y2(1)==1
        B = [B B0(SplitEi(1,y2(1)))];
        B_FromTime = [B_FromTime t];
        B_num = [B_num 1];
    end
    if i ==1 && y2(1)~=1
        B = [B B0(SplitEi(1,1:y2(1)-1)) B0(SplitEi(1,y2(1)))];
        B_FromTime = [B_FromTime t CUMS(y2(1)-1)+t];
        B_num = [B_num y2(1)-1 1];
    end
    if i > 1 && y2(i)-y2(i-1)==1
        B = [B B0(SplitEi(1,y2(i)))];
        B_FromTime = [B_FromTime CUMS(y2(i)-1)+t];
        B_num = [B_num 1];
    end
    if i > 1 && y2(i)-y2(i-1)>1
        B = [B B0(SplitEi(1,y2(i-1)+1:y2(i)-1)) B0(SplitEi(1,y2(i)))];
        B_FromTime = [B_FromTime CUMS(y2(i-1))+t  CUMS(y2(i)-1)+t];
        B_num = [B_num y2(i)-y2(i-1)-1 1];
    end
    if m == i && y2(m) ~= N
        B = [B B0(SplitEi(1,y2(m)+1:N))];
        B_FromTime = [B_FromTime CUMS(y2(m))+t];
        B_num = [B_num N-y2(i)];
    end
end

B_end = B;
B_TimeEnd = B_FromTime;
B_num_end = B_num;
return;
Bnum = size(B,2);
%% Two-block split2
B2mark = zeros(1,Bnum);
Split1 = find(B_num > 1);
B2 = {};
for i = 1 : size(Split1,2)
    Ei2 = Ei(B{1,Split1(i)});
    Li2 = Li(B{1,Split1(i)});
    n2 = size(B{1,Split1(i)},2);
    [Ei2DD Ei2DDorder] = sort(Ei2);
    if n2 >= 2
        Li22 = Li2(Ei2DDorder);
        B22 = [];
        for j = 2:n2
            if max(max(Li22(1,1:j-1))) <= Ei2DD(j)
               B22 = [B22 j]; 
            end
        end
    end
    Splittemp = {};
    SplittempTime = [];
    n2 = size(B22,2);
    if n2 > 0
        cumsumEi = cumsum(Pi(B{1,Split1(i)}(Ei2DDorder))) + B_FromTime(1,Split1(i));
        for k = 1:n2
            if k == 1
                Splittemp = [Splittemp Ei2DDorder(1,1:B22(k)-1)];
                SplittempTime = [SplittempTime ];
            else
                Splittemp = [Splittemp Ei2DDorder(1,B22(k-1):B22(k)-1)];
                SplittempTime = [SplittempTime B_FromTime(1,Split1(i))];
            end
            if k == size(B22,2)
                Splittemp = [Splittemp Ei2DDorder(1,B22(k):end)];
            end
        end
        B2 = [B2 {Splittemp}];
        B2mark(Split1(i)) = 1;
        continue;
    end
end

if size(find(B2mark > 0),2) == 0
    B_end = B;
    B_TimeEnd = B_FromTime;
    return;
end
%% B_end
B_end = {};
B_TimeEnd = {};
xxxx = 1 ;
for i = 1:Bnum
    if B_num(i) == 1
        B_end = [B_end B(1,i)];
        B_TimeEnd = [B_TimeEnd B_FromTime(1,i)];
    else
        if B2mark(Split1(i)) == 1
            B_end = [B_end B2{xxxx}];
            xyx = [];
            for k = 1:size(B2{xxxx},2)
                xyx = [xyx B2{xxxx}(1,k)];                
            end
        else
            B_end = [B_end B(1,i)];
            B_TimeEnd = [B_TimeEnd B_FromTime(1,i)];        
        end
        xxxx = xxxx + 1; 
    end    
end
