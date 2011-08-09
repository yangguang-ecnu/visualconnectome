function SubjPicker(Sw)
global gVisConFig;

if nargin == 0,   Sw = 'on';    end

hFig = findobj('Tag','VisConFig');
hAxes = findobj(hFig,'Tag','VisConAxes');
hSubjSelPanel = findobj(hFig, 'Tag','SubjSelPanel');
hMenuSubjPicker = findobj(hFig,'Tag','VisConMenuSubjPicker');
hTbarSubjPicker = findobj(hFig,'Tag','VisConTbarSubjPicker');
if isempty(hFig)
    error('VisualConnectome is not running');
else
    set(0,'CurrentFigure',hFig);
end
if isempty(hAxes)
    error('You must first create or open a VCT file!');
end

if strcmpi(Sw,'on') || strcmpi(Sw,'show');
    if ~isempty(hSubjSelPanel)
        delete(hSubjSelPanel);
    end
    VisCon_SelSubjPanel();
    set(hMenuSubjPicker,'Checked','on');
    set(hTbarSubjPicker,'State','on');
elseif strcmpi(Sw,'off') || strcmpi(Sw,'hide')
    if ~isempty(hSubjSelPanel)
        delete(hSubjSelPanel);
    end
    set(hMenuSubjPicker,'Checked','off');
    set(hTbarSubjPicker,'State','off');
else
    error('Wrong input argument!');
end
set(hFig,'CurrentAxes',hAxes);
end