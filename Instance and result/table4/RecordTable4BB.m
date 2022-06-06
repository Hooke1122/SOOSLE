function RecordTable4BB
clc;
clear all;
Recordxls = [];
for N = 60:20:140
    for nmax = 100:40:220
        for tandR = 2:2
            for ai = 15:15
                recordB = [];
                recordC = [];
                recordA = [];
                mark = 0;
                markrate = 0;
                for TestTime = 1:20
                    try
                        xls = sprintf('E3_right0426-tandR%d-N%d-nmax%d-ai%d-TestTime%d',tandR,N,nmax,ai,TestTime)
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
                    Recordxls = [Recordxls;tandR N ai nmax TestTime+1 0 mean(recordA) 0 max(recordA) 1 mean(recordB) 2 max(recordB) 3 mean(recordC) 4 max(recordC) 5 markrate];
                else
                    Recordxls = [Recordxls;tandR N ai nmax TestTime+1 [0 0 0 0 0 0 0 0 0]];
                end
            end
        end
    end
end
xlswrite('RecordTable4BB', Recordxls);