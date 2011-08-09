% Select node button down function
function VisCon_SelectNode(Src,Evnt)
global gFigAxes;
hFig=findobj('Tag','VisConFig');
SelType=get(hFig,'SelectionType');
%Delete before left click
if strcmp(SelType,'normal')
    for i=gFigAxes.NodeSelected
        if ishandle(gFigAxes.hNodeMarkers(i))
            delete(gFigAxes.hNodeMarkers(i))
        end
        gFigAxes.hNodeMarkers(i)=NaN;
    end
    gFigAxes.NodeSelected=[];
end
if strcmp(SelType,'normal') || strcmp(SelType,'alt')
    %Display selected marker
    [i,~]=find(gFigAxes.hNodes==Src);
    if isempty(find(gFigAxes.NodeSelected==i,1))
        VisCon_DrawNodeMarker(i)
        gFigAxes.NodeSelected=[gFigAxes.NodeSelected i];
    else
        if ishandle(gFigAxes.hNodeMarkers(i))
            delete(gFigAxes.hNodeMarkers(i));
        end
        gFigAxes.hNodeMarkers(i)=NaN;
        gFigAxes.NodeSelected=gFigAxes.NodeSelected(gFigAxes.NodeSelected~=i);
    end
    %Display information of last selected node
    if isempty(gFigAxes.NodeSelected)
        VisCon_UpdateInform([]);
    else
        VisCon_UpdateInform(gFigAxes.NodeSelected(end));
    end
end
end

