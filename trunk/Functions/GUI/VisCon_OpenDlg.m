%VISCON_OPENDLG Summary of this function goes here
%   Detailed explanation goes here
function VisCon_OpenDlg()
[File,Path,Type]=uigetfile({'*.VCT','VisualConnectome File (*.VCT)'},...
    'Open VisualConnectome File');
if Type==1
    try
        LoadVisConFile(fullfile(Path,File),'on');
    catch
        errordlg('Loading failed.Invalid or damaged file!',...
            'Open VisualConnectome File');
    end
end
end

