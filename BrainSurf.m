%TSURFACE Summary of this function goes here
%   Detailed explanation goes here
function BrainSurf(Sw)
global gSurface;
hFig=findobj('Tag','VisConFig');
hAxes=findobj(hFig,'Tag','VisConAxes');
hLSurf=findobj(hAxes,'Tag','VisConLSurf');
hRSurf=findobj(hAxes,'Tag','VisConRSurf');
set(hFig,'CurrentAxes',hAxes);

if strcmpi(Sw,'both') || strcmpi(Sw,'on')
    ToggleLSurf();
    ToggleRSurf();
elseif strcmpi(Sw,'left')
    ToggleLSurf();
    if ~isempty(hRSurf),    delete(hRSurf);     end
elseif strcmpi(Sw,'right')
    if ~isempty(hLSurf),    delete(hLSurf);     end
    ToggleRSurf();   
elseif strcmpi(Sw,'none') || strcmpi(Sw,'off')
    if ~isempty(hLSurf),    delete(hLSurf);     end
    if ~isempty(hRSurf),    delete(hRSurf);     end
else
    error('Wrong input argument!');
end
    %Toggle left surface function
    function ToggleLSurf()
        if isempty(gSurface.LSurfData)
            warning('VisCon:BrainSurf','Missing surface dataset');
            return;
        end
        %Delete surface if it exists
        if ~isempty(hLSurf),    delete(hLSurf);     end
        %Create surface
        patch(gSurface.LSurfData,'Tag','VisConLSurf',...
            'EdgeColor','none','FaceColor',gSurface.LSurfColor,...
            'FaceLighting','gouraud','AmbientStrength',0.5,...
            'FaceAlpha',gSurface.LSurfAlpha,'Clipping','off','HitTest','off');
    end
    %Toggle right surface function
    function ToggleRSurf()
        if isempty(gSurface.RSurfData)
            warning('VisCon:BrainSurf','Missing surface dataset');
            return;
        end
        %Delete surface if it exists
        if ~isempty(hRSurf),    delete(hRSurf);     end
        %Create surface
        patch(gSurface.RSurfData,'Tag','VisConLSurf',...
            'EdgeColor','none','FaceColor',gSurface.RSurfColor,...
            'FaceLighting','gouraud','AmbientStrength',0.5,...
            'FaceAlpha',gSurface.RSurfAlpha,'Clipping','off','HitTest','off');
    end
end




