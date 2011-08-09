%VISCON_PREPROC Summary of this function goes here
%   Detailed explanation goes here
function VisCon_Preproc()
global gFigAxes;
global gNetwork;
global gSurface;

%Validate NodeScale data
if ~isvector(gNetwork.NodeScale) || ~isnumeric(gNetwork.NodeScale)
    error('NodeScale should be a scalar or a vector!');
end
if length(gNetwork.NodeScale)==1
    gNetwork.NodeScale=ones(gNetwork.NodeNum,1)*gNetwork.NodeScale;
elseif length(gNetwork.NodeScale)~=gNetwork.NodeNum
    error('The length of NodeScale is not equal to the number of nodes!');
end

%Validate NodeColor data
if ischar(gNetwork.NodeColor)
    switch gNetwork.NodeColor
        case {'y','yellow'}
            gNetwork.NodeColor=[1 1 0];
        case {'m','magenta'}
            gNetwork.NodeColor=[1 0 1];
        case {'c','cyan'}
            gNetwork.NodeColor=[1 0 1];
        case {'r','red'}
            gNetwork.NodeColor=[1 0 0];
        case {'g','green'}
            gNetwork.NodeColor=[0 1 0];
        case {'b','blue'}
            gNetwork.NodeColor=[0 0 1];
        case {'w','white'}
            gNetwork.NodeColor=[1 1 1];
        case {'k','black'}
            gNetwork.NodeColor=[0 0 0];
        otherwise
            error('Wrong input node color!')
    end
end
if size(gNetwork.NodeColor,1)==1
    gNetwork.NodeColor=repmat(gNetwork.NodeColor,gNetwork.NodeNum,1);
elseif size(gNetwork.NodeColor,1)~=gNetwork.NodeNum
    error('The length of NodeColor is not equal to the number of nodes!');
end

%Validate NodeName data
if ~isempty(gNetwork.NodeName) && length(gNetwork.NodeName)~=gNetwork.NodeNum
    error('The length of NodeName is not equal to the number of nodes!');
end

%Validate EdgeWidth data
if ~isnumeric(gNetwork.EdgeWidth) || ~isscalar(gNetwork.EdgeWidth)
    error('EdgeWidth should be a scalar!');
end

%Validate Edge Colormap
colormap(gNetwork.EdgeCmap);

%Network Attribute
gNetwork.AdjMat(1:gNetwork.NodeNum+1:end)=0;    %Diagonal elements equal to zero
gNetwork.AdjMat(gNetwork.AdjMat<0.1)=0;
gNetwork.EdgeNum=gNetwork.NodeNum*(gNetwork.NodeNum-1)/2;
SortedWeight=triu(gNetwork.AdjMat);
SortedWeight=sort(SortedWeight(:));
gNetwork.SortedWeight=SortedWeight(SortedWeight>=0.1);
gNetwork.NzEdgeNum=length(gNetwork.SortedWeight);
gNetwork.MinWeight=min(gNetwork.SortedWeight);
gNetwork.MaxWeight=max(gNetwork.SortedWeight);
gNetwork.EdgeRange=[gNetwork.MinWeight gNetwork.MaxWeight];
gNetwork.EdgeCmap=colormap;
gNetwork.EdgeConnected=false(gNetwork.NodeNum);

%Preallocate handles of some objects
gFigAxes.hNodes=zeros(gNetwork.NodeNum,1)*NaN;
gFigAxes.hNodeMarkers=zeros(gNetwork.NodeNum,1)*NaN;
gFigAxes.hEdges=zeros(gNetwork.NodeNum)*NaN;
%Create unit sphere
[gFigAxes.Sphe.x,gFigAxes.Sphe.y,gFigAxes.Sphe.z]=sphere(20);
%Create unit cube
gFigAxes.Cube.Vertices=[1 1 1;1 -1 1;-1 -1 1;-1 1 1;1 1 -1;1 -1 -1;-1 -1 -1;-1 1 -1];
gFigAxes.Cube.Faces=[1 2 3 4;5 6 7 8;1 2 6 5;3 4 8 7;1 4 8 5;2 3 7 6];
%Create displaying property
gFigAxes.NodeSelected=[];
gFigAxes.EdgeShowed=false(gNetwork.NodeNum);

end

