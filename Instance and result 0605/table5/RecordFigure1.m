function RecordFigure1
clc;
clear all;
Recordxls2 = [];
aa = [0 -0.01 -0.02 -0.04 -0.08 -0.16 -0.32 -0.64];
for N = 80:20:80
    for nmax = 100:40:100
        for tandR = 2:2 
            for ai = 18:-1:11
                Recordxls = [];
                for TestTime = 1:20
                    try
                        xls = sprintf('E3_right2-tandR%d-N%d-nmax%d-ai%d-TestTime%d',tandR,N,nmax,ai,TestTime)
                        B = xlsread(xls,'decom_listBA');
                        DeepNumdecom = [];
		                DeepNumdecom(1) = 1;
                        for deep = 2:80
                            DeepNumdecom(deep) = sum(B(find(B(:,2)==deep),3) - B(find(B(:,2)==deep),4));
                        end
                        Recordxls = [Recordxls;DeepNumdecom]; 
                    catch err
                        continue;                      
                    end
                end
                Recordxls2 = [Recordxls2;tandR N ai nmax aa(ai-10) mean(Recordxls)];
            end
        end
    end
end
xlswrite('RecordFigure1.xls', Recordxls2);