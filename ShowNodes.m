function ShowNodes( Nodes, Style )
global gNetwork;
global gFigAxes;

if nargin < 1
    Nodes = 1:1:gNetwork.NodeNum;
end
if nargin < 2
    Style = gNetwork.NodeStyle;
end

if ischar(Nodes)
    if strcmpi(Nodes, 'all')
        Nodes = 1:1:gNetwork.NodeNum;
    else
        error('Wrong input argument');
    end
elseif isvector(Nodes) && isnumeric(Nodes)
    if size(Nodes,1) ~= 1
        Nodes = Nodes.';
    end
    if ~isempty(find(Nodes > gNetwork.NodeNum, 1))
        error('Exceeding the maximum of node index');
    end
end

DisconnectNodesAll all;
NodesToShow = setdiff(Nodes, intersect(Nodes, find(gFigAxes.NodeShowed)));
for iNode = NodesToShow
    VisCon_DrawNode(iNode, Style);
    gFigAxes.NodeShowed(iNode) = true;
end

end

