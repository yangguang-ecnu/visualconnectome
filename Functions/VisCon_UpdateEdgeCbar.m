%This function is used to update edge colorbar and edge color when changing
%the edge threshold.
function VisCon_UpdateEdgeCbar()
global gFigAxes;
global gNetwork;
if ishandle(gFigAxes.hEdgeCbar)
    EdgeRange=gNetwork.EdgeRange;
    if EdgeRange(2)-EdgeRange(1)<=0.000001
        EdgeRange(1)=EdgeRange(1)-0.0000005;
        EdgeRange(2)=EdgeRange(2)+0.0000005;
    end
    caxis(EdgeRange);
    EdgeCbarTick=linspace(EdgeRange(1),EdgeRange(2),8);
    EdgeCbarLabel=num2str(EdgeCbarTick.','%.3f');
    set(gFigAxes.hEdgeCbar,'YTick',EdgeCbarTick,'YTickLabel',EdgeCbarLabel);
    gNetwork.EdgeRange=EdgeRange;
end
%Add, delete or change edge color
ColorNum=size(gNetwork.EdgeCmap,1);
for i=1:gNetwork.NodeNum
    Edge=(gNetwork.AdjMat(i,:)>=gNetwork.EdgeRange(1))...
        &(gNetwork.AdjMat(i,:)<=gNetwork.EdgeRange(2));
    EdgeAlt=Edge & gFigAxes.EdgeShowed(i,:);
    EdgeAdd=xor(EdgeAlt,Edge) & gNetwork.EdgeConnected(i,:);
    EdgeDel=xor(EdgeAlt,gFigAxes.EdgeShowed(i,:));
    %Change edge color
    for j=find(EdgeAlt)
        EdgeColor=interp1([0:1:ColorNum-1],gNetwork.EdgeCmap,...
            (gNetwork.AdjMat(i,j)-gNetwork.EdgeRange(1))/...
            (gNetwork.EdgeRange(2)-gNetwork.EdgeRange(1))*(ColorNum-1));
        set(gFigAxes.hEdges(i,j),'Color',EdgeColor);
    end
    %Add edge
    for j=find(EdgeAdd)
        EdgeColor=interp1([0:1:ColorNum-1],gNetwork.EdgeCmap,...
            (gNetwork.AdjMat(i,j)-gNetwork.EdgeRange(1))/...
            (gNetwork.EdgeRange(2)-gNetwork.EdgeRange(1))*(ColorNum-1));
        gFigAxes.hEdges(i,j)=line([gNetwork.PosMat(i,1);gNetwork.PosMat(j,1)],...
            [gNetwork.PosMat(i,2);gNetwork.PosMat(j,2)],...
            [gNetwork.PosMat(i,3);gNetwork.PosMat(j,3)],...
            'LineWidth',gNetwork.EdgeWidth,'Color',EdgeColor,...
            'HitTest','off','Tag',['e_',num2str(i),'_',num2str(j)]);
        gFigAxes.hEdges(j,i)=gFigAxes.hEdges(i,j);
        gFigAxes.EdgeShowed(i,EdgeAdd)=1;
        gFigAxes.EdgeShowed(EdgeAdd,i)=1;
    end
    %Delete edge
    delete(gFigAxes.hEdges(i,EdgeDel));
    gFigAxes.hEdges(i,EdgeDel)=NaN;
    gFigAxes.hEdges(EdgeDel,i)=NaN;
    gFigAxes.EdgeShowed(i,EdgeDel)=0;
    gFigAxes.EdgeShowed(EdgeDel,i)=0;
       
end

