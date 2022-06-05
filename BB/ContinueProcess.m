function [RealPi RealS RealJob]= ContinueProcess(Oi,ai)
nSize = size(Oi,2);
RealPi = [];
for i = 1:nSize
    if i == 1
        RealJob = 0; 
        RealS = 0; 
    elseif RealS == Oi(4,i)
        RealJob = RealJob;
    else
        RealJob = 0;
    end      
    RealPi = [RealPi GetTimeLearning(Oi(1,i),Oi(3,i),RealJob,ai)];    
    RealJob = RealJob + Oi(1,i);  
    RealS = Oi(4,i);   
end