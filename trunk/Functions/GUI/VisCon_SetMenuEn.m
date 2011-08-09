function VisCon_SetMenuEn(varargin)
VarNum=length(varargin);
if mod(VarNum+1,2)==0
    error('The number of arguments must be even!');
end
hFig=findobj('Tag','VisConFig');
for i=1:2:VarNum
    MenuTag=varargin{i};
    Enable=varargin{i+1};
    assert(strcmpi(Enable,'on')|strcmpi(Enable,'off'),...
        'Wrong input arguments!');
    hMenu=findobj(hFig,'Tag',MenuTag);
    if ~isempty(hMenu)
        set(hMenu,'Enable',Enable);
    end
end

