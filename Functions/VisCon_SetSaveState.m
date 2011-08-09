function VisCon_SetSaveState( State )
global gVisConFig;
hFig = findobj('Tag', 'VisConFig');
hVisConTbarSave = findobj(hFig, 'Tag', 'VisConTbarSave');
hVisConMenuSave = findobj(hFig, 'Tag', 'VisConMenuSave');
VisConFigName = get(hFig, 'Name');

if nargin == 0
    if gVisConFig.SaveState == 1 && VisConFigName(end) ~= '*'
        VisConFigName(end + 1) = '*';
        set(hFig, 'Name', VisConFigName);
        set(hVisConTbarSave, 'Enable', 'on');
        set(hVisConMenuSave, 'Enable', 'on');
    elseif gVisConFig.SaveState == 0 && VisConFigName(end) == '*'
        VisConFigName = VisConFigName(1:end-1);
        set(hFig, 'Name', VisConFigName);
        set(hVisConTbarSave, 'Enable', 'off');
        set(hVisConMenuSave, 'Enable', 'off');
    end
else
    if strcmpi(State, 'Unsaved')
        gVisConFig.SaveState = 1;
        if  VisConFigName(end) ~= '*'
            VisConFigName(end + 1) = '*';
            set(hFig, 'Name', VisConFigName);
            set(hVisConTbarSave, 'Enable', 'on');
            set(hVisConMenuSave, 'Enable', 'on');
        end
    elseif strcmpi(State, 'Saved')
        gVisConFig.SaveState = 0;
        if  VisConFigName(end) == '*'
            VisConFigName = VisConFigName(1:end-1);
            set(hFig, 'Name', VisConFigName);
            set(hVisConTbarSave, 'Enable', 'off');
            set(hVisConMenuSave, 'Enable', 'off');
        end
    else
        error('Error input argument!');
    end
end
end

