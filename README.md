##  BB
Folder __BB__ contains the source code of BB. `BBmain` is the main function of the program, where the instances of BB calculation are determined by changing N, nmax, tandR, a, and TestTime.

__FmainTestTool__ is used to test if the BB result is correct.

The excel output of BB is named __BB-tandRX-NX-nmaxX-aiX-TestTimeX.xls__, where ***Sheet1*** records the result and time of BB run; ***split_list, split_list1or2, decom_list, decom_listBA, and decom_listDetail*** records the data of rules and bounding during BB calculation, which will be used in `RecordTableXBB` of __table1, table2, table3, table4, table5, table6__ in folder __Instance and result__.

## MIP
Folder __MIP__ contains the gurobi model of MIP `SOOSLE`, and the generated excel contains instance, result, calculation time and Gap, etc. These data will be used in the `RecordTableXMIP` of table1, table2 and table3 of folder __Instance and result__.

## Instance and result
Folder __Instance and result__ contains 6 table folders. __0414tandRX-NX-nmaxX-nmaxX-TestTimeX.xls__ in each table folder is the instance, and __BB-tandRX-NX-nmaxX-aiX-TestTimeX.xls__ is the BB calculation result for the corresponding instance.

__0414tandRX-NX-nmaxX-TestTimeX.xls__ in __table1, table2, and table3__ is small-scale instance, which also includes the results of MIP. __0414tandRX-NX-nmaxX-nmaxX-TestTimeX.xls__ in __table4, table5, and table6__ is large-scale instance, which is not calculated using MIP.

### others
> The meaning of the numbers behind ***tandR, N, ai, nmax, and TestTime*** in the name of the instance is as follows.
> 
> ***tandR*** - $(\tau,R)$, 1 to 9 represent (0.5 0.25), (0.5 0.5), (0.5 0.75), (0.25 0.25), (0.25 0.5), (0.25 0.75), (0.75 0.25), (0.75 0.5), (0.75 0.75), (0.75 0.75) , respectively;
> 
> ***N*** - the total number of orders;
> 
> ***ai*** - the learning index, 11 to 18 represent 0 -0.01 -0.02 -0.04 -0.08 -0.16 -0.32 -0.64, respectively;
> 
> ***nmax*** - the maximum order size, the number of jobs in each order was generated from a uniform distribution $U(1, nmax)$;
> 
> ***TestTime*** - the index of instances for each scenario, we further randomly generated 20 instances for each scenario. 

> The data of Table 1, Table 2, Table 3, Table 4, Table 5, Table 6 in the paper can be found from files in the corresponding table folder of __Instance and result__, these files are generated by `RecordTableXMIP` or `RecordTableXBB`.
> 
> The data of Figure1, Figure2, Figure3 or Figure4 in the article can be found from the corresponding files in the folder __table5__ or __table6__, these files are generated by `RecordFigureX`.
