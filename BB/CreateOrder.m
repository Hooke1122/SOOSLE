close all
clc
clear all 
for N = 80:80
    for nmax = 100:10:100
        for TestTime = 1:20
            for ai = 16:18
                for tandR = 2:2
                    %% a
                    if ai == 11                    
                        a = 0;
                    end    
                    if ai == 12
                        a = -0.01;
                    end
                    if ai == 13
                        a = -0.02;
                    end    
                    if ai == 14
                        a = -0.04;
                    end    
                    if ai == 15
                        a = -0.08;
                    end    
                    if ai == 16
                        a = -0.16;
                    end    
                    if ai == 17
                        a = -0.32;
                    end    
                    if ai == 18
                        a = -0.64;
                    end
                    %% tandR
                    if tandR == 1
                        t=0.5;
                        R=0.25;
                    end
                    if tandR == 2
                        t=0.5;
                        R=0.5;
                    end
                    if tandR == 3
                        t = 0.5;
                        R = 0.75;
                    end
                    if tandR == 4
                        t = 0.25;
                        R = 0.25;
                    end
                    if tandR == 5
                        t = 0.25;
                        R = 0.5;
                    end
                    if tandR == 6
                        t = 0.25;
                        R = 0.75;
                    end
                    if tandR == 7
                        t = 0.75;
                        R = 0.25;
                    end
                    if tandR == 8
                        t = 0.75;
                        R = 0.5;
                    end
                    if tandR == 9
                        t = 0.75;
                        R = 0.75;  
                    end
                    %%
                    SNi  = randi([1 nmax],1,N);
                    sumN = sum(SNi);
                    C = GetTimeLearning(sumN,1,0,a);
                    SDi =unifrnd (C*(1-t-R/2), C*(1-t+R/2), 1,N);
                    SDi = sort(SDi);
                    xlswrite(sprintf('0414tandR%d-N%d-ai%d-nmax%d-TestTime%d.xls',tandR,N,ai,nmax,TestTime),[SNi;SDi],'80'); 
                end
            end
        end
    end
end