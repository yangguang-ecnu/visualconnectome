%VISCON_SETTOOLBARBUTTON Summary of this function goes here
%   Detailed explanation goes here
function VisCon_SetButtonEn(varargin)
VarNum=length(varargin);
if mod(VarNum+1,2)==0
    error('The number of arguments must be even!');
end
hFig=findobj('Tag','VisConFig');
for i=1:2:VarNum
    ButtonTag=varargin{i};
    Enable=varargin{i+1};
    assert(strcmpi(Enable,'on')|strcmpi(Enable,'off'),...
        'Wrong input arguments!');
    hButton=findobj(hFig,'Tag',ButtonTag);
    if ~isempty(hButton)
        set(hButton,'Enable',Enable);
    end
end
end

