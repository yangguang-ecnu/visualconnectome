function SelectSubj( Subj )
global gVisConFig;
global gVisConNet;

if gVisConFig.CurSubj == Subj
    return;
else
    OrigSubj = gVisConFig.CurSubj;
    gVisConFig.CurSubj = Subj;
    if(gVisConFig.IdenNodes)
        gVisConNet(gVisConFig.CurSubj).NodeShowed = gVisConNet(OrigSubj).NodeShowed;
    elseif sum(gVisConNet(Subj).NodeShowed) == 0
        gVisConNet(gVisConFig.CurSubj).NodeShowed = true(1,gVisConFig.NodeNum);
    end
    
    NodeSelected = gVisConFig.NodeSelected;
    VisCon_UpdateNodes();
    SelectNodes(NodeSelected);
    if gVisConFig.IdenEdgeThres
        Subj = OrigSubj;
    else
        Subj = gVisConFig.CurSubj;
    end
    if gVisConFig.EdgeThresType
        Mehtod = 'counting';
        Thres = gVisConNet(Subj).EdgeCountThres;
    else
        Mehtod = 'absolute';
        Thres = gVisConNet(Subj).EdgeAbsThres;
    end
    EdgeThreshold(Mehtod, Thres, gVisConFig.CurSubj, 'off');
end

