function RecordTable3MIP
Recordxls = [];
tR = {[0.5 0.25],[0.5 0.5],[0.5 0.75],[0.25 0.25],[0.25 0.5],[0.25 0.75],[0.75 0.25],[0.75 0.5],[0.75 0.75]};

for N = 12:20:12
    for nmax = 19:40:19
        for tandR = 1:9
            for ai = 12:12
                sum1 = [];
                mark = 0;
                markrate = 0;
                for TestTime = 1:20
                    try
                        xls = sprintf('0414tandR%d-N%d-ai%d-nmax%d-TestTime%d',tandR,N,ai,nmax,TestTime)
                        A = xlsread(xls,num2str(N));
                        if A(5,1)>=3600
                            markrate = markrate+1;
                        end
                        mark = mark + 1;
                        sum1 = [sum1;A(4,1) A(5,1)];
                    catch e
                        continue;                      
                    end
                end
                num = 20;
                if mark == num
                    Recordxls = [Recordxls;N nmax -0.01 tR{tandR} sum(sum1)/num max(sum1) markrate];
                else
                    Recordxls = [Recordxls;N nmax -0.01 tR{tandR} [0 0 0 0 0 0 0 0 0]];
                end    
            end
        end
    end
end
xlswrite('RecordTable3MIP', Recordxls);