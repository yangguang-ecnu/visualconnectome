function VisCon_DrawNode( iNode, Style )
global gFigAxes;
global gNetwork;
if nargin == 0, error('At least one parameter!');   end
if nargin == 1, Style='sphere';   end
hFig = findobj('Tag','VisConFig');
hAxes = findobj(hFig,'Tag','VisConAxes');
set(hFig,'CurrentAxes',hAxes);

if strcmpi(Style,'cube')
    NodeCube.Vertices = bsxfun(@plus,gFigAxes.Cube.Vertices*gNetwork.NodeScale(iNode),...
        gNetwork.PosMat(iNode,:));
    NodeCube.Faces = gFigAxes.Cube.Faces;
    gFigAxes.hNodes(iNode) = patch(NodeCube,'EdgeColor',gNetwork.NodeColor(iNode,:),...
        'FaceColor',gNetwork.NodeColor(iNode,:),...
        'AmbientStrength',0.5,'FaceLighting','gouraud',...
        'ButtonDownFcn',@VisCon_SelectNode,'Tag',['n' num2str(iNode)]);
elseif strcmpi(Style,'sphere')
    NodeSphe.x = 1.5*gNetwork.NodeScale(iNode)*gFigAxes.Sphe.x+gNetwork.PosMat(iNode,1);
    NodeSphe.y = 1.5*gNetwork.NodeScale(iNode)*gFigAxes.Sphe.y+gNetwork.PosMat(iNode,2);
    NodeSphe.z = 1.5*gNetwork.NodeScale(iNode)*gFigAxes.Sphe.z+gNetwork.PosMat(iNode,3);
    gFigAxes.hNodes(iNode) = surface(NodeSphe.x,NodeSphe.y,NodeSphe.z,...
        'EdgeColor','none',...
        'FaceColor',gNetwork.NodeColor(iNode,:),...
        'FaceLighting','gouraud','AmbientStrength',0.5,...
        'ButtonDownFcn',@VisCon_SelectNode,'Tag',['n' num2str(iNode)]);
end

end

