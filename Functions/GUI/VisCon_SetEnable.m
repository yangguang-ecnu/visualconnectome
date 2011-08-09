function VisCon_SetEnable(varargin)
VarNum = length(varargin);
if mod(VarNum+1,2) == 0
    error('The number of arguments must be even!');
end
hFig = findobj('Tag','VisConFig');
for i = 1:2:VarNum
    ObjTag = varargin{i};
    Enable = varargin{i+1};
    assert(strcmpi(Enable,'on')|strcmpi(Enable,'off'),...
        'Wrong input arguments!');
    hObj = findobj(hFig,'Tag',ObjTag);
    if ~isempty(hObj)
        set(hObj,'Enable',Enable);
    end
end

