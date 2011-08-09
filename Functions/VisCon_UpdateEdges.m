%This function is used to update edge colorbar and edge color when changing
%the edge threshold.
function VisCon_UpdateEdges(Type)
global gVisConFig;
global gVisConNet;

if nargin < 1
    Type = 0;
else
    if strcmpi(Type, 'Alt')
        Type = 1;
    elseif strcmpi(Type, 'Add')
        Type = 2;
    elseif strcmpi(Type, 'Del')
        Type = 3;
    elseif strcmpi(Type, 'Wei');
        Type = 4;
    else
        Type = 0;
    end
end

%Add and delete edges or change edge color
ColorNum = size(colormap,1);
for i = 1:gVisConFig.NodeNum
    Edge = (gVisConNet(gVisConFig.CurSubj).ConMat(i,:) >= gVisConNet(gVisConFig.CurSubj).EdgeAbsThres);
    EdgeToAltClr = Edge & gVisConFig.EdgeShowed(i,:) & gVisConNet(gVisConFig.CurSubj).NodeShowed;
    EdgeToAdd = xor(EdgeToAltClr,Edge) & gVisConNet(gVisConFig.CurSubj).EdgeConnected(i,:) & gVisConNet(gVisConFig.CurSubj).NodeShowed;
    EdgeToDel = xor(EdgeToAltClr,gVisConFig.EdgeShowed(i,:));
    %Change edge color
    if Type == 0 || Type == 1       
        for j = find(EdgeToAltClr)
            EdgeColor = interp1([0:1:ColorNum-1],colormap,...
                (gVisConNet(gVisConFig.CurSubj).ConMat(i,j)-gVisConNet(gVisConFig.CurSubj).EdgeAbsThres)/...
                (gVisConNet(gVisConFig.CurSubj).MaxWeight-gVisConNet(gVisConFig.CurSubj).EdgeAbsThres)*(ColorNum-1));
            set(gVisConFig.hEdges(i,j),'Color',EdgeColor);
        end
    end
    %Add edge
    if Type == 0 || Type == 2
        for j = find(EdgeToAdd)
            EdgeColor = interp1([0:1:ColorNum-1],colormap,...
                (gVisConNet(gVisConFig.CurSubj).ConMat(i,j)-gVisConNet(gVisConFig.CurSubj).EdgeAbsThres)/...
                (gVisConNet(gVisConFig.CurSubj).MaxWeight-gVisConNet(gVisConFig.CurSubj).EdgeAbsThres)*(ColorNum-1));
            gVisConFig.hEdges(i,j) = line([gVisConNet(gVisConFig.CurSubj).PosMat(i,1);gVisConNet(gVisConFig.CurSubj).PosMat(j,1)],...
                [gVisConNet(gVisConFig.CurSubj).PosMat(i,2);gVisConNet(gVisConFig.CurSubj).PosMat(j,2)],...
                [gVisConNet(gVisConFig.CurSubj).PosMat(i,3);gVisConNet(gVisConFig.CurSubj).PosMat(j,3)],...
                'LineWidth',gVisConNet(gVisConFig.CurSubj).EdgeWidth,'Color',EdgeColor,...
                'HitTest','off','Tag',['e_',num2str(i),'_',num2str(j)],'LineSmoothing',gVisConFig.LineSmooth);
            gVisConFig.hEdges(j,i) = gVisConFig.hEdges(i,j);
            gVisConFig.EdgeShowed(i,EdgeToAdd) = 1;
            gVisConFig.EdgeShowed(EdgeToAdd,i) = 1;
        end
    end
    %Delete edge
    if Type == 0 || Type == 3
        delete(gVisConFig.hEdges(i,EdgeToDel));
        gVisConFig.hEdges(i,EdgeToDel) = NaN;
        gVisConFig.hEdges(EdgeToDel,i) = NaN;
        gVisConFig.EdgeShowed(i,EdgeToDel) = 0;
        gVisConFig.EdgeShowed(EdgeToDel,i) = 0;
    end
end
if(Type == 4)
    EdgeConnected = gVisConNet(gVisConFig.CurSubj).EdgeConnected;
    EdgeShowed = gVisConFig.EdgeShowed;
    DisconnectNodesAll all;
    [r, c] = find(EdgeShowed);
    ConnectTwoNodes([r c]);
    gVisConNet(gVisConFig.CurSubj).EdgeConnected = EdgeConnected;
end
end

