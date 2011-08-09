%VISCON_UPDATEINFORMBOX Summary of this function goes here
%   Detailed explanation goes here
function VisCon_UpdateInform(Node)
global gFigAxes;
global gNetwork;
if nargin==0,   Node=[];    end
if ~isscalar(Node) && ~isempty(Node)
    error('Input argument should be a scalar!')
end
NodeInformTitle={...
    '    {\bf\fontsize{10}Information Box}',...
    '{\bfNodTag:} ',...
    '{\bfRegion:} ',...
    '{\bfDegree:} '};
if ishandle(gFigAxes.hInformBox)
    hNode=gFigAxes.hNodes(Node);
    NodeInform=NodeInformTitle;
    NodeInform{2}=[NodeInform{2},get(hNode,'Tag')];
    if ~isempty(gNetwork.NodeName)
        NodeInform{3}=[NodeInform{3},gNetwork.NodeName{Node}];
    end
    set(gFigAxes.hInformBox,'String',NodeInform);
end

end

