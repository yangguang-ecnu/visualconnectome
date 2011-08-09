%CONNECTNODES Summary of this function goes here
%   Detailed explanation goes here
function ConnectTwoNodes(PairNodes)
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
ColorNum = size(colormap,1);
for i = 1:PairNum
    gVisConNet(gVisConFig.CurSubj).EdgeConnected(PairNodes(i,1),PairNodes(i,2)) = true;
    gVisConNet(gVisConFig.CurSubj).EdgeConnected(PairNodes(i,2),PairNodes(i,1)) = true;
    if(PairNodes(i,1) == PairNodes(i,2))
        continue;
    end
    if(~gVisConNet(gVisConFig.CurSubj).NodeShowed(PairNodes(i,1)) || ~gVisConNet(gVisConFig.CurSubj).NodeShowed(PairNodes(i,2)))
        fprintf(...
            ['Notice: Nodes %i and %i will be connected but edge not showed.\n'...
            'Because at least one of the nodes is hiden.\n'],...
            PairNodes(i,1),PairNodes(i,2));
       continue; 
    end
    if gVisConNet(gVisConFig.CurSubj).ConMat(PairNodes(i,1),PairNodes(i,2))<gVisConNet(gVisConFig.CurSubj).EdgeAbsThres
        fprintf(...
            ['Notice: Nodes %i and %i will be connected but edge not showed.\n'...
            'Because edge weight %.6f is out of range of edge threshold.\n'],...
            PairNodes(i,1),PairNodes(i,2),gVisConNet(gVisConFig.CurSubj).ConMat(PairNodes(i,1),PairNodes(i,2)));
        gVisConNet(gVisConFig.CurSubj).EdgeConnected(PairNodes(i,1),PairNodes(i,2))=1;
        gVisConNet(gVisConFig.CurSubj).EdgeConnected(PairNodes(i,2),PairNodes(i,1))=1;
        continue;
    end
    if gVisConFig.EdgeShowed(PairNodes(i,1),PairNodes(i,2))==0
        EdgeColor=interp1([0:1:ColorNum-1],colormap,...
            (gVisConNet(gVisConFig.CurSubj).ConMat(PairNodes(i,1),PairNodes(i,2))-gVisConNet(gVisConFig.CurSubj).EdgeAbsThres)/...
            (gVisConNet(gVisConFig.CurSubj).MaxWeight-gVisConNet(gVisConFig.CurSubj).EdgeAbsThres)*(ColorNum-1));
        gVisConFig.hEdges(PairNodes(i,1),PairNodes(i,2))=line(...
            [gVisConNet(gVisConFig.CurSubj).PosMat(PairNodes(i,1),1);gVisConNet(gVisConFig.CurSubj).PosMat(PairNodes(i,2),1)],...
            [gVisConNet(gVisConFig.CurSubj).PosMat(PairNodes(i,1),2);gVisConNet(gVisConFig.CurSubj).PosMat(PairNodes(i,2),2)],...
            [gVisConNet(gVisConFig.CurSubj).PosMat(PairNodes(i,1),3);gVisConNet(gVisConFig.CurSubj).PosMat(PairNodes(i,2),3)],...
            'LineWidth',gVisConNet(gVisConFig.CurSubj).EdgeWidth,'Color',EdgeColor,'HitTest','off',...
            'Tag',['e_',num2str(PairNodes(i,1)),'_',num2str(PairNodes(i,2))],'LineSmoothing',gVisConFig.LineSmooth);
        gVisConFig.hEdges(PairNodes(i,2),PairNodes(i,1))=gVisConFig.hEdges(PairNodes(i,1),PairNodes(i,2));
        gVisConFig.EdgeShowed(PairNodes(i,1),PairNodes(i,2))=1;
        gVisConFig.EdgeShowed(PairNodes(i,2),PairNodes(i,1))=1;
    end
end
end

