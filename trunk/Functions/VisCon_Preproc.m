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
gNetwork.EdgeCmap=colormap;

%Preallocate handles of some objects
gFigAxes.hNodes=zeros(gNetwork.NodeNum,1)*NaN;
gFigAxes.hSelMarkers=zeros(gNetwork.NodeNum,1)*NaN;
gFigAxes.hEdges=zeros(gNetwork.NodeNum)*NaN;

%Network Attribute
gNetwork.AdjMat(1:gNetwork.NodeNum+1:end)=0;    %Diagonal elements equal to zero
gNetwork.EdgeNum=gNetwork.NodeNum*(gNetwork.NodeNum-1);
SortedAdj=sort(gNetwork.AdjMat(:));
gNetwork.SortedAdj=SortedAdj(gNetwork.NodeNum+1:end);
gNetwork.MinAdj=min(SortedAdj);
gNetwork.MaxAdj=max(SortedAdj);
gNetwork.EdgeRange=[gNetwork.MinAdj gNetwork.MaxAdj];
gNetwork.Selected=[];

end

