%VISCON_SAVEDLG Summary of this function goes here
%   Detailed explanation goes here
function VisCon_SaveDlg()
[File,Path,Type]=uiputfile(...
    {'*.VCT','VisualConnectome File (*.VCT)';...
    '*.bmp','Bitmap File (*.bmp)';...
    '*.jpg','JPEG Image (*.jpg)';...
    '*.png','PNG Image (*.png)';...
    '*.tif','TIFF Image (*.tif)';...
    '*.fig','Matlab Figure (*.fig)';},...
    'Save As...','Untitled');
if ~isequal(File,0) && ~isequal(Path,0) && ~isequal(Type,0)
    try
        switch Type
            case 1
                SaveVisConFile(fullfile(Path,File));
            case 2
                print(fullfile(Path,File),'-dbmp','-r96');
            case 3
                print(fullfile(Path,File),'-djpeg','-r96');
            case 4
                print(fullfile(Path,File),'-dpng','-r96');
            case 5
                print(fullfile(Path,File),'-dtiff','-r96');
            case 6
                saveas(fullfile(Path,File));
        end
    catch
        errordlg('Error occurred while saving file!',...
            'Save As');
    end
end
end

