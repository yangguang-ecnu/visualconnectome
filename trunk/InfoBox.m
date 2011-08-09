%NODEINFORMBOX Summary of this function goes here
%   Detailed explanation goes here
function InfoBox(Sw)
global gVisConFig;
if nargin == 0,   Sw = 'on';    end
hFig = findobj('Tag','VisConFig');
hAxes = findobj('Tag','VisConAxes');
hInfoBox = findobj('Tag', 'VisConInfoBox');
hMenuInfoBox = findobj(hFig,'Tag','VisConMenuInfoBox');
hTbarInfoBox = findobj(hFig,'Tag','VisConTbarInfoBox');
if isempty(hFig)
    error('VisualConnectome is not running');
else
    set(0, 'CurrentFigure', hFig);
end
if isempty(hAxes)
    error('You must first create or open a VCT file!');
end
if strcmpi(Sw, 'on') || strcmpi(Sw, 'show')
    %delete information box if it exists
    try
        delete(hInfoBox);  
    end
    FigPos = get(hFig, 'Position');
    hInfoBox = axes('Tag','VisConInfoBox','DrawMode','fast',...
        'Units','pixel','Position',[10 FigPos(4) - 8 1 1],...
        'HitTest','off');
    axis(hInfoBox, 'off');
    text(0, 0, '', 'Parent', hInfoBox, 'Tag', 'VisConInfoBoxText', 'FontSize',8,...
        'EdgeColor','w','Color','w','LineWidth',1.5,'HitTest','off',...
        'VerticalAlignment','top', 'Margin',5,...
        'Interpreter','tex');
    if isempty(gVisConFig.NodeSelected)
        VisCon_UpdateInfo([]);
    else
        VisCon_UpdateInfo(gVisConFig.NodeSelected(end));
    end
    set(hMenuInfoBox,'Checked','on');
    set(hTbarInfoBox,'State','on');
elseif strcmpi(Sw,'off') || strcmpi(Sw,'hide')
    try
        delete(hInfoBox);  
    end
    hInfoBox = NaN;
    set(hMenuInfoBox,'Checked','off');
    set(hTbarInfoBox,'State','off');
else
    error('Wrong input argument!');
end
set(hFig,'CurrentAxes',hAxes);
end

