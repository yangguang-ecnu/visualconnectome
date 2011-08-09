%HIDEALLEDGES Summary of this function goes here
%   Detailed explanation goes here
function DisconnectNodesAll(Nodes)
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
if ischar(Nodes)
    if strcmpi(Nodes,'all')
        Nodes=[1:gVisConFig.NodeNum];
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

hFig = findobj('Tag','VisConFig');
hAxes = findobj(hFig,'Tag','VisConAxes');
set(hFig,'CurrentAxes',hAxes);
%Delete all edges of input Nodes
for i = Nodes
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

