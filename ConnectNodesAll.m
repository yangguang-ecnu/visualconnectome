%SELECTNODES Summary of this function goes here
%   Detailed explanation goes here
function ConnectNodesAll(Nodes,Method)
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
% Validate input arguments
if nargin<1
    error('Require at least one argument!');
end
if nargin<2
    Method='add';
end
if ~strcmpi(Method,'add') && ~strcmpi(Method,'replace')
    error('Wrong input method.It should be ''add'' or ''replace''.');
end
if ischar(Nodes)
    if strcmpi(Nodes,'all')
        Nodes=[1:gNetwork.NodeNum];
    else
        error('Wrong input argument!');
    end
elseif ~isvector(Nodes)
    error('Input should be a vector or string');
end
if ~isempty(find(Nodes<=0,1))
    error('Nonexistent node! The lower bound of node is 1.');
end
if ~isempty(find(Nodes>gNetwork.NodeNum,1))
    error('Nonexistent node! The upper bound of node is %d.',gNetwork.NodeNum);
end

%Delete all edges of connected nodes if Method is replace
if strcmpi(Method,'replace')
    for i=1:gNetwork.NodeNum
        Connected=gNetwork.EdgeConnected(i,:);
        if(any(Connected))
            Showed=gFigAxes.EdgeShowed(i,:);
            if(any(Showed))
                delete(gFigAxes.hEdges(i,Showed));
                gFigAxes.hEdges(i,Showed)=NaN;
                gFigAxes.hEdges(Showed,i)=NaN;
                gFigAxes.EdgeShowed(i,Showed)=0;
                gFigAxes.EdgeShowed(Showed,i)=0;
            end
            gNetwork.EdgeConnected(i,Connected)=0;
            gNetwork.EdgeConnected(Connected,i)=0;
        end
    end
end

%Display all edges of input Nodes
ColorNum=size(gNetwork.EdgeCmap,1);
for i=Nodes
    EdgeConnected=true(1,gNetwork.NodeNum);
    EdgeAdd=(gNetwork.AdjMat(i,:)>=gNetwork.EdgeRange(1))...
        & (gNetwork.AdjMat(i,:)<=gNetwork.EdgeRange(2));
    EdgeAdd=xor(EdgeAdd,EdgeAdd&gFigAxes.EdgeShowed(i,:));
    for j=find(EdgeAdd)
        EdgeColor=interp1([0:1:ColorNum-1],gNetwork.EdgeCmap,...
            (gNetwork.AdjMat(i,j)-gNetwork.EdgeRange(1))/...
            (gNetwork.EdgeRange(2)-gNetwork.EdgeRange(1))*(ColorNum-1));
        gFigAxes.hEdges(i,j)=line(...
            [gNetwork.PosMat(i,1);gNetwork.PosMat(j,1)],...
            [gNetwork.PosMat(i,2);gNetwork.PosMat(j,2)],...
            [gNetwork.PosMat(i,3);gNetwork.PosMat(j,3)],...
            'LineWidth',gNetwork.EdgeWidth,'Color',EdgeColor,...
            'HitTest','off','Tag',['e_',num2str(i),'_',num2str(j)]);
        gFigAxes.hEdges(j,i)=gFigAxes.hEdges(i,j);
    end
    gFigAxes.EdgeShowed(i,:)=EdgeAdd|gFigAxes.EdgeShowed(i,:);
    gFigAxes.EdgeShowed(:,i)=EdgeAdd.'|gFigAxes.EdgeShowed(:,i);
    gNetwork.EdgeConnected(i,:)=EdgeConnected;
    gNetwork.EdgeConnected(:,i)=EdgeConnected.';
end
end

