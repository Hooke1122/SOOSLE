function Min = FmainTestTool(P0,D0,order,ai)
            NNN = size(P0,2);
            Oi=[P0;
                D0;
                ones(1,NNN);
                ones(1,NNN);
                1:NNN;
                ones(1,NNN);
                ];

OiSTP = Oi;
OiSTP = OiSTP(:,order);

StartTime = 0;
[RealPi,~,~] = ContinueProcess(OiSTP,ai);
Orginal = cumsum(RealPi) + StartTime - OiSTP(2,:);
wOrginal = Orginal.*OiSTP(6,:);
Min = sum(wOrginal(1,find(wOrginal > 0)));
