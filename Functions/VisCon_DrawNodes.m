%This function is used to draw node objects
function VisCon_DrawNodes(Style)
global gFigAxes;
global gNetwork;
if nargin==0,   Style='sphere';   end
hFig=findobj('Tag','VisConFig');
hAxes=findobj(hFig,'Tag','VisConAxes');
set(hFig,'CurrentAxes',hAxes);

if strcmpi(Style,'cube')
    %Draw all nodes
    for i=1:gNetwork.NodeNum
        NodeCube.Vertices = bsxfun(@plus,gFigAxes.Cube.Vertices*gNetwork.NodeScale(i),...
            gNetwork.PosMat(i,:));
        NodeCube.Faces = gFigAxes.Cube.Faces;
        gFigAxes.hNodes(i) = patch(NodeCube,'EdgeColor',gNetwork.NodeColor(i,:),...
            'FaceColor',gNetwork.NodeColor(i,:),...
            'AmbientStrength',0.5,'FaceLighting','gouraud',...
            'ButtonDownFcn',@VisCon_SelectNode,'Tag',['n' num2str(i)]);
    end
elseif strcmpi(Style,'sphere')
    %Draw all nodes
    for i=1:gNetwork.NodeNum
        NodeSphe.x = 1.5*gNetwork.NodeScale(i)*gFigAxes.Sphe.x+gNetwork.PosMat(i,1);
        NodeSphe.y = 1.5*gNetwork.NodeScale(i)*gFigAxes.Sphe.y+gNetwork.PosMat(i,2);
        NodeSphe.z = 1.5*gNetwork.NodeScale(i)*gFigAxes.Sphe.z+gNetwork.PosMat(i,3);
        gFigAxes.hNodes(i) = surface(NodeSphe.x,NodeSphe.y,NodeSphe.z,...
            'EdgeColor','none',...
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
