N = 15;
nmax = 19;
tandR = 2;
a = 1;
TestTime = 8;  
xls = sprintf('0328tandR%d-N%d-ai%d-nmax%d-TestTime%d',tandR,N,a,nmax,TestTime);

A = xlsread(xls,num2str(N));      
ResultOrder = [3 1 2 4 5 6 7 10 9 11 13  15 14 8 12];
P0 = A(1,:);
D0 = round(A(2,:));  


ai = -0.01;
Min = FmainTestTool(P0,D0,ResultOrder,ai);

Min