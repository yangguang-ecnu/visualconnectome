%HIDEALLEDGES Summary of this function goes here
%   Detailed explanation goes here
function DisconnectNodesAll(Nodes)
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

hFig=findobj('Tag','VisConFig');
hAxes=findobj(hFig,'Tag','VisConAxes');
set(hFig,'CurrentAxes',hAxes);
%Delete all edges of input Nodes
for i=Nodes
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

