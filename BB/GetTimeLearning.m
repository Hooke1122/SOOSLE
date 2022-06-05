function NeedTime = GetTimeLearning(nJob,Pi,FromJob,ai)
NeedTime = 0;
for i = FromJob+1:nJob+FromJob
    NeedTime = NeedTime + Pi * i^ai;
end
