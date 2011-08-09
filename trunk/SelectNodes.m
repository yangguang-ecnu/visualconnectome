function SelectNodes( Nodes )
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
    if size(Nodes,1) ~= 1
        Nodes = Nodes.';
    end
    if ~isempty(find(Nodes > gVisConFig.NodeNum, 1))
        error('Exceeding the maximum of node index');
    end
end
NodesToSelect = setdiff(intersect(Nodes, find(gVisConNet(gVisConFig.CurSubj).NodeShowed)),gVisConFig.NodeSelected);
for iNode = NodesToSelect
    VisCon_DrawNodeMarker(iNode);
    gVisConFig.NodeSelected=[gVisConFig.NodeSelected iNode];
end


end

