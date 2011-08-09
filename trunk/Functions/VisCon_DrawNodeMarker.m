function VisCon_DrawNodeMarker(Node)
global gFigAxes;
global gNetwork;
NodeMarker.x=2.5*gNetwork.NodeScale(Node)*gFigAxes.Sphe.x+gNetwork.PosMat(Node,1);
NodeMarker.y=2.5*gNetwork.NodeScale(Node)*gFigAxes.Sphe.y+gNetwork.PosMat(Node,2);
NodeMarker.z=2.5*gNetwork.NodeScale(Node)*gFigAxes.Sphe.z+gNetwork.PosMat(Node,3);
gFigAxes.hNodeMarkers(Node)=surface(NodeMarker.x,NodeMarker.y,NodeMarker.z,...
    'EdgeColor','none','FaceColor',[0.5 0.5 1],'FaceLighting',...
    'gouraud','AmbientStrength',0.5,'FaceAlpha',0.3,'HitTest','off');
end

