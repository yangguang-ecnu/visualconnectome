%SAVEVISCONDATA Summary of this function goes here
%   Detailed explanation goes here
function SaveVisConFile(File)
global gVisConFig;
global gVisConNet;
global gVisConSurf;
hFig = findobj('Tag','VisConFig');
hAxes = findobj('Tag','VisConAxes');
if isempty(hFig)
    error('VisualConnectome is not running');
else
    set(0,'CurrentFigure',hFig);
end
if isempty(hAxes)
    error('You must first create or open a VCT file!');
end
if nargin>0
    if ~ischar(File)
        error('File path should be a string!');
    end
    [Path,FileName,Ext] = fileparts(File);
    if Path(end) ~= filesep
        Path(end+1) = filesep;
    end
    if ~isempty(Path) && ~isdir(Path)
        error('Directory not found!');
    end
    if isempty(FileName)
        FileName = 'Untitled';
    end
    if ~strcmpi(Ext,'.vct')
        FileName = [FileName Ext];
    end
    Ext = '.VCT';
    gVisConFig.FileName = [FileName Ext];
    gVisConFig.FilePath = Path;
    VisCon_SetSaveState('Saved');
   
    VisConNet = gVisConNet;
    VisConSurf = gVisConSurf;
    VisConFig = gVisConFig;
    save(fullfile(Path, [FileName Ext]), 'VisConFig', 'VisConNet', 'VisConSurf');
    set(hFig, 'Name', ['VisualConnectome - ' gVisConFig.FilePath gVisConFig.FileName]);
else
    error('Please enter file location!');
end
end

