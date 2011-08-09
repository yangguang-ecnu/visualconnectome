%VISCON_SETTOOLBARBUTTON Summary of this function goes here
%   Detailed explanation goes here
function VisCon_SetButtonEn(varargin)
global gSurface;

if nargin<1,    State='on';     end
if strcmpi(State,'on')
    set(gHandle.UiPushSave,'Enable','on');
    set(gHandle.UiToggAxesInd,'Enable','on');
    set(gHandle.UiToggEdgeCbar,'Enable','on');
    set(gHandle.UiToggInformBox,'Enable','on');
    set(gHandle.UiPushAbsThres,'Enable','on');
    set(gHandle.UiPushPropThres,'Enable','on');
    if ~isempty(gSurface.LSurfData) || ~isempty(gSurface.RSurfData)
        set(gHandle.UiToggSurf,'Enable','on');
    end
elseif strcmpi(State,'off')
    set(gHandle.UiPushSave,'Enable','off');
    set(gHandle.UiToggSurf,'Enable','off');
    set(gHandle.UiToggAxesInd,'Enable','off');
    set(gHandle.UiToggCbar,'Enable','off');
    set(gHandle.UiToggInformBox,'Enable','off');
    set(gHandle.UiPushAbsThres,'Enable','off');
    set(gHandle.UiPushPropThres,'Enable','off');
end
end

