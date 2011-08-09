%VISCON_FIGURE Summary of this function goes here
%   Detailed explanation goes here
function VisCon_Figure()
global gFigAxes;
ScrSize=get(0,'ScreenSize');
FigPos=[ScrSize(1,[3,4])/2-[320,240],640,480];
figure('Name','VisualConnectome','NumberTitle','off',...
    'Tag','VisConFig','Color','k','MenuBar','none','ToolBar','none',...
    'DeleteFcn','clear global gFigAxes gNetwork gSurface;',...
    'Renderer','OpenGL','InvertHardcopy','off','BusyAction','cancel',...
    'PaperPositionMode','auto',...
    'Units','pixel','Position',FigPos);
Icons=load(fullfile(gFigAxes.VisConPath,'Resources','Icons.dat'),'-mat');
Cmaps=load(fullfile(gFigAxes.VisConPath,'Resources','Cmaps.dat'),'-mat');
gFigAxes.TbarIcons=Icons.TbarIcons;
gFigAxes.PointerIcons=Icons.PointerIcons;
gFigAxes.DltCmap=Cmaps.DftCmap;
VisCon_Menu();
VisCon_Toolbar();
end

