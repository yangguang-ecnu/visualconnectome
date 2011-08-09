%VisualConnectome is a matlab toolbox of human connectome visualization.
%It can be used to analyse the brain network as well with the aid of
%Brain Connectivity Toolbox.
%
%This is VisualConnectome main function.
%
%Revision 0.10  2010/10/21  by Dai @ NICA Group,CASIA   solar2ain@gmail.com
%Revision 0.20  2010/10/21  by Dai @ NICA Group,CASIA   solar2ain@gmail.com

function VisualConnectome(AdjMat,PosMat,varargin)
global gFigAxes;
global gNetwork;
global gSurface;
%Add function path
gFigAxes.VisConPath=which('VisualConnectome.m');
gFigAxes.VisConPath=gFigAxes.VisConPath(1:end-length('VisualConnectome.m'));
addpath(fullfile(gFigAxes.VisConPath,'Functions'));
addpath(fullfile(gFigAxes.VisConPath,'Functions','GUI'));
addpath(fullfile(gFigAxes.VisConPath,'Plugins','SurfStat'));
addpath(fullfile(gFigAxes.VisConPath,'Plugins','BCT'));

%Call figure if it exsits, otherwise create new
hFig=findobj('Tag','VisConFig');
if ~isempty(hFig)
    figure(hFig);
else
    VisCon_Figure();
end
if nargin==0,   return;     end

%Get the number of stardand arguments and optional arguments
optargin=length(varargin);
if nargin>2 && ~isnumeric(PosMat)
    varargin=[{PosMat} varargin];
    optargin=optargin+1;
end
stdargin=nargin-optargin;

ParaNames={'NodeStyle','NodeScale','NodeColor','NodeName','EdgeWidth','EdgeColormap',...
    'LSurfData','RSurfData','LSurfColor','RSurfColor','LSurfAlpha','RSurfAlpha'};

%Different methods for VCDataSturct input and AdjMat,PosMat input
%VCDataStruct input
if stdargin<2
    if ~isstruct(AdjMat)
        error('Require at least two arguments!');
    elseif isfield(AdjMat,'Network') && isfield(AdjMat,'Surface')
        gNetwork=AdjMat.Network;
        gSurface=AdjMat.Surface;
        clear AdjMat;
        Defaults={gNetwork.NodeStyle,gNetwork.NodeScale,gNetwork.NodeColor,gNetwork.NodeName,...
            gNetwork.EdgeWidth,gNetwork.EdgeCmap,...
            gSurface.LSurfData,gSurface.RSurfData,...
            gSurface.LSurfColor,gSurface.RSurfColor,...
            gSurface.LSurfAlpha,gSurface.RSurfAlpha};
    else
        error('Wrong VisualConnetome file format!');
    end
%AdjMat & PosMat input
else
    if ~isequal(AdjMat,AdjMat.')
        error('Adjacent matrix should be symmetric!');
    end
    n=length(AdjMat);
    if size(PosMat,1)~=n
        error('Position matrix should have equal rows as adjacent matrix!')
    end
    gNetwork.AdjMat=AdjMat;
    gNetwork.PosMat=PosMat;
    gNetwork.NodeNum=n;
    clear AdjMat PosMat;
    Defaults={'sphere',2,'y','',1.5,gFigAxes.DltCmap,...
    [],[],[0.7 0.7 0.7],[0.7 0.7 0.7],0.2,0.2};
end

%
[gNetwork.NodeStyle,...
    gNetwork.NodeScale,...
    gNetwork.NodeColor,...
    gNetwork.NodeName,...
    gNetwork.EdgeWidth,...
    gNetwork.EdgeCmap,...
    gSurface.LSurfData,...
    gSurface.RSurfData,...
    gSurface.LSurfColor,...
    gSurface.RSurfColor,...
    gSurface.LSurfAlpha,...
    gSurface.RSurfAlpha]=VisCon_GetArgs(ParaNames,Defaults,varargin{:});

%Preprocess
VisCon_Preproc();

%Create Figure
VisCon_FigOper();
VisCon_Axes();

%Draw Network
%VisCon_DrawNodes(gNetwork.NodeStyle);
ShowNodes all;
AxesIndicator on;
InformationBox on;
EdgeColorbar on;
BrainSurf off;
VisCon_SetButtonEn(...
    'VisConTbarSave','on',...
    'VisConTbarAxesInd','on',...
    'VisConTbarEdgeCbar','on',...
    'VisConTbarInformBox','on',...
    'VisConTbarEdgeThres','on');
if ~isempty(gSurface.LSurfData) || ~isempty(gSurface.RSurfData)
    VisCon_SetButtonEn('VisConTbarSurfVis','on');
end
VisCon_SetMenuEn(...
    'VisConMenuSave','on',...
    'VisConMenuTools','on',...
    'VisConMenuNetwork','on',...
    'VisConMenuSurface','on');
if ~isempty(gSurface.LSurfData)
    VisCon_SetMenuEn('VisConMenuLSurfVis','on');
end
if ~isempty(gSurface.RSurfData)
    VisCon_SetMenuEn('VisConMenuRSurfVis','on');
end
end

