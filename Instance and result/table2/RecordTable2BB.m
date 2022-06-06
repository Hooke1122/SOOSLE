function RecordTable2BB
clc;
clear all;
Recordxls = [];
aa = [0 -0.01 -0.02 -0.04 -0.08 -0.16 -0.32 -0.64];
for N = 12:3:12
    for nmax = 16:3:16
        for tandR = 2:2 
            for ai = 11:18
                recordB = [];
                recordC = [];
                recordA = [];
                mark = 0;
                markrate = 0;
                for TestTime = 1:20
                    try
                        A = [];
                        B = [];
                        C = [];
                        xls = sprintf('BB-tandR%d-N%d-nmax%d-ai%d-TestTime%d',tandR,N,nmax,ai,TestTime)
                        A = xlsread(xls,'Sheet1');
                        B = xlsread(xls,'decom_list');
                        recordA = [recordA;  sum(A(:,7))];
                        recordB = [recordB; sum(B(:,1)-B(:,2)+1) sum(B(:,end))];
                        
                        C = xlsread(xls,'decom_listBA');                        
                        recordC = [recordC; sum(C(:,3)) sum(C(:,4))];

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
                    Recordxls = [Recordxls;N nmax 0.5 0.5 aa(ai-10) 0 mean(recordA) 0 max(recordA) 1 mean(recordB) 2 max(recordB) markrate];
                else
                    Recordxls = [Recordxls;N nmax 0.5 0.5 aa(ai-10) [0 0 0 0 0 0 0 0 0 0 0]];
                end
            end
        end
    end
end
xlswrite('RecordTable2BB', Recordxls);