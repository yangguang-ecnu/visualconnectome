function VisCon_ConnNodesWithMode(Sw)
global gFigAxes;
global gNetwork;
if nargin==0,   Sw='on';    end
hMenuConnNodesAll=findobj('Tag','VisConMenuConnNodesAll');
hMenuConnNodesWith=findobj('Tag','VisConMenuConnNodesWith');
if strcmpi(Sw,'on')
    for i=1:gNetwork.NodeNum
        set(gFigAxes.hNodes(i),'ButtonDownFcn',@VisCon_ConnNodesWith)
    end
    set(hMenuConnNodesWith,'Checked','on');
    set(hMenuConnNodesAll,'Checked','off');
elseif strcmp(Sw,'off')
    for i=1:gNetwork.NodeNum
        set(gFigAxes.hNodes(i),'ButtonDownFcn',@VisCon_SelectNode)
    end
    set(hMenuConnNodesWith,'Checked','off');
else
    error('Wrong input argument!');
end
end

function VisCon_ConnNodesWith(Src,Evnt)


end

