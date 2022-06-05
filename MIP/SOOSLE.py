
#正式使用
# coding: utf-8

# In[3]:
from datetime import datetime
from gurobipy import *
import time
import math
import random
import xlwt
import sys
import os               # 导入os模块
class Logger(object):
    def __init__(self, fileN="Default.log"):
        self.terminal = sys.stdout
        self.log = open(fileN, "a")

    def write(self, message):
        self.terminal.write(message)
        self.log.write(message)

    def flush(self):
        pass

for TestTime in range(1, 21):
    for N in range(12,13,3):
        for nmax in range(16, 17, 3):
            for tandR in range(2, 3, 1):
                for ai in range(11, 12, 1):
                    start =time.clock();
                    #Parameters
                    SNi = [round(random.uniform(1, nmax)) for _ in range(0, N)];
                    Swi = [1 for _ in range(0, N)];
                    if ai == 11:
                        a = 0;
                    if ai == 12:
                        a = -0.02;
                    if ai == 13:
                        a = -0.08;
                    if ai == 14:
                        a = -0.16;
                    if ai == 15:
                        a = -0.32;
                    if ai == 16:
                        a = -0.64;
                    if ai == 17:
                        a = -0.01;
                    if ai == 18:
                        a = -0.04;

                    sumN = sum(SNi);
                    nJob = len(SNi);
                    SPii =[0 for i in range(sumN)];
                    SPii[0] = 1;
                    for j in range(1, sumN):
                        SPii[j] = j**a + SPii[j-1];

                    if tandR == 1:
                        t=0.5;
                        R=0.25;
                    if tandR == 2:
                        t=0.5;
                        R=0.5;
                    if tandR == 3:
                        t = 0.5;
                        R = 0.75;
                    if tandR == 4:
                        t=0.25;
                        R=0.25;
                    if tandR == 5:
                        t=0.25;
                        R=0.5;
                    if tandR == 6:
                        t = 0.25;
                        R = 0.75;
                    if tandR == 7:
                        t=0.75;
                        R=0.25;
                    if tandR == 8:
                        t=0.75;
                        R=0.5;
                    if tandR == 9:
                        t = 0.75;
                        R = 0.75;
                    if tandR == 10:
                        t=1;
                        R=0.25;
                    if tandR == 11:
                        t=1;
                        R=0.5;
                    if tandR == 12:
                        t = 1;
                        R = 0.75;

                    SDi = [round(random.uniform(SPii[sumN-1]*(1-t-R/2), SPii[sumN-1]*(1-t+R/2))) for _ in range(0, N)];
                    SDi.sort();

                    # Creating Model
                    model = Model("MODEL")
                    #Decision variables
                    Z = {}
                    T = {}
                    C = {}
                    S = {}

                    for j in range(0, sumN):
                        for r in range(0, nJob):
                            Z[j, r] = model.addVar(vtype=GRB.BINARY, name="Z%s" % str([j, r]))

                    for r in range(0, nJob):
                        T[r] = model.addVar(name="T%s" % str([r]))
                    for r in range(0, nJob):
                        C[r] = model.addVar(name="C%s" % str([r]))

                    for r in range(0, nJob):
                        for j in range(0, sumN):
                            S[r,j] = model.addVar(vtype=GRB.BINARY, name="S%s" % str([r,j]))#相邻作差

                    model.update();

                    # objective functions
                    model.setObjective(quicksum(Swi[r]*T[r] for r in range(0, nJob)), GRB.MINIMIZE)

                    # adding constriant
                    for r in range(0, nJob):
                        for j in range(0, sumN):
                            model.addConstr(C[r] >= Z[j,r] * SPii[j], "constriant0")

                    for r in range(0, nJob):
                        model.addConstr(C[r] >= 0, "constriant0")

                    for r in range(0, nJob):
                        model.addConstr(quicksum(Z[j,r] for j in range(0, sumN)) == SNi[r], "constriant2")

                    for j in range(0, sumN):
                        model.addConstr(quicksum(Z[j,r] for r in range(0, nJob)) == 1, "constriant3")

                    for r in range(0, nJob):
                        model.addConstr(Z[0, r] + Z[sumN-1, r]<=1, "constriant4")

                    for r in range(0, nJob):
                        model.addConstr(quicksum(S[r,j] for j in range(0, sumN)) == 2, "constriant5")

                    for r in range(0, nJob):
                        for j in range(0, sumN - 1):
                             model.addConstr(S[r,j] >= Z[j + 1, r] - Z[j, r], "constriant6")

                    for r in range(0, nJob):
                        for j in range(0, sumN - 1):
                             model.addConstr(S[r,j] >= Z[j, r] - Z[j + 1, r], "constriant7")

                    for r in range(0, nJob):
                        model.addConstr(S[r,sumN-1] >= Z[0, r] - Z[sumN-1, r], "constriant6")
                        model.addConstr(S[r,sumN-1] >= Z[sumN-1, r] - Z[0, r], "constriant7")

                    for r in range(0, nJob):
                        model.addConstr(T[r] >= C[r] - SDi[r], "constriant8")

                    for r in range(0, nJob):
                        model.addConstr(T[r] >= 0, "constriant9")

                    model.write("model.lp");
                    model.update();
                    model.setParam('TimeLimit', 3600);
                    model.optimize();
                    # Print solution
                    obj = model.getObjective()

                    print(SNi);
                    print(SDi);
                    print(sumN);

                    end = time.clock()
                    print('Running time: %s Seconds'%(end-start))

                    resultFile = xlwt.Workbook()
                    new_sheet = resultFile.add_sheet(str(N))
                    for i in range(0,N):
                        new_sheet.write(0, i, SNi[i])
                        new_sheet.write(1, i, SDi[i])

                    new_sheet.write(2, 0, obj.getValue())
                    new_sheet.write(3, 0, model.MIPGap)
                    new_sheet.write(4, 0, model.Runtime)
                    new_sheet.write(5, 0, model.NumVars)
                    new_sheet.write(6, 0, model.NumIntVars)
                    new_sheet.write(7, 0, model.NumBinVars)

                    new_sheet2 = resultFile.add_sheet(str("result"))
                    i = 0;
                    for j in range(0, sumN):
                        for r in range(0, nJob):
                            new_sheet2.write(i, 0, j)
                            new_sheet2.write(i, 1, r)
                            new_sheet2.write(i, 2, str(Z[j, r]))
                            i = i + 1
                    resultFile.save(r'tandR'+str(tandR)+'-N'+str(N)+'-ai'+str(ai)+'-nmax'+str(nmax)+'-TestTime'+str(TestTime)+'.xls')

