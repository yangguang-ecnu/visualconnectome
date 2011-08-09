function DisconnectTwoNodes(PairNodes)
global gVisConFig;
global gVisConNet;
hFig = findobj('Tag','VisConFig');
hAxes = findobj(hFig,'Tag','VisConAxes');
if isempty(hFig)
    error('VisualConnectome is not running');
else
    set(0,'CurrentFigure',hFig);
end
if isempty(hAxes)
    error('You must first create or open a VCT file!');
else
    set(hFig,'CurrentAxes',hAxes);
end
if nargin<0
    error('Require at least one argument!');
end
if size(PairNodes,2)~=2
    error('The column of input argument should be two!');
end
if ~isempty(find(PairNodes<=0,1))
    error('Nonexistent node! The lower bound of node is 1.');
end
if ~isempty(find(PairNodes>gVisConFig.NodeNum,1))
    error('Nonexistent node! The upper bound of node is %d.',gVisConFig.NodeNum);
end

PairNum = size(PairNodes,1);
for i=1:PairNum
    if gVisConNet(gVisConFig.CurSubj).EdgeConnected(PairNodes(i,1),PairNodes(i,2))==1
        if gVisConFig.EdgeShowed(PairNodes(i,1),PairNodes(i,2))==1
            delete(gVisConFig.hEdges(PairNodes(i,1),PairNodes(i,2)));
            gVisConFig.EdgeShowed(PairNodes(i,1),PairNodes(i,2))=0;
            gVisConFig.EdgeShowed(PairNodes(i,2),PairNodes(i,1))=0;
        end
        gVisConNet(gVisConFig.CurSubj).EdgeConnected(PairNodes(i,1),PairNodes(i,2))=0;
        gVisConNet(gVisConFig.CurSubj).EdgeConnected(PairNodes(i,2),PairNodes(i,1))=0;
    end
end

