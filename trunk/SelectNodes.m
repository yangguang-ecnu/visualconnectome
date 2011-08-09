%SELECTNODES Summary of this function goes here
%   Detailed explanation goes here
function SelectNodes(Nodes)
global gFigAxes;
global gNetwork;
hFig=findobj('Tag','VisConFig');
hAxes=findobj(hFig,'Tag','VisConAxes');
set(hFig,'CurrentAxes',hAxes);

if ischar(Nodes)
    switch lower(Nodes)
        case 'all'
            Nodes=[1:gNetwork.NodeNum];
        case 'none'
            Nodes=[];
        case 'left'
            Nodes=[];
        case 'right'
            Nodes=[];
        otherwise
            error('Wrong input argument!');
    end
elseif isempty(Nodes)
elseif ~isvector(Nodes)
    error('Input should be a vector or string');
end
if ~isempty(find(Nodes<=0,1))
    error('Nonexistent node! The lower bound of node is 1.');
end
if ~isempty(find(Nodes>gNetwork.NodeNum,1))
    error('Nonexistent node! The upper bound of node is %d.',gNetwork.NodeNum);
end
%Delete current selection
for i=gNetwork.Selected
    ConNode=find(gNetwork.AdjMat(i,:));
    if ishandle(gFigAxes.hSelMarkers(i))
        delete(gFigAxes.hSelMarkers(i));
        gFigAxes.hSelMarkers(i)=NaN;
    end
    for j=ConNode
        if ishandle(gFigAxes.hEdges(i,j))
            delete(gFigAxes.hEdges(i,j));
            gFigAxes.hEdges(i,j)=NaN;
            gFigAxes.hEdges(j,i)=NaN;
        end        
    end
end
gNetwork.Selected=[];
%Create unit sphere
[Sphe.x,Sphe.y,Sphe.z]=sphere(20);
for i=Nodes
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
    gNetwork.Selected=sort([gNetwork.Selected i]);
end
end

