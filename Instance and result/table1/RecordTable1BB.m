function RecordTable1BB
clc;
clear all;
Recordxls = [];
for N = 9:3:18
    for nmax = 10:3:19
        for tandR = 2:2 
            for ai = 12:12
                recordB = [];
                recordC = [];
                recordA = [];
                mark = 0;
                markrate = 0;
                for TestTime = 1:20
                    try
                        xls = sprintf('BB-tandR%d-N%d-nmax%d-ai%d-TestTime%d',tandR,N,nmax,ai,TestTime)
                        A = xlsread(xls,'Sheet1');
                        recordA = [recordA;  sum(A(:,7))];
                        mark = mark + 1;
                        if A(7)>=3600
                            markrate = markrate + 1;
                        end
                    catch e
                        continue;                      
                    end
                end
                num = 20;
                if mark == num
                    Recordxls = [Recordxls;N nmax -0.01 0.5 0.5  mean(recordA) max(recordA) markrate];
                else
                    Recordxls = [Recordxls;N nmax -0.01 0.5 0.5  [0 0 0]];
                end
            end
        end
    end
end
xlswrite('RecordTable1BB', Recordxls);