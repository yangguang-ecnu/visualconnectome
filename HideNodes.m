function HideNodes( Nodes )
global gVisConNet;
global gVisConFig;

if nargin < 1
    Nodes = 1:1:gVisConFig.NodeNum;
end

if ischar(Nodes)
    if strcmpi(Nodes, 'all')
        Nodes = 1:1:gVisConFig.NodeNum;
    else
        error('Wrong input argument');
    end
elseif isvector(Nodes) && isnumeric(Nodes)
    if ~isempty(find(Nodes > gVisConFig.NodeNum, 1))
        error('Exceeding the maximum of node index');
    end
end


NodesToHide = intersect(Nodes, find(gVisConNet(gVisConFig.CurSubj).NodeShowed));
for iNode = NodesToHide
    try
        delete(gVisConFig.hNodes(iNode));
    end
    gVisConFig.hNodes(iNode) = NaN; 
    gVisConNet(gVisConFig.CurSubj).NodeShowed(iNode) = false;
    if ~isempty(find(gVisConFig.NodeSelected == iNode, 1))
        delete(gVisConFig.hNodeMarkers(iNode));
        gVisConFig.hNodeMarkers(iNode) = NaN;
        gVisConFig.NodeSelected = gVisConFig.NodeSelected(gVisConFig.NodeSelected ~= iNode);
    end
end
%
VisCon_UpdateEdges('Del');
%Display information of last selected node
if isempty(gVisConFig.NodeSelected)
    VisCon_UpdateInfo([]);
else
    VisCon_UpdateInfo(gVisConFig.NodeSelected(end));
end

end

