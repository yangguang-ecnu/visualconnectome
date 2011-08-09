%NODEINFORMBOX Summary of this function goes here
%   Detailed explanation goes here
function InformationBox(Sw)
global gFigAxes;
if nargin==0,   Sw='on';    end
hFig=findobj('Tag','VisConFig');
hAxes=findobj('Tag','VisConAxes');
hMenuInformBox=findobj(hFig,'Tag','VisConMenuInformBox');
hTbarInformBox=findobj(hFig,'Tag','VisConTbarInformBox');
if isempty(hFig)
    error('VisualConnectome is not running');
else
    set(0,'CurrentFigure',hFig);
end
if isempty(hAxes)
    error('You must first create or open a VCT file!');
end
if strcmpi(Sw,'on') || strcmpi(Sw,'show')
    %delete information box if it exists
    try
        delete(gFigAxes.hInformBox);  
    end
    FigPos=get(hFig,'Position');
    gFigAxes.hInformBox=annotation('textbox','FontSize',8,...
        'EdgeColor','w','Color','w','LineWidth',1.5,'HitTest','off',...
        'Units','pixel','Position',[3 FigPos(4)-102 142 100]);
    if isempty(gFigAxes.NodeSelected)
        VisCon_UpdateInform([]);
    else
        VisCon_UpdateInform(gFigAxes.NodeSelected(end));
    end
    set(hMenuInformBox,'Checked','on');
    set(hTbarInformBox,'State','on');
elseif strcmpi(Sw,'off') || strcmpi(Sw,'hide')
    try
        delete(gFigAxes.hInformBox);  
    end
    gFigAxes.hInformBox=NaN;
    set(hMenuInformBox,'Checked','off');
    set(hTbarInformBox,'State','off');
else
    error('Wrong input argument!');
end
end

