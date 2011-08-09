function VisCon_SelectNode(Src, Evnt)
global gVisConNet;
global gVisConFig;
hFig = findobj('Tag', 'VisConFig');
SelType = get(hFig, 'SelectionType');
Modifier = get(hFig, 'CurrentModifier');
%Find which node is click
[iNode,~] = find(gVisConFig.hNodes == Src);
%Delete before left click
if strcmp(SelType,'normal') || (strcmpi(SelType,'alt') && isempty(strmatch('control', Modifier))) && isempty(find(gVisConFig.NodeSelected == iNode, 1))
    for i = gVisConFig.NodeSelected
        if ishandle(gVisConFig.hNodeMarkers(i))
            delete(gVisConFig.hNodeMarkers(i))
        end
        gVisConFig.hNodeMarkers(i) = NaN;
    end
    gVisConFig.NodeSelected = [];
end
if strcmpi(SelType,'normal') || (strcmpi(SelType,'alt') && (~isempty(strmatch('control', Modifier)) || isempty(gVisConFig.NodeSelected)))
    %Display selected marker
    if isempty(find(gVisConFig.NodeSelected == iNode,1))
        VisCon_DrawNodeMarker(iNode);
        gVisConFig.NodeSelected = [gVisConFig.NodeSelected iNode];
    else
        if ishandle(gVisConFig.hNodeMarkers(iNode))
            delete(gVisConFig.hNodeMarkers(iNode));
        end
        gVisConFig.hNodeMarkers(iNode) = NaN;
        gVisConFig.NodeSelected = gVisConFig.NodeSelected(gVisConFig.NodeSelected ~= iNode);
    end
    %Display information of last selected node
    if isempty(gVisConFig.NodeSelected)
        VisCon_UpdateInfo([]);
    else
        VisCon_UpdateInfo(gVisConFig.NodeSelected(end));
    end
end
% if strcmp(SelType,'open')
%     EdgeShowed = (gVisConNet(gVisConFig.CurSubj).ConMat(iNode,:) >= gVisConNet(gVisConFig.CurSubj).EdgeAbsThres);
%     if all(all(gVisConNet(gVisConFig.CurSubj).EdgeConnected(iNode,:)))...
%             || isequal(EdgeShowed, gVisConFig.EdgeShowed(iNode,:))
%         DisconnectNodesAll(iNode);
%     else
%         ConnectNodesAll(iNode);
%     end
% end
end