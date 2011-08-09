function HideNodes( Nodes )
global gNetwork;
global gFigAxes;

if nargin < 1
    Nodes = 1:1:gNetwork.NodeNum;
end

if ischar(Nodes)
    if strcmpi(Nodes, 'all')
        Nodes = 1:1:gNetwork.NodeNum;
    else
        error('Wrong input argument');
    end
elseif isvector(Nodes) && isnumeric(Nodes)
    if ~isempty(find(Nodes > NodeNum, 1))
        error('Exceeding the maximum of node index');
    end
end

DisconnectNodesAll all;
NodesToHide = intersect(Nodes, find(gFigAxes.NodeShowed));
for iNode = NodesToHide
    delete(gFigAxes.hNodes(iNode));
    gFigAxes.NodeShowed(iNode) = false;
end

end

