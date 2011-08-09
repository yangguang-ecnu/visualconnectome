function VisCon_UpdateNodes()
global gVisConNet;
global gVisConFig;

NodeShowed = gVisConNet(gVisConFig.CurSubj).NodeShowed;
HideNodes all;
ShowNodes(find(NodeShowed));
end

