%VISCON_DRAWNODE Summary of this function goes here
%   Detailed explanation goes here
function VisCon_DrawNodes(Style)
global gFigAxes;
global gNetwork;
if nargin==0,   Style='cube';   end
hFig=findobj('Tag','VisConFig');
hAxes=findobj(hFig,'Tag','VisConAxes');
set(hFig,'CurrentAxes',hAxes);
if strcmpi(Style,'cube')
    %Create unit cube
    Cube.Vertices=[1 1 1;1 -1 1;-1 -1 1;-1 1 1;1 1 -1;1 -1 -1;-1 -1 -1;-1 1 -1];
    Cube.Faces=[1 2 3 4;5 6 7 8;1 2 6 5;3 4 8 7;1 4 8 5;2 3 7 6];
    %Draw all nodes
    for i=1:gNetwork.NodeNum
        NodeCube.Vertices=bsxfun(@plus,Cube.Vertices*gNetwork.NodeScale(i),...
            gNetwork.PosMat(i,:));
        NodeCube.Faces=Cube.Faces;
        gFigAxes.hNodes(i)=patch(NodeCube,'EdgeColor',gNetwork.NodeColor(i,:),...
            'FaceColor',gNetwork.NodeColor(i,:),...
            'AmbientStrength',0.5,'FaceLighting','gouraud',...
            'ButtonDownFcn',@VisCon_SelectNode,'Tag',['n' num2str(i)]);
    end
elseif strcmp(Style,'Sphere')
    %Create unit sphere
    [Sphe.x,Sphe.y,Sphe.z]=Sphere(20);
    %Draw all nodes
    for i=1:gNetwork.NodeNum
        NodeSphe.x=2*gNetwork.NodeScale(i)*Sphe.x+gNetwork.PosMat(i,1);
        NodeSphe.y=2*gNetwork.NodeScale(i)*Sphe.y+gNetwork.PosMat(i,2);
        NodeSphe.z=2*gNetwork.NodeScale(i)*Sphe.z+gNetwork.PosMat(i,3);
        gFigAxes.hNodes(i)=patch(NodeSphe.x,NodeSphe.y,NodeSphe.z,...
            'EdgeColor',gNetwork.NodeColor(i,:),...
            'FaceColor',gNetwork.NodeColor(i,:),...
            'FaceLighting','gouraud','AmbientStrength',0.5,...
            'ButtonDownFcn',@VisCon_SelectNode,'Tag',['n' num2str(i)]);
    end
end
%Limit the axes
xlim=get(hAxes,'XLim')+[-10 10];
ylim=get(hAxes,'YLim')+[-10 10];
zlim=get(hAxes,'ZLim')+[-10 10];
axis(hAxes,[xlim,ylim,zlim]);
end
%% Select node button down function
function VisCon_SelectNode(Src,Evnt)
global gNetwork;
global gFigAxes;
hFig=findobj('Tag','VisConFig');
%Create unit sphere
[Sphe.x,Sphe.y,Sphe.z]=sphere(20);

if strcmp(get(hFig,'SelectionType'),'normal')
    [i,~]=find(gFigAxes.hNodes==Src);
    if isempty(find(gNetwork.Selected==i,1))
        %Display selection marker
        SelMarker.x=2*gNetwork.NodeScale(i)*Sphe.x+gNetwork.PosMat(i,1);
        SelMarker.y=2*gNetwork.NodeScale(i)*Sphe.y+gNetwork.PosMat(i,2);
        SelMarker.z=2*gNetwork.NodeScale(i)*Sphe.z+gNetwork.PosMat(i,3);
        gFigAxes.hSelMarkers(i)=surface(SelMarker.x,SelMarker.y,SelMarker.z,...
            'EdgeColor','none','FaceColor',gNetwork.NodeColor(i,:),'FaceLighting',...
            'gouraud','AmbientStrength',0.5,'FaceAlpha',0.3,'HitTest','off');
        %Display edges
        ConNode=intersect(find(gNetwork.AdjMat(i,:)>=gNetwork.EdgeRange(1)),...
            find(gNetwork.AdjMat(i,:)<=gNetwork.EdgeRange(2)));
        for j=ConNode
            if ~ishandle(gFigAxes.hEdges(i,j))
                ColorNum=size(gNetwork.EdgeCmap,1);
                EdgeColor=interp1([0:1:ColorNum-1],gNetwork.EdgeCmap,...
                    (gNetwork.AdjMat(i,j)-gNetwork.EdgeRange(1))/...
                    (gNetwork.EdgeRange(2)-gNetwork.EdgeRange(1))*(ColorNum-1));
                gFigAxes.hEdges(i,j)=line([gNetwork.PosMat(i,1);gNetwork.PosMat(j,1)],...
                    [gNetwork.PosMat(i,2);gNetwork.PosMat(j,2)],...
                    [gNetwork.PosMat(i,3);gNetwork.PosMat(j,3)],...
                    'LineWidth',gNetwork.EdgeWidth,'Color',EdgeColor,...
                    'HitTest','off','Tag',['e_',num2str(i),'_',num2str(j)]);
                gFigAxes.hEdges(j,i)=gFigAxes.hEdges(i,j);
            end
        end
        gNetwork.Selected=[gNetwork.Selected i];
    else 
        if ishandle(gFigAxes.hSelMarkers(i))
            delete(gFigAxes.hSelMarkers(i));
            gFigAxes.hSelMarkers(i)=NaN;
        end
        ConNode=find(gNetwork.AdjMat(i,:));
        for j=ConNode
            if ishandle(gFigAxes.hEdges(i,j))
                delete(gFigAxes.hEdges(i,j));
                gFigAxes.hEdges(i,j)=NaN;
                gFigAxes.hEdges(j,i)=NaN;
            end
        end
        gNetwork.Selected(gNetwork.Selected==i)=[];    
    end
end
if strcmp(get(hFig,'SelectionType'),'alt')
    [i,~]=find(gFigAxes.hNodes==Src);
end

end

