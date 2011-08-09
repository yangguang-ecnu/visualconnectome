function VisCon_UpdateEdgeCbar()
global gVisConFig;
global gVisConNet;

EdgeAbsThres = gVisConNet(gVisConFig.CurSubj).EdgeAbsThres;
MaxWeight = gVisConNet(gVisConFig.CurSubj).MaxWeight;
if MaxWeight - EdgeAbsThres <= 1e-5
    EdgeAbsThres = MaxWeight - 1e-5;
end

if ishandle(gVisConFig.hEdgeCbar) 
    caxis([EdgeAbsThres MaxWeight]);
    EdgeCbarTick = linspace(EdgeAbsThres + 1e-6, MaxWeight - 1e-6, 8);
    EdgeCbarLabel = num2str(EdgeCbarTick.','%.3f');
    set(gVisConFig.hEdgeCbar, 'YTick', EdgeCbarTick, 'YTickLabel', EdgeCbarLabel);  
end

gVisConNet(gVisConFig.CurSubj).EdgeAbsThres = EdgeAbsThres;
end

