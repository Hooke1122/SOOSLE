function RecordTable5
clc;
clear all;
Recordxls2 = [];
aa = [0 -0.01 -0.02 -0.04 -0.08 -0.16 -0.32 -0.64];
for N = 80:20:80
    for nmax = 100:40:100
        for tandR = 2:2
            for ai = 18:-1:11
                recordA = [];
                recordB = [];
                recordD = [];
                Recordxls = [];
                for TestTime = 1:20
                    try
                        xls = sprintf('E3_right2-tandR%d-N%d-nmax%d-ai%d-TestTime%d',tandR,N,nmax,ai,TestTime)
                        Sheet1 = xlsread(xls,'Sheet1');
                        A = xlsread(xls,'split_list');                        
                        B = xlsread(xls,'decom_list');
                        D = xlsread(xls,'decom_listBA');
                        recordA = [recordA;mean(A(:,3:end))];
                        recordB = [recordB;Sheet1(end) sum(B(:,3))/sum(B(:,1)-B(:,2)+1)  sum(B(:,4))/sum(B(:,1)-B(:,2)+1) sum(B(:,1)-B(:,2)+1-B(:,5))/sum(B(:,1)-B(:,2)+1)];
                        recordD = [recordD;sum(D(:,3)-D(:,4)) sum(D(:,4))/sum(D(:,3))];
                    catch err
                        continue;                      
                    end
                end
              
                Recordxls2 = [Recordxls2;tandR N ai nmax aa(ai-10) mean(recordA(:,1)) mean(recordB) 0 mean(recordD)];
            end
        end
    end
end
Recordxls;
xlswrite('RecordTable5.xls', Recordxls2);