%SELECTNODES Summary of this function goes here
%   Detailed explanation goes here
function ConnectNodesAll(Nodes,Method)
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
% Validate input arguments
if nargin<1
    error('Require at least one argument!');
end
if nargin<2
    Method = 'add';
end
if ~strcmpi(Method,'add') && ~strcmpi(Method,'replace')
    error('Wrong input method.It should be ''add'' or ''replace''.');
end
if ischar(Nodes)
    if strcmpi(Nodes,'all')
        Nodes = [1:gVisConFig.NodeNum];
    else
        error('Wrong input argument!');
    end
elseif ~isvector(Nodes)
    error('Input should be a vector or string');
end
if ~isempty(find(Nodes<=0,1))
    error('Nonexistent node! The lower bound of node is 1.');
end
if ~isempty(find(Nodes>gVisConFig.NodeNum,1))
    error('Nonexistent node! The upper bound of node is %d.',gVisConFig.NodeNum);
end

%Delete all edges of connected nodes if Method is replace
if strcmpi(Method,'replace')
    for i = 1:gVisConFig.NodeNum
        Connected = gVisConNet(gVisConFig.CurSubj).EdgeConnected(i,:);
        if(any(Connected))
            Showed = gVisConFig.EdgeShowed(i,:);
            if(any(Showed))
                delete(gVisConFig.hEdges(i,Showed));
                gVisConFig.hEdges(i,Showed) = NaN;
                gVisConFig.hEdges(Showed,i) = NaN;
                gVisConFig.EdgeShowed(i,Showed) = 0;
                gVisConFig.EdgeShowed(Showed,i) = 0;
            end
            gVisConNet(gVisConFig.CurSubj).EdgeConnected(i,Connected) = 0;
            gVisConNet(gVisConFig.CurSubj).EdgeConnected(Connected,i) = 0;
        end
    end
end

%Display all edges of input Nodes
ColorNum = size(colormap,1);
for i = Nodes
    EdgeConnected = true(1,gVisConFig.NodeNum);
    EdgeAdd = (gVisConNet(gVisConFig.CurSubj).ConMat(i,:) >= gVisConNet(gVisConFig.CurSubj).EdgeAbsThres);
    EdgeAdd = xor(EdgeAdd,EdgeAdd&gVisConFig.EdgeShowed(i,:));
    EdgeAdd = and(EdgeAdd, gVisConNet(gVisConFig.CurSubj).NodeShowed);
    for j = find(EdgeAdd)
        EdgeColor = interp1([0:1:ColorNum-1],colormap,...
            (gVisConNet(gVisConFig.CurSubj).ConMat(i,j)-gVisConNet(gVisConFig.CurSubj).EdgeAbsThres)/...
            (gVisConNet(gVisConFig.CurSubj).MaxWeight-gVisConNet(gVisConFig.CurSubj).EdgeAbsThres)*(ColorNum-1));
        gVisConFig.hEdges(i,j) = line(...
            [gVisConNet(gVisConFig.CurSubj).PosMat(i,1);gVisConNet(gVisConFig.CurSubj).PosMat(j,1)],...
            [gVisConNet(gVisConFig.CurSubj).PosMat(i,2);gVisConNet(gVisConFig.CurSubj).PosMat(j,2)],...
            [gVisConNet(gVisConFig.CurSubj).PosMat(i,3);gVisConNet(gVisConFig.CurSubj).PosMat(j,3)],...
            'LineWidth',gVisConNet(gVisConFig.CurSubj).EdgeWidth,'Color',EdgeColor,...
            'HitTest','off','Tag',['e_',num2str(i),'_',num2str(j)],'LineSmoothing',gVisConFig.LineSmooth);
        gVisConFig.hEdges(j,i) = gVisConFig.hEdges(i,j);
    end
    gVisConFig.EdgeShowed(i,:) = EdgeAdd|gVisConFig.EdgeShowed(i,:);
    gVisConFig.EdgeShowed(:,i) = EdgeAdd.'|gVisConFig.EdgeShowed(:,i);
    gVisConNet(gVisConFig.CurSubj).EdgeConnected(i,:)=EdgeConnected;
    gVisConNet(gVisConFig.CurSubj).EdgeConnected(:,i)=EdgeConnected.';
end
end

