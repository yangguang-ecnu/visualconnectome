%VisualConnectome is a matlab toolbox of human connectome visualization.
%
%Revision 0.10  2010/10/21  by Dai @NICA Group  solar2in@gmail.com  

function VisualConnectome(AdjMat,PosMat,varargin)
global gFigAxes; 
global gNetwork;
global gSurface;

%Forbid multiwindows
hFig=findobj('Tag','VisConFig');
if ~isempty(hFig)
    figure(hFig);
else
    ScrSize=get(0,'ScreenSize');
    FigPos=[ScrSize(1,[3,4])/2-[320,240],640,480];
    figure('Name','Visual Connectome','NumberTitle','off',...
    'Tag','VisConFig','Color','k','MenuBar','none','ToolBar','none',...
    'DeleteFcn','clear global gHandle gFigAxes gNetwork gSurface;',...
    'Renderer','OpenGL','InvertHardcopy','off',...
    'Units','pixel','Position',FigPos);
end

%
VisConPath=which('VisualConnectome.m');
VisConPath=VisConPath(1:end-length('VisualConnectome.m'));
addpath(fullfile(VisConPath,'Functions'));
addpath(fullfile(VisConPath,'Functions','GUI'));
Icons=load(fullfile(VisConPath,'Resources','Icons.dat'),'-mat');
gFigAxes.TbarIcons=Icons.TbarIcons;
gFigAxes.PointerIcons=Icons.PointerIcons;
VisCon_Toolbar();
if nargin==0,   return;     end

%Get the number of stardand arguments and optional arguments
optargin=length(varargin);
if nargin>2 && ~isnumeric(PosMat)
    varargin=[{PosMat} varargin];
    optargin=optargin+1;
end
stdargin=nargin-optargin;

ParaNames={'NodeScale','NodeColor','NodeName','EdgeWidth','EdgeColormap',...
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
        Defaults={gNetwork.NodeScale,gNetwork.NodeColor,gNetwork.NodeName,...
            gNetwork.EdgeWidth,gNetwork.EdgeCmap,...
            gSurface.LSurfData,gSurface.RSurfData,...
            gSurface.LSurfColor,gSurface.RSurfColor,...
            gSurface.LSurfAlpha,gSurface.RSurfColor};
    else
        error('Wrong VisualConnetome file format!');
    end
%AdjMat & PosMat input
else
    n=size(AdjMat,1);
    if size(AdjMat,2)~=n
        error('AdjMat should be square matrix!');
    end
    if size(PosMat,1)~=n
        error('The number of rows in PosMat should equal to AdjMat ')
    end
    gNetwork.AdjMat=AdjMat;
    gNetwork.PosMat=PosMat;
    gNetwork.NodeNum=n;
    clear AdjMat PosMat;
    Defaults={2,'y','',1.5,'hot',...
    [],[],[0.7 0.7 0.7],[0.7 0.7 0.7],0.3,0.3};
end

%
[gNetwork.NodeScale,...
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
VisCon_DrawNodes();
VisCon_AxesInd on;
VisCon_InformBox on;
VisCon_EdgeCbar on;
end

