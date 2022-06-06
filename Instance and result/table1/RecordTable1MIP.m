function RecordTable1MIP
Recordxls = [];
for N = 9:3:18
    for nmax = 10:3:19
        for tandR = 2:2 
            for ai = 12:12
                sum1 = [];
                markrate = 0;
                mark = 0;
                for TestTime = 1:20
                    try
                        xls = sprintf('0414tandR%d-N%d-ai%d-nmax%d-TestTime%d',tandR,N,ai,nmax,TestTime)
                        A = xlsread(xls,num2str(N));
                        if A(5,1)>=3600
                            markrate = markrate+1;
                        end
                        mark = mark + 1;
                        sum1 = [sum1;A(4,1) A(5,1)];
                    catch
                        continue;                      
                    end
                end
                num = 20;
                if mark == num
                    Recordxls = [Recordxls;N nmax -0.01 0.5 0.5 sum(sum1)/num max(sum1) markrate];
                else
                    Recordxls = [Recordxls;N nmax -0.01 0.5 0.5 TestTime+1 [0 0 0 0 0 0 0 0 0]];
                end    
            end
        end
    end
end
xlswrite('RecordTable1MIP', Recordxls);