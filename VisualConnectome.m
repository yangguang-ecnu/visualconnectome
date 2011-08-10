%VisualConnectome is a matlab toolbox of human connectome visualization.
%It can be used to analyse the brain network as well with the aid of
%Brain Connectivity Toolbox.
%
%This is VisualConnectome main function.
%
%Revision 0.10a 2010/10/21 by Dai Dai @NICA Group,CASIA solar2ain@gmail.com
%Revision 0.20a 2010/10/21 by Dai Dai @NICA Group,CASIA solar2ain@gmail.com
%Revision 0.20b 2011/05/21 by Dai Dai @NICA Group,CASIA solar2ain@gmail.com
%Revision 0.30a 2011/07/28 by Dai Dai @NICA Group,CASIA solar2ain@gmail.com
%Revision 0.35a 2011/08/01 by Dai Dai @NICA Group,CASIA solar2ain@gmail.com
%Revision 0.35b 2011/08/01 by Dai Dai @NICA Group,CASIA solar2ain@gmail.com

function VisualConnectome(ConMat,PosMat,varargin)
global gVisConFig;
global gVisConNet;
global gVisConSurf;
global gVisConState;
gVisConState = 'Starting';
%Add function path
gVisConFig.VisConPath = which('VisualConnectome.m');
gVisConFig.VisConPath = gVisConFig.VisConPath(1:end-length('VisualConnectome.m'));
addpath(fullfile(gVisConFig.VisConPath,'Functions'));
addpath(fullfile(gVisConFig.VisConPath,'Functions','GUI'));
addpath(fullfile(gVisConFig.VisConPath,'Plugins','SurfStat'));
addpath(fullfile(gVisConFig.VisConPath,'Plugins','BCT'));

%Call figure if it exsits, otherwise create new
hFig = findobj('Tag','VisConFig');
if ~isempty(hFig)
    figure(hFig);
else
    VisCon_NewFig();
end
if nargin == 0,   return;     end

ParaNames = {'NodeStyle',...
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

%Different methods for VCDataSturct input and ConMat,PosMat input
gVisConState = 'Loading';
if nargin == 1
    %VCDataStruct input
    if ~isstruct(ConMat)
        error('Require at least two arguments!');
    elseif ~isfield(ConMat,'VisConNet') || ~isfield(ConMat,'VisConFig')
        error('Wrong VisualConnetome file format!');
    end
    
    gVisConNet = ConMat.VisConNet;
    gVisConFig = ConMat.VisConFig;
    
    if isfield(ConMat,'VisConSurf')
        gVisConSurf = ConMat.VisConSurf;
    else
        gVisConSurf.LSurfData = [];
        gVisConSurf.RSurfData = [];
        gVisConSurf.LSurfColor = [0.7 0.7 0.7];
        gVisConSurf.RSurfColor = [0.7 0.7 0.7];
        gVisConSurf.LSurfAlpha = 0.2;
        gVisConSurf.RSurfAlpha = 0.2;
    end
    %Preprocess
    gVisConFig.NodeSelected = [];
    gVisConFig.hNodes = zeros(gVisConFig.NodeNum,1)*NaN;
    gVisConFig.hNodeMarkers = zeros(gVisConFig.NodeNum,1)*NaN;
    gVisConFig.hEdges = zeros(gVisConFig.NodeNum)*NaN;
    gVisConFig.hEdgeCbar = NaN;
    NodeShowed = gVisConNet(gVisConFig.CurSubj).NodeShowed;
    gVisConNet(gVisConFig.CurSubj).NodeShowed = false(1,gVisConFig.NodeNum);
    EdgeShowed = gVisConFig.EdgeShowed;
    gVisConFig.EdgeShowed = false(gVisConFig.NodeNum);
    %Create Figure
    VisCon_FigOper();
    VisCon_Axes();
    %Draw Network
    ShowNodes(find(NodeShowed));
    [r, c] = find(EdgeShowed);
    ConnectTwoNodes([r c]);
    set(findobj('Tag','VisConFig'), 'Name', ['VisualConnectome - ' gVisConFig.FilePath gVisConFig.FileName]);
else
    %ConMat & PosMat input
    nSub = size(ConMat, 3);
    if(size(PosMat, 3) ~= nSub && size(PosMat, 3) ~= 1)
        error('Number of position matrix should be %d or 1!', nSub);
    elseif size(PosMat, 3) == 1
        PosMat = repmat(PosMat, [1,1,nSub]);
    end 
    gVisConNet = struct;
    Defaults={'sphere',...      %Default Node Style
            2,...                   %Default Node Size
            'y',...                 %Default Node Color
            '',...                  %Default Node Name
            1.5,...                 %Default Edge Width
            [],...                  %Default Left Surface Data
            [],...                  %Default Right Surface Data
            [0.7 0.7 0.7],...       %Default Left Surface Color
            [0.7 0.7 0.7],...       %Default Right Surface Color
            0.2,...                 %Default Left Surface Alpha
            0.2};                   %Default Right Surface Alpha
        %Obtain input arguments
        [NodeStyle,...
            NodeSize,...
            NodeColor,...
            NodeName,...
            EdgeWidth,...
            gVisConSurf.LSurfData,...
            gVisConSurf.RSurfData,...
            gVisConSurf.LSurfColor,...
            gVisConSurf.RSurfColor,...
            gVisConSurf.LSurfAlpha,...
            gVisConSurf.RSurfAlpha] = VisCon_GetArgs(ParaNames,Defaults,varargin{:});
    for iSub = 1:nSub
        gVisConNet(iSub,1).ConMat = ConMat(:,:,iSub);
        gVisConNet(iSub,1).PosMat = PosMat(:,:,iSub);
        gVisConNet(iSub,1).NodeStyle = NodeStyle;
        gVisConNet(iSub,1).NodeSize = NodeSize;
        gVisConNet(iSub,1).NodeColor = NodeColor;
        gVisConNet(iSub,1).NodeName = NodeName;
        gVisConNet(iSub,1).EdgeWidth = EdgeWidth;
    end
    %Preprocess
    VisCon_Preproc();
    %Create Figure
    VisCon_FigOper();
    VisCon_Axes();
    %Draw Network
    ShowNodes all;
end
SetEdgeCmap(gVisConFig.DftCmap);
VisCon_SetSaveState();
gVisConState = 'Loaded';

AxesIndicator on;
InfoBox on;
EdgeColorbar on;
BrainSurf off;
VisCon_SetEnable(...
    'VisConTbarAxesInd','on',...
    'VisConTbarEdgeCbar','on',...
    'VisConTbarInfoBox','on',...
    'VisConTbarEdgeThres','on',...
    'VisConMenuSaveAs','on',...
    'VisConMenuExport','on',...
    'VisConMenuTools','on',...
    'VisConMenuSurface','on',...
    'VisConMenuAnalyze','on',...
    'VisConMenuAddNewSubjNet','on',...
    'VisConMenuNodeOper','on',...
    'VisConMenuEdgeOper','on',...
    'VisConMenuEdgeThres','on',...
    'VisConMenuConMatViewer','on',...
    'VisConMenuImportNets','off');
if length(gVisConNet) > 1
    VisCon_SetEnable('VisConMenuSubjPicker', 'on',...
        'VisConTbarSubjPicker', 'on');
end
if gVisConFig.SaveState == 1
    VisCon_SetEnable('VisConMenuSave','on',...
        'VisConTbarSave','on');
end
if ~isempty(gVisConSurf.LSurfData)
    VisCon_SetEnable('VisConTbarSurfVis','on',...
        'VisConMenuLSurfVis','on');
end
if ~isempty(gVisConSurf.RSurfData)
    VisCon_SetEnable('VisConTbarSurfVis','on',...
        'VisConMenuRSurfVis','on');
end
if ~isempty(gVisConSurf.LSurfData) && ~isempty(gVisConSurf.RSurfData)
    VisCon_SetEnable('VisConMenuBothSurfVis','on');
end
gVisConState = 'Finish';
end

