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
    '        {\bf\fontsize{10}Information Box}',...
    '{\bfNodTag:} ',...
    '{\bfRegion:} ',...
    '{\bfDegree:} '};
if ishandle(gFigAxes.hInformBox)
    NodeInform=NodeInformTitle;
    if ~isempty(Node)
        hNode=gFigAxes.hNodes(Node);
        NodeInform{2}=[NodeInform{2},get(hNode,'Tag')];
        if ~isempty(gNetwork.NodeName) 
            NodeName = strrep(gNetwork.NodeName{Node}, '_', '\_');
            NodeInform{3}=[NodeInform{3},gNetwork.NodeName{Node}];
        end
        if isfield(gNetwork,'Degree')
            NodeInform{4}=[NodeInform{4},sprintf('%d',gNetwork.Degree(Node))];
        end
    end
    set(gFigAxes.hInformBox,'String',NodeInform);
end

end

