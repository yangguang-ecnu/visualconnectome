%SETDATA Summary of this function goes here
%   Detailed explanation goes here
function SetVisConData(varargin)
global gNetwork;
global gSurface;
if nargin==0
    error('Require arguments!');
end
VarNum=length(varargin);
if mod(VarNum+1,2)==0
    error('The number of arguments must be even!');
end

for i=1:2:VarNum
    Pname=varargin{i};
    if ~ischar(Pname)
        error('The %d parameter name is not a string!',(i+1)/2);
    end
    switch lower(Pname)
        case 'adjmat'
            gNetwork.AdjMat=varargin{i+1};
        case 'posmat'
            gNetwork.PosMat=varargin{i+1};
        case 'nodescale'
            gNetwork.NodeScale=varargin{i+1};
        case 'nodecolor'
            gNetwork.NodeColor=varargin{i+1};
        case 'nodename'
            gNetwork.NodeName=varargin{i+1};
        case 'edgewidth'
            gNetwork.EdgeWidth=varargin{i+1};
        case 'colormap'
            gNetwork.Cmap=varargin{i+1};
        case 'lsurfdata'
            gSurface.LSurfData=varargin{i+1};
        case 'rsurfdata'
            gSurface.RSurfData=varargin{i+1};
        case 'lcolordata'
            gSurface.LColorData=varargin{i+1};
        case 'rcolordata'
            gSurface.RColorData=varargin{i+1};
        case 'lalphadata'
            gSurface.LAlphaData=varargin{i+1};
        case 'ralphadata'
            gSurface.RAlphaData=varargin{i+1};
        otherwise
            error('Wrong parameter name!');
    end
    
end
end

