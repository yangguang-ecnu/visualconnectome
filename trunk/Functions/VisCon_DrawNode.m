function VisCon_DrawNode( iNode, Style )
global gVisConFig;
global gVisConNet;
if nargin == 0, error('At least one parameter!');   end
if nargin == 1, Style='sphere';   end
hFig = findobj('Tag','VisConFig');
hAxes = findobj(hFig,'Tag','VisConAxes');
set(hFig,'CurrentAxes',hAxes);
hNodeMenu = uicontextmenu();

if strcmpi(Style,'cube')
    NodeCube.Vertices = bsxfun(@plus,gVisConFig.Cube.Vertices * gVisConNet(gVisConFig.CurSubj).NodeSize(iNode),...
        gVisConNet(gVisConFig.CurSubj).PosMat(iNode,:));
    NodeCube.Faces = gVisConFig.Cube.Faces;
    gVisConFig.hNodes(iNode) = patch(NodeCube,'EdgeColor',gVisConNet(gVisConFig.CurSubj).NodeColor(iNode,:),...
        'FaceColor',gVisConNet(gVisConFig.CurSubj).NodeColor(iNode,:),...
        'AmbientStrength',0.5,'FaceLighting','gouraud',...
        'ButtonDownFcn',@VisCon_SelectNode,'Tag',['n' num2str(iNode)],...
        'UIContextMenu',hNodeMenu);
elseif strcmpi(Style,'sphere')
    NodeSphe.x = 1.5 * gVisConNet(gVisConFig.CurSubj).NodeSize(iNode) * gVisConFig.Sphe.x+gVisConNet(gVisConFig.CurSubj).PosMat(iNode,1);
    NodeSphe.y = 1.5 * gVisConNet(gVisConFig.CurSubj).NodeSize(iNode) * gVisConFig.Sphe.y+gVisConNet(gVisConFig.CurSubj).PosMat(iNode,2);
    NodeSphe.z = 1.5 * gVisConNet(gVisConFig.CurSubj).NodeSize(iNode) * gVisConFig.Sphe.z+gVisConNet(gVisConFig.CurSubj).PosMat(iNode,3);
    gVisConFig.hNodes(iNode) = surface(NodeSphe.x,NodeSphe.y,NodeSphe.z,...
        'EdgeColor','none',...
        'FaceColor',gVisConNet(gVisConFig.CurSubj).NodeColor(iNode,:),...
        'FaceLighting','gouraud','AmbientStrength',0.5,...
        'ButtonDownFcn',@VisCon_SelectNode,'Tag',['n' num2str(iNode)],...
        'UIContextMenu',hNodeMenu);
end

uimenu(hNodeMenu, 'Label', 'Select All Nodes', 'Callback', 'SelectNodes all');
uimenu(hNodeMenu, 'Label', 'Hide Selected Node(s)', 'Callback', @NodeMenuHideNodes, 'Separator', 'on');
    function NodeMenuHideNodes(Src,Evnt)
        if isempty(gVisConFig.NodeSelected)
            msgbox('Please first select node(s)!', 'VisualConnecome', 'warn');
        else
            HideNodes(gVisConFig.NodeSelected);
        end
    end
uimenu(hNodeMenu, 'Label', 'Show All Nodes', 'Callback', 'ShowNodes all');
uimenu(hNodeMenu, 'Label', 'Connect Selected Node(s) With All', 'Callback', @NodeMenuConnectNodesAll, 'Separator', 'on');
    function NodeMenuConnectNodesAll(Src, Evnt)
        if isempty(gVisConFig.NodeSelected)
            msgbox('Please first select node(s)!', 'VisualConnecome', 'warn');
        else
            ConnectNodesAll(gVisConFig.NodeSelected);
        end
    end
uimenu(hNodeMenu, 'Label', 'Connect Selected Node(s) With ...', 'Callback', @NodeMenuConnectNodesWith);
    function NodeMenuConnectNodesWith(Src,Evnt)
        if isempty(gVisConFig.NodeSelected)
            msgbox('Please first select node(s)!', 'VisualConnecome', 'warn');
        else
            StartNodes = gVisConFig.NodeSelected;
            for i = gVisConFig.NodeNum
                set(gVisConFig.hNodes,'ButtonDownFcn',...
                    {@VisCon_ConnectNodesWith,StartNodes});
            end
            VisCon_Hint('Select a node to connect/disconnect ...');
        end
    end
uimenu(hNodeMenu, 'Label', 'Connect All Nodes', 'Callback', 'ConnectNodesAll all');
end
