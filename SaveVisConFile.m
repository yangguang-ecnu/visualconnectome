%SAVEVISCONDATA Summary of this function goes here
%   Detailed explanation goes here
function SaveVisConFile(File)
global gNetwork;
global gSurface;
hFig=findobj('Tag','VisConFig');
if isempty(hFig)
    error('VisualConnecome is not running!');
end
if nargin>0
    if ~ischar(File)
        error('File path should be a string!');
    end
    [Path,FileName,Ext]=fileparts(File);
    if ~isempty(Path) && ~isdir(Path)
        error('Directory not found!');
    end
    if isempty(FileName)
        FileName='Untitled';
    end
    if ~strcmpi(Ext,'.vct')
        FileName=[FileName Ext];
    end
    Ext='.VCT';
    Network=gNetwork;
    Surface=gSurface;
    save(fullfile(Path,[FileName Ext]),'Network','Surface');
else
    error('Please enter file location!');
end
end

