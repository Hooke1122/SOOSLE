function RecordFigure5
clc;
clear all;
Recordxls2 = [];
aa = [0 -0.01 -0.02 -0.04 -0.08 -0.16 -0.32 -0.64];
tR = {[0.5 0.25],[0.5 0.5],[0.5 0.75],[0.25 0.25],[0.25 0.5],[0.25 0.75],[0.75 0.25],[0.75 0.5],[0.75 0.75]};
for N = 80:20:80
    for nmax = 100:40:100
        for tandR = 1:9
            for ai = 15:15
                recordC = [];
                Recordxls = [];
                for TestTime = 1:20                       
                    xls = sprintf('E3_right2-tandR%d-N%d-nmax%d-ai%d-TestTime%d',tandR,N,nmax,ai,TestTime)                    
                    C = xlsread(xls,'split_list1or2');
                    recordC = [recordC;C(1,3:end)];                   
                end           
                Recordxls2 = [Recordxls2;tR{tandR} N ai nmax aa(ai-10) mean(recordC) mean(recordC(:,1))+mean(recordC(:,end))];
            end
        end
    end
end
xlswrite('RecordFigure5.xls', Recordxls2);