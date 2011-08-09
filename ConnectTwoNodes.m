%CONNECTNODES Summary of this function goes here
%   Detailed explanation goes here
function ConnectTwoNodes(PairNodes)
global gFigAxes;
global gNetwork;
hFig=findobj('Tag','VisConFig');
hAxes=findobj(hFig,'Tag','VisConAxes');
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
if ~isempty(find(PairNodes>gNetwork.NodeNum,1))
    error('Nonexistent node! The upper bound of node is %d.',gNetwork.NodeNum);
end

PairNum=size(PairNodes,1);
ColorNum=size(gNetwork.EdgeCmap,1);
for i=1:PairNum
    if gNetwork.AdjMat(PairNodes(i,1),PairNodes(i,2))<gNetwork.EdgeRange(1)...
            || gNetwork.AdjMat(PairNodes(i,1),PairNodes(i,2))>gNetwork.EdgeRange(2)
        fprintf(...
            ['Notice: Nodes %i and %i will be connected but edge not showed.\n'...
            'Because edge weight %.6f is out of range of edge threshold.\n'...
            'Try adjusting edge threshold to make it visible!\n'...
            'Note that you will never see edges whose weight is zero!\n'],...
            PairNodes(i,1),PairNodes(i,2),gNetwork.AdjMat(PairNodes(i,1),PairNodes(i,2)));
        gNetwork.EdgeConnected(PairNodes(i,1),PairNodes(i,2))=1;
        gNetwork.EdgeConnected(PairNodes(i,2),PairNodes(i,1))=1;
        continue;
    end
    if gFigAxes.EdgeShowed(PairNodes(i,1),PairNodes(i,2))==0
        EdgeColor=interp1([0:1:ColorNum-1],gNetwork.EdgeCmap,...
            (gNetwork.AdjMat(PairNodes(i,1),PairNodes(i,2))-gNetwork.EdgeRange(1))/...
            (gNetwork.EdgeRange(2)-gNetwork.EdgeRange(1))*(ColorNum-1));
        gFigAxes.hEdges(PairNodes(i,1),PairNodes(i,2))=line(...
            [gNetwork.PosMat(PairNodes(i,1),1);gNetwork.PosMat(PairNodes(i,2),1)],...
            [gNetwork.PosMat(PairNodes(i,1),2);gNetwork.PosMat(PairNodes(i,2),2)],...
            [gNetwork.PosMat(PairNodes(i,1),3);gNetwork.PosMat(PairNodes(i,2),3)],...
            'LineWidth',gNetwork.EdgeWidth,'Color',EdgeColor,'HitTest','off',...
            'Tag',['e_',num2str(PairNodes(i,1)),'_',num2str(PairNodes(i,2))]);
        gFigAxes.hEdges(PairNodes(i,2),PairNodes(i,1))=gFigAxes.hEdges(PairNodes(i,1),PairNodes(i,2));
        gFigAxes.EdgeShowed(PairNodes(i,1),PairNodes(i,2))=1;
        gFigAxes.EdgeShowed(PairNodes(i,2),PairNodes(i,1))=1;
    end
    gNetwork.EdgeConnected(PairNodes(i,1),PairNodes(i,2))=1;
    gNetwork.EdgeConnected(PairNodes(i,2),PairNodes(i,1))=1;
end
end

