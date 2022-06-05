%%
clc;
clear all;
global ai;
global node_split;
global split_list;
global split_list1or2;
global decom_list;
global node_decom;
global cut_count;
global Limit;
global decom_listBA;
global decom_listDetail;

Limit = 3600;
aa = [0 -0.01 -0.02 -0.04 -0.08 -0.16 -0.32 -0.64];

for N = 60:20:60
    for nmax = 100:40:220
        for tandR = 2:2 
            for a = 15:15
            	for TestTime = 1:20    
                    Recordxls = [];
                    Recordxls2 = [];
                    xls = sprintf('0414tandR%d-N%d-ai%d-nmax%d-TestTime%d',tandR,N,a,nmax,TestTime)
                    try
                    A = xlsread(xls,num2str(N));                
                        P0 = A(1,:);
                        D0 = round(A(2,:));            

                        [D0 EDD] = sort(D0);
                        P0 = P0(EDD);
                        [P0 SPT] = sort(P0);
                        D0 = D0(SPT);
                        
                        B = 1:N;
                        in_num = 0;
                        ai = aa(a-10);
                        node_split = 0;
                        node_decom = 0;
                        cut_count = 0;
                        split_list = [];
                        decom_list = [];
                        decom_listBA = [];
                        split_list1or2 = [];
                        decom_listDetail = [];
                        tic
                        [ResultOrder Result] = DealwithB(B,in_num,P0,D0,1);
                        cumsumTemp = [];
                        for k = 1:size(ResultOrder,2)
                            cumsumTemp = [cumsumTemp GetTimeLearning(Result(k) + P0(ResultOrder(k)),1,0,ai) - D0(ResultOrder(k))];
                        end
                        T_comparision = sum(cumsumTemp(find(cumsumTemp > 0)));
                        Recordxls = [Recordxls;tandR N a nmax TestTime+1 T_comparision toc];  
                        Min = FmainTestTool(P0,D0,ResultOrder,ai);
                        
                        Recordxls2 = [Recordxls2;tandR N a nmax TestTime+1 Min];  
                        xlswrite(sprintf('E3_right0426-tandR%d-N%d-nmax%d-ai%d-TestTime%d',tandR,N,nmax,a,TestTime), Recordxls);
                        xlswrite(sprintf('E3_right0426-tandR%d-N%d-nmax%d-ai%d-TestTime%d',tandR,N,nmax,a,TestTime),Recordxls2,'Recordxls2');
                        xlswrite(sprintf('E3_right0426-tandR%d-N%d-nmax%d-ai%d-TestTime%d',tandR,N,nmax,a,TestTime),ResultOrder,'ResultOrder');
                        xlswrite(sprintf('E3_right0426-tandR%d-N%d-nmax%d-ai%d-TestTime%d',tandR,N,nmax,a,TestTime),split_list,'split_list');
                        xlswrite(sprintf('E3_right0426-tandR%d-N%d-nmax%d-ai%d-TestTime%d',tandR,N,nmax,a,TestTime),decom_list,'decom_list');
                        xlswrite(sprintf('E3_right0426-tandR%d-N%d-nmax%d-ai%d-TestTime%d',tandR,N,nmax,a,TestTime),split_list1or2,'split_list1or2');
                        xlswrite(sprintf('E3_right0426-tandR%d-N%d-nmax%d-ai%d-TestTime%d',tandR,N,nmax,a,TestTime),decom_listBA,'decom_listBA');
                        xlswrite(sprintf('E3_right0426-tandR%d-N%d-nmax%d-ai%d-TestTime%d',tandR,N,nmax,a,TestTime),decom_listDetail,'decom_listDetail');
                    catch err
                        xlswrite(sprintf('E3_right_null-tandR%d-N%d-nmax%d-ai%d-TestTime%d',tandR,N,nmax,a,TestTime),[0]);                        
                    end
                end
            end
        end
    end
end