function VisCon_ConnNodeAllMode(Sw)
global gFigAxes;
global gNetwork;
if nargin==0,   Sw='on';    end
hMenuConnNodesAll=findobj('Tag','VisConMenuConnNodesAll');
hMenuConnNodesWith=findobj('Tag','VisConMenuConnNodesWith');
if strcmpi(Sw,'on')
    for i=1:gNetwork.NodeNum
        set(gFigAxes.hNodes(i),'ButtonDownFcn',@VisCon_ConnNodeAll)
    end
    set(hMenuConnNodesAll,'Checked','on');
    set(hMenuConnNodesWith,'Checked','off');
elseif strcmp(Sw,'off')
    for i=1:gNetwork.NodeNum
        set(gFigAxes.hNodes(i),'ButtonDownFcn',@VisCon_SelectNode)
    end
    set(hMenuConnNodesAll,'Checked','off');
else
    error('Wrong input argument!');
end
end

function VisCon_ConnNodeAll(Src,Evnt)
global gNetwork;
global gFigAxes;
hFig=findobj('Tag','VisConFig');
SelType=get(hFig,'SelectionType');

%Delete before left click
if strcmp(SelType,'normal') || strcmp(SelType,'alt')
    for i=gFigAxes.NodeSelected
        if ishandle(gFigAxes.hNodeMarkers(i))
            delete(gFigAxes.hNodeMarkers(i))
        end
        gFigAxes.hNodeMarkers(i)=NaN;
    end
    gFigAxes.NodeSelected=[];
    %Display selected marker
    [i,~]=find(gFigAxes.hNodes==Src);
    VisCon_DrawNodeMarker(i)
    gFigAxes.NodeSelected=i;
    VisCon_UpdateInform(i);
    EdgeShowed=(gNetwork.AdjMat(i,:)>=gNetwork.EdgeRange(1))...
        & (gNetwork.AdjMat(i,:)<=gNetwork.EdgeRange(2));
    if all(gNetwork.EdgeConnected(i,:)) || isequal(EdgeShowed,gFigAxes.EdgeShowed(i,:))
        DisconnectNodesAll(i);
    else
        ConnectNodesAll(i);
    end
end
end

