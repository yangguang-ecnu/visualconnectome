function VisCon_NodeLabel(Sw)
global gVisConFig;
global gVisConNet;

PosMat = gVisConNet(gVisConFig.CurSubj).PosMat;
for iNode = 1:gVisConFig.NodeNum
    if ~isempty(gVisConNet(gVisConFig.CurSubj).NodeName)
        NodeLabel = [blanks(4) gVisConNet(gVisConFig.CurSubj).NodeName{iNode}];
    else
        NodeLabel = [blanks(4), 'n', num2str(iNode)];
    end
    text(PosMat(iNode, 1), PosMat(iNode, 2), PosMat(iNode, 3),...
        NodeLabel, 'HitTest', 'off', 'Color', 'w', 'Interpreter', 'none',...
        'FontSize', 10, 'FontWeight', 'bold', 'VerticalAlignment', 'middle',...
        'Tag',['n' num2str(iNode) 'label']);
end
end

