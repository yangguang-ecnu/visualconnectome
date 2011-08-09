function VisCon_DrawNodeMarker(Node)
global gVisConFig;
global gVisConNet;
NodeMarker.x = 2.5*gVisConNet(gVisConFig.CurSubj).NodeSize(Node)*gVisConFig.Sphe.x+gVisConNet(gVisConFig.CurSubj).PosMat(Node,1);
NodeMarker.y = 2.5*gVisConNet(gVisConFig.CurSubj).NodeSize(Node)*gVisConFig.Sphe.y+gVisConNet(gVisConFig.CurSubj).PosMat(Node,2);
NodeMarker.z = 2.5*gVisConNet(gVisConFig.CurSubj).NodeSize(Node)*gVisConFig.Sphe.z+gVisConNet(gVisConFig.CurSubj).PosMat(Node,3);
gVisConFig.hNodeMarkers(Node) = surface(NodeMarker.x,NodeMarker.y,NodeMarker.z,...
    'EdgeColor','none','FaceColor',[0.5 0.5 1],'FaceLighting',...
    'gouraud','AmbientStrength',0.5,'FaceAlpha',0.4,'HitTest','off');
end

