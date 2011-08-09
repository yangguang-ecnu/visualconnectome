%VISCON_SAVEDLG Summary of this function goes here
%   Detailed explanation goes here
function VisCon_SaveDlg()
[File,Path,Type]=uiputfile({'*.VCT','VisualConnectome File (*.VCT)';...
    '*.bmp','Bitmap File (*.bmp)';'*.jpg','JPEG Image (*.jpg)';...
    '*.png','PNG Image (*.png)';'*.fig','Matlab Figure (*.fig)'},...
    'Save As...','Untitled');
if ~isequal(File,0) && ~isequal(Path,0) && ~isequal(Type,0)
    try
        switch Type
            case 1
                SaveVisConFile(fullfile(Path,File));
            case 2
                print(fullfile(Path,File),'-dbmp');
            case 3
                print(fullfile(Path,File),'-djpeg');
            case 4
                print(fullfile(Path,File),'-dpng');
            case 5
                saveas(fullfile(Path,File));
        end
    catch
        errordlg('Error occurred while saving file!',...
            'Save As');
    end
end
end

