function VisCon_ConnectNodesWith(Src,Evnt,StartNodes)
global gVisConFig;
global gVisConNet;
%Delete node marker
for j = gVisConFig.NodeSelected
    if ishandle(gVisConFig.hNodeMarkers(j))
        delete(gVisConFig.hNodeMarkers(j))
    end
    gVisConFig.hNodeMarkers(j) = NaN;
end
gVisConFig.NodeSelected = [];
%Display node marker
[j,~] = find(gVisConFig.hNodes == Src);
VisCon_DrawNodeMarker(j)
gVisConFig.NodeSelected = j;
VisCon_UpdateInfo(j);
PairNodes = [StartNodes.',j*ones(length(StartNodes),1)];
if all(gVisConNet(gVisConFig.CurSubj).EdgeConnected(StartNodes,j))
    DisconnectTwoNodes(PairNodes);
else
    ConnectTwoNodes(PairNodes);
end
for j = 1:gVisConFig.NodeNum
    set(gVisConFig.hNodes(j),'ButtonDownFcn',@VisCon_SelectNode);
end
VisCon_Hint off;
end
