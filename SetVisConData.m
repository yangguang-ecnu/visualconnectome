%SETDATA Summary of this function goes here
%   Detailed explanation goes here
function SetVisConData(Sub, varargin)
global gVisConFig;
global gVisConNet;
global gVisConSurf;

if ~isnumeric(Sub)
    varargin = [(Sub), varargin(:)];
    Sub = gVisConFig.CurSubj;
end

hFig = findobj('Tag','VisConFig');
hAxes = findobj('Tag','VisConAxes');
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
VarNum = length(varargin);
if mod(VarNum+1,2) == 0
    error('The number of arguments must be even!');
end

ParaNames={'ConMat',...
    'PosMat',...
    'NodeStyle',...
    'NodeSize',...
    'NodeColor',...
    'NodeName',...
    'EdgeWidth',...
    'LSurfData',...
    'RSurfData',...
    'LSurfColor',...
    'RSurfColor',...
    'LSurfAlpha',...
    'RSurfAlpha'};

Defaults = {gVisConNet(Sub).ConMat,...
    gVisConNet(Sub).PosMat,...
    gVisConNet(Sub).NodeStyle,...
    gVisConNet(Sub).NodeSize,...
    gVisConNet(Sub).NodeColor,...
    gVisConNet(Sub).NodeName,...
    gVisConNet(Sub).EdgeWidth,...
    gVisConSurf.LSurfData,...
    gVisConSurf.RSurfData,...
    gVisConSurf.LSurfColor,...
    gVisConSurf.RSurfColor,...
    gVisConSurf.LSurfAlpha,...
    gVisConSurf.RSurfAlpha};

[ConMat,...
    PosMat,...
    NodeStyle,...
    NodeSize,...
    NodeColor,...
    NodeName,...
    EdgeWidth,...
    LSurfData,...
    RSurfData,...
    LSurfColor,...
    RSurfColor,...
    LSurfAlpha,...
    RSurfAlpha] = VisCon_GetArgs(ParaNames,Defaults,varargin{:});

%Validate Connectivity Matrix and Position Matrix
if ~isequal(ConMat,ConMat.')
    error('The connectivity matrix should be symmetric!');
end

if size(PosMat,1) ~= gVisConFig.NodeNum
    error('The position matrix should have equal rows as adjacent matrix!');
end
if size(PosMat,2) ~= 3
    error('The position matrix should contain the 3-d coordinates of nodes!');
end
%Validate NodeSize data
if ~isvector(NodeSize) || ~isnumeric(NodeSize)
    error('NodeSize should be a scalar or a vector!');
end
if length(NodeSize) == 1
    NodeSize = ones(gVisConFig.NodeNum,1) * NodeSize;
elseif length(NodeSize) ~= gVisConFig.NodeNum
    error('The length of NodeSize is not equal to the number of nodes!');
end

%Validate NodeColor data
if ischar(NodeColor)
    switch NodeColor
        case {'y','yellow'}
            NodeColor=[1 1 0];
        case {'m','magenta'}
            NodeColor=[1 0 1];
        case {'c','cyan'}
            NodeColor=[1 0 1];
        case {'r','red'}
            NodeColor=[1 0 0];
        case {'g','green'}
            NodeColor=[0 1 0];
        case {'b','blue'}
            NodeColor=[0 0 1];
        case {'w','white'}
            NodeColor=[1 1 1];
        case {'k','black'}
            NodeColor=[0 0 0];
        otherwise
            error('Wrong input node color!')
    end
end
if size(NodeColor,1) == 1
    NodeColor = repmat(NodeColor,gVisConFig.NodeNum,1);
elseif size(NodeColor,1) ~= gVisConFig.NodeNum
    error('The length of NodeColor is not equal to the number of nodes!');
end

%Validate NodeName data
if ~isempty(NodeName) && length(NodeName) ~= gVisConFig.NodeNum
    error('The length of NodeName is not equal to the number of nodes!');   
end

%Validate NodeStyle data
if iscell(NodeStyle) && length(NodeStyle) == gVisConFig.NodeNum
    for i = 1:gVisConFig.NodeNum
        if ~strcmpi(NodeStyle{i}, 'cube') && ~strcmpi(NodeStyle{i}, 'sphere')
            error('Node style should be only ''cube'' or ''sphere''!')
        end
    end
elseif ischar(NodeStyle)
    if ~strcmpi(NodeStyle, 'cube') && ~strcmpi(NodeStyle, 'sphere')
        error('Node style should be only ''cube'' or ''sphere''!')
    end
    NodeStyle = repmat(NodeStyle, gVisConFig.NodeNum, 1);
else
    error('Error node style input!');
end

%Validate EdgeWidth data
if ~isnumeric(EdgeWidth) || ~isscalar(EdgeWidth)
    error('EdgeWidth should be a scalar!');
end

%Set Data
gVisConNet(Sub).ConMat = ConMat;
gVisConNet(Sub).PosMat = PosMat;
gVisConNet(Sub).NodeStyle = NodeStyle;
gVisConNet(Sub).NodeSize = NodeSize;
gVisConNet(Sub).NodeColor = NodeColor;
gVisConNet(Sub).NodeName = NodeName;
gVisConNet(Sub).EdgeWidth = EdgeWidth;
gVisConSurf.LSurfData = LSurfData;
gVisConSurf.RSurfData = RSurfData;
gVisConSurf.LSurfColor = LSurfColor;
gVisConSurf.RSurfColor = RSurfColor;
gVisConSurf.LSurfAlpha = LSurfAlpha;
gVisConSurf.RSurfAlpha = RSurfAlpha;

%Redraw
if(Sub == gVisConFig.CurSubj)
    PName = {'PosMat','NodeStyle','NodeSize','NodeColor'};
    for i = 1:length(PName)
        if isempty(strmatch(lower(PName{i}), lower(varargin(1:2:end)), 'exact'))
            continue;
        end
        %Redraw Nodes
        VisCon_UpdateNodes();
    end
    
    PName = {'ConMat', 'PosMat','NodeStyle','NodeSize','NodeColor', 'EdgeWidth'};
    for i = 1:length(PName)
        if isempty(strmatch(lower(PName{i}), lower(varargin(1:2:end)), 'exact'))
            continue;
        end
        %Redraw Edges
        VisCon_UpdateEdges('wei');
    end
    
    PName = {'NodeName'};
    for i = 1:length(PName)
        if isempty(strmatch(lower(PName{i}), lower(varargin(1:2:end)), 'exact'))
            continue;
        end
        if ~isempty(gVisConFig.NodeSelected)
            VisCon_UpdateInfo(gVisConFig.NodeSelected(end));
        end
    end
end
VisCon_SetSaveState('Unsaved');
end

