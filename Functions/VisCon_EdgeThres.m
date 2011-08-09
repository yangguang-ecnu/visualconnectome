function VisCon_EdgeThres(Method, Thres, Subj)
global gVisConFig;
global gVisConNet;
if nargin < 2
    error('Require at least two arguments!');
end
if nargin < 3
    Subj = gVisConFig.CurSubj;
end
%Absolute Threshold
if strcmpi(Method,'absolute')
    if Thres < gVisConNet(Subj).MinWeight     
        Thres = gVisConNet(Subj).MinWeight;
        warning('VisCon:EdgeThres',...
            ['Absolute threshold of the %d-th subject is smaller than minimal weight!\n'...
            'Use %6f instead!'], Subj, gVisConNet(Subj).MinWeight);
    end
    if Thres > gVisConNet(Subj).MaxWeight,     
        Thres = gVisConNet(Subj).MaxWeight;
        warning('VisCon:EdgeThres',...
            ['Absolute threshold of the %d-th subject is larger than maximal weight!\n'...
            'Use %6f instead!'], Subj, gVisConNet(Subj).MaxWeight);
    end
    if Thres ~= gVisConNet(Subj).EdgeAbsThres
        gVisConNet(Subj).EdgeAbsThres = Thres;
        gVisConNet(Subj).EdgeCountThres = sum(gVisConNet(Subj).SortedWeight >= Thres);
    end
    gVisConFig.EdgeThresType = 0;
%Counting Threshold
elseif strcmpi(Method,'counting')
    if Thres < 1      
        Thres = 1;
        warning('VisCon:EdgeThres',...
            ['Counting threshold of the %d-th subject is smaller than 1.\n'...
            'Use 1 instead!'], Subj);
    elseif Thres > gVisConNet(Subj).NzEdgeNum
        Thres = gVisConNet(Subj).NzEdgeNum;
        warning('VisCon:EdgeThres',...
            ['Counting threshold of the %d-th subject is larger than the number of non-zero edges.\n'...
            'Use %i instead!'], Subj, gVisConNet(Subj).NzEdgeNum);
    else
        Thres = round(Thres);
    end
    if Thres ~= gVisConNet(Subj).EdgeCountThres
        Thres = gVisConNet(Subj).SortedWeight(gVisConNet(Subj).NzEdgeNum - Thres + 1);
        Count = sum(gVisConNet(Subj).SortedWeight >= Thres);
        gVisConNet(Subj).EdgeAbsThres = Thres;
        gVisConNet(Subj).EdgeCountThres = Count;
    end
    gVisConFig.EdgeThresType = 1;
%Proportional Threshold
elseif strcmpi(Method,'proportional')
    Thres = gVisConFig.EdgeNum * Thres;
    if Thres < 1
        Thres = 1;
        warning('VisCon:EdgeThres',...
            ['Proportional threshold of the %d-th subject is smaller than %.2f.\n'...
            'Use %.2f instead!'], Subj, 100/gVisConFig.EdgeNum, 100/gVisConFig.EdgeNum);
    elseif Thres > gVisConNet(Subj).NzEdgeNum
        Thres = gVisConNet(Subj).NzEdgeNum;
        warning('VisCon:EdgeThres',...
            ['Proportional threshold of the %d-th subject is larger than %.2f.\n'...
            'Use %.2f instead!'], Subj, gVisConNet(Subj).NzEdgeNum/gVisConFig.EdgeNum*100,...
            gVisConNet(Subj).NzEdgeNum/gVisConFig.EdgeNum*100);
    else
        Thres = round(Thres);
    end
    if Thres ~= gVisConNet(Subj).EdgeCountThres
        Thres = gVisConNet(Subj).SortedWeight(gVisConNet(Subj).NzEdgeNum-Thres + 1);
        Count = sum(gVisConNet(Subj).SortedWeight >= Thres);
        gVisConNet(Subj).EdgeAbsThres = Thres;
        gVisConNet(Subj).EdgeCountThres = Count;
    end
    gVisConFig.EdgeThresType = 1;
else
    error('Wrong input argument!')
end

end
