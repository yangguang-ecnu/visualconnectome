%TSURFACE Summary of this function goes here
%   Detailed explanation goes here
function BrainSurf(Sw, Hemi)
global gVisConSurf;

if nargin < 1,    Sw = 'on';    end
if nargin < 2,    Hemi = 'both';    end

hFig = findobj('Tag','VisConFig');
hAxes = findobj(hFig,'Tag','VisConAxes');
hLSurf = findobj(hAxes,'Tag','VisConLSurf');
hRSurf = findobj(hAxes,'Tag','VisConRSurf');
hMenuLSurfVis = findobj(hFig,'Tag','VisConMenuLSurfVis');
hMenuRSurfVis = findobj(hFig,'Tag','VisConMenuRSurfVis');
hTbarSurfVis = findobj(hFig,'Tag','VisConTbarSurfVis');
hMenuBothSurfVis = findobj(hFig, 'Tag', 'VisConMenuBothSurfVis');
if isempty(hFig)
    error('VisualConnectome is not running');
else
    set(0,'CurrentFigure',hFig);
end
if isempty(hAxes)
    error('You must first create or open a VCT file!');
else
    set(hFig,'CurrentAxes',hAxes);
end

if strcmpi(Sw,'on') || strcmpi(Sw,'show')
    if strcmpi(Hemi,'both')
        ToggLSurf on;
        ToggRSurf on;
    elseif strcmpi(Hemi,'left')
        ToggLSurf on;
    elseif strcmpi(Hemi,'right')
        ToggRSurf on;
    else
        error('Wrong input argument!');
    end
elseif strcmpi(Sw,'off') || strcmpi(Sw,'hide')
    if strcmpi(Hemi,'both')
        ToggLSurf off;
        ToggRSurf off;
    elseif strcmpi(Hemi,'left')
        ToggLSurf off;
    elseif strcmpi(Hemi,'right')
        ToggRSurf off;
    else
        error('Wrong input argument!');
    end
else
    error('Wrong input argument!');
end
if strcmp(get(hMenuLSurfVis,'Checked'),'on') || strcmp(get(hMenuRSurfVis,'Checked'),'on')
    set(hTbarSurfVis,'State','on');
else
    set(hTbarSurfVis,'State','off');
end

if strcmp(get(hMenuLSurfVis,'Checked'),'on') && strcmp(get(hMenuRSurfVis,'Checked'),'on')
    set(hMenuBothSurfVis,'Checked','on');
else
    set(hMenuBothSurfVis,'Checked','off');
end

    %Toggle left surface function
    function ToggLSurf(Sw)      
        %Delete surface if it exists
        if ~isempty(hLSurf),    delete(hLSurf);     end
        %Create surface
        if strcmpi(Sw,'on')
            if isempty(gVisConSurf.LSurfData)
                disp('Warning: Missing left hemisphere surface data!');
                return;
            end
            patch(gVisConSurf.LSurfData,'Tag','VisConLSurf',...
                'EdgeColor','none','FaceColor',gVisConSurf.LSurfColor,...
                'FaceLighting','gouraud','AmbientStrength',0.5,...
                'FaceAlpha',gVisConSurf.LSurfAlpha,'Clipping','off',...
                'HitTest','off');
            set(hMenuLSurfVis,'Checked','on');
        elseif strcmpi(Sw,'off')
            set(hMenuLSurfVis,'Checked','off');
        end
    end
    %Toggle right surface function
    function ToggRSurf(Sw)
        %Delete surface if it exists
        if ~isempty(hRSurf),    delete(hRSurf);     end
        %Create surface
        if strcmpi(Sw,'on')
            if isempty(gVisConSurf.RSurfData)
                disp('Warning: Missing right hemisphere surface data!');
                return;
            end
            patch(gVisConSurf.RSurfData,'Tag','VisConRSurf',...
                'EdgeColor','none','FaceColor',gVisConSurf.RSurfColor,...
                'FaceLighting','gouraud','AmbientStrength',0.5,...
                'FaceAlpha',gVisConSurf.RSurfAlpha,'Clipping','off',...
                'HitTest','off');
            set(hMenuRSurfVis,'Checked','on');
        elseif strcmpi(Sw,'off')
            set(hMenuRSurfVis,'Checked','off');
        end
    end
end




