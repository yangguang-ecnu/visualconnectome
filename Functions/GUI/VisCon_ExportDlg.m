function VisCon_ExportDlg()
global gVisConFig;
global gVisConNet;

hFig = findobj('Tag','VisConFig');
hAxesInd = findobj(hFig, 'Tag', 'VisConAxesInd');
hInfoBox = findobj(hFig, 'Tag', 'VisConInfoBox');
FigPos = get(hFig,'Position');
DlgPos = [FigPos([1 2])+FigPos([3 4])/2-[200 0], 340, 190];
TempImg = [];
ScreenDpi = get(0,'ScreenPixelsPerInch');
DpiFactor = 1;
DpiFactorOld = 1;
UpSampling = 1;
UpSamplingOld = 1;
AxesIndStateOld = ~isempty(hAxesInd);
InfoBoxStateOld = ~isempty(hInfoBox);
CbarStateOld = ishandle(gVisConFig.hEdgeCbar);
%EdgeWidthOld = gVisConNet(gVisConFig.CurSubj).EdgeWidth;
if isempty(which('imresize.m'))
    SmoothEnable = 'off';
else
    SmoothEnable = 'on';
end

hExportDlg = dialog('Name', 'Export ...',...
    'Units','Pixel','Position',DlgPos);

uicontrol(...
    'Parent',hExportDlg,...
    'FontWeight','bold',...
    'Position',[15 160 198 16],...
    'String','Export Image Size (Max 3000 pixels)',...
    'Style','text');

uicontrol(...
    'Parent',hExportDlg,...
    'Callback',@ExprotDlgOK,...
    'Position',[105 10 60 22],...
    'String','OK');
    function ExprotDlgOK(Src,Evnt)
        if isempty(TempImg) || DpiFactor ~= DpiFactorOld || UpSampling ~= UpSamplingOld
            if get(hHideCbarCheck, 'value') == 1 && CbarStateOld == 1
                EdgeColorbar off;
            end
            if get(hHideAxesIndCheck, 'value') == 1 && AxesIndStateOld == 1
                AxesIndicator off;
            end
            if get(hHideInfoBoxCheck, 'value') == 1 && InfoBoxStateOld == 1
                InfoBox off;
            end
            %print figrue
            try
                print('temp_img.png', ['-f' num2str(hFig)], ['-r' num2str(round(ScreenDpi * DpiFactor * UpSampling))], '-dpng');
            catch Error
                if strcmpi(Error.identifier, 'MATLAB:nomem')
                    errordlg(sprintf('Not enough memory for print image!\nSet image size or smooth level smaller!'),...
                        'Export ...');
                end
                assignin('base', 'VisConError', Error);
                if get(hHideCbarCheck, 'value') == 1 && CbarStateOld == 1
                    EdgeColorbar on;
                end
                if get(hHideAxesIndCheck, 'value') == 1 && AxesIndStateOld == 1
                    AxesIndicator on;
                end
                if get(hHideInfoBoxCheck, 'value') == 1 && InfoBoxStateOld == 1
                    InfoBox on;
                end
                return;
            end
            if get(hHideCbarCheck, 'value') == 1 && CbarStateOld == 1
                EdgeColorbar on;
            end
            if get(hHideAxesIndCheck, 'value') == 1 && AxesIndStateOld == 1
                AxesIndicator on;
            end
            if get(hHideInfoBoxCheck, 'value') == 1 && InfoBoxStateOld == 1
                InfoBox on;
            end
            %resize figure
            TempImg = imread('temp_img.png');
            if get(hSmoothCheck, 'value') == 1 && UpSampling > 1.05
                TempImg = imresize(TempImg, 1 / UpSampling);
            end
            DpiFactor = DpiFactorOld;
            UpSampling = UpSamplingOld;
            delete('temp_img.png');
            %Save figure
            SaveImgFile();           
        else
            SaveImgFile();
        end 
    end

    function SaveImgFile()
        [File,Path,Type] = uiputfile(...
            {'*.png','PNG Image (*.png)';...
            '*.jpg','JPEG Image (*.jpg)';...
            '*.bmp','Bitmap File (*.bmp)';...
            '*.tif','TIFF Image (*.tif)';},...
            'Export ...','Untitled');
        if ~isequal(File,0) && ~isequal(Path,0) && ~isequal(Type,0)
            try
                switch Type
                    case 1
                        imwrite(TempImg, fullfile(Path, File), 'png');
                    case 2
                        imwrite(TempImg, fullfile(Path, File), 'jpg');
                    case 3
                        imwrite(TempImg, fullfile(Path, File), 'bmp');
                    case 4
                        imwrite(TempImg, fullfile(Path, File), 'tif');
                end
                delete(hExportDlg);
            catch Error
                errordlg('Error occurred while exporting image file!',...
                    'VisualConnectome');
                assignin('base', 'VisConError', Error);
                throw(Error);
            end
        end
    end

uicontrol(...
    'Parent',hExportDlg,...
    'Callback',@ExportDlgCancel,...
    'Position',[175 10 60 22],...
    'String','Cancel');
    function ExportDlgCancel(Src, Evnt)
        delete(hExportDlg);
    end
%Image Width Edit
hImgWidthEdit = uicontrol(...
    'Parent',hExportDlg,...
    'BackgroundColor',[1 1 1],...
    'Callback',@ExportDlgWidthEdit,...
    'Position',[68 130 40 18],...
    'String',num2str(FigPos(3)),...
    'Style','edit');
    function ExportDlgWidthEdit(Src, Evnt)
        ImgWidth = round(str2double(get(Src, 'String')));
        if ImgWidth > 3000 && FigPos(3) >= FigPos(4)
            ImgWidth = 3000;
            set(Src, 'String', num2str(ImgWidth));
        end
        DpiFactor = ImgWidth / FigPos(3);
        set(hImgHeightEdit, 'String', num2str(DpiFactor * FigPos(4)));
    end
%Image Height Edit
hImgHeightEdit = uicontrol(...
    'Parent',hExportDlg,...
    'BackgroundColor',[1 1 1],...
    'Callback',@ExportDlgHeightEdit,...
    'Position',[68 105 40 18],...
    'String', num2str(FigPos(4)),...
    'Style','edit');
    function ExportDlgHeightEdit(Src, Evnt)
        ImgHeight = round(str2double(get(Src, 'String')));
        if ImgHeight > 3000 && FigPos(3) <= FigPos(4)
            ImgHeight = 3000;
            set(Src, 'String', num2str(ImgHeight));
        end
        DpiFactor = ImgHeight / FigPos(4);
        set(hImgWidthEdit, 'String', num2str(DpiFactor * FigPos(3)));
    end

hHideCbarCheck = uicontrol(...
    'Parent',hExportDlg,...
    'Position',[180 140 91 16],...
    'String','Hide Colorbar',...
    'Style','checkbox',...
    'Min',0, 'Max',1, 'Value', ~CbarStateOld);

hHideInfoBoxCheck = uicontrol(...
    'Parent',hExportDlg,...
    'Position',[180 120 91 16],...
    'String','Hide Info. Box',...
    'Style','checkbox',...
    'Min',0, 'Max',1, 'Value', ~InfoBoxStateOld);

hHideAxesIndCheck = uicontrol(...
    'Parent',hExportDlg,...
    'Position',[180 100 124 16],...
    'String','Hide Axes Indicator',...
    'Style','checkbox',...
    'Min',0, 'Max',1, 'Value',~AxesIndStateOld);

uicontrol(...
    'Parent',hExportDlg,...
    'Position',[109 131 35 16],...
    'String','pixels',...
    'Style','text');

uicontrol(...
    'Parent',hExportDlg,...
    'Position',[109 106 35 16],...
    'String','pixels',...
    'Style','text');

uicontrol(...
    'Parent',hExportDlg,...
    'Position',[28 106 40 16],...
    'String','Height:',...
    'Style','text');

uicontrol(...
    'Parent',hExportDlg,...
    'Position',[28 131 40 16],...
    'String','Width:',...
    'Style','text');

uicontrol(...
    'Parent',hExportDlg,...
    'Position',[30 43 40 16],...
    'String','Level:',...
    'Style','text');

hPreviewBtn = uicontrol(...
    'Parent',hExportDlg,...
    'Callback',@PreviewBtnFcn,...
    'Position',[265 41 60 22],...
    'String','Preview',...
    'Enable','off');
    function PreviewBtnFcn(Src, Evnt)
        if isempty(TempImg) || DpiFactor ~= DpiFactorOld || UpSampling ~= UpSamplingOld
            if get(hHideCbarCheck, 'value') == 1 && CbarStateOld == 1
                EdgeColorbar off;
            end
            if get(hHideAxesIndCheck, 'value') == 1 && AxesIndStateOld == 1
                AxesIndicator off;
            end
            if get(hHideInfoBoxCheck, 'value') == 1 && InfoBoxStateOld == 1
                InfoBox off;
            end
            %print figrue
            try
                print('temp_img.png', ['-f' num2str(hFig)], ['-r' num2str(round(ScreenDpi * DpiFactor * UpSampling))], '-dpng');
            catch Error
                if strcmpi(Error.identifier, 'MATLAB:nomem')
                    errordlg(sprintf('Not enough memory for print image!\nSet image size or smooth level smaller!'),...
                        'Export ...');
                end
                assignin('base', 'VisConError', Error);
                if get(hHideCbarCheck, 'value') == 1 && CbarStateOld == 1
                    EdgeColorbar on;
                end
                if get(hHideAxesIndCheck, 'value') == 1 && AxesIndStateOld == 1
                    AxesIndicator on;
                end
                if get(hHideInfoBoxCheck, 'value') == 1 && InfoBoxStateOld == 1
                    InfoBox on;
                end
                return;
            end
            if get(hHideCbarCheck, 'value') == 1 && CbarStateOld == 1
                EdgeColorbar on;
            end
            if get(hHideAxesIndCheck, 'value') == 1 && AxesIndStateOld == 1
                AxesIndicator on;
            end
            if get(hHideInfoBoxCheck, 'value') == 1 && InfoBoxStateOld == 1
                InfoBox on;
            end
            %resize figure
            TempImg = imread('temp_img.png');
            TempImg = imresize(TempImg, 1 / UpSampling);
            %display figure
            hPreview = findobj('Tag', 'VisConPreview');
            if(~isempty(hPreview))
                delete(hPreview)
            end
            hPreview = figure('Name','VisualConnectome - Export Image Preview','NumberTitle','off',...
                'Tag','VisConPreview','MenuBar','none','ToolBar','none',...
                'Units','pixel','Position',FigPos);
            imshow(TempImg,'Border','tight');
            DpiFactorOld = DpiFactor;
            UpSamplingOld = UpSampling;
            %delete('temp_img.png');
        else
            hPreview = findobj('Tag', 'VisConPreview');
            if(~isempty(hPreview))
                figure(hPreview);
            else
                hPreview = figure('Name','VisualConnectome - Export Image Preview','NumberTitle','off',...
                    'Tag','VisConPreview','Color','k','MenuBar','none','ToolBar','none',...
                    'Resize','off','Units','pixel','Position',FigPos);
                imshow(TempImg,'Border','tight','InitialMagnification',100);
            end
        end 
    end

hSmoothCheck = uicontrol(...
    'Parent',hExportDlg,...
    'Callback',@SmoothCheckFcn,...
    'Enable', SmoothEnable,...
    'FontWeight','bold',...
    'Position',[15 70 324 20],...
    'Min',0, 'Max',1, 'Value', 0,...
    'String','Smooth Image (Require Image Processing Toolbox)',...
    'Style','checkbox');
    function SmoothCheckFcn(Src, Evnt)
        if get(Src, 'Value')
            set(hSmoothLevelEdit, 'Enable', 'on');
            set(hSmoothLevelSlider, 'Enable', 'on');
            set(hPreviewBtn, 'Enable', 'on');
            UpSampling = get(hSmoothLevelSlider,'Value');
        else
            set(hSmoothLevelEdit, 'Enable', 'off');
            set(hSmoothLevelSlider, 'Enable', 'off');
            set(hPreviewBtn, 'Enable', 'off');
            UpSampling = 1;
        end
    end

hSmoothLevelEdit = uicontrol(...
    'Parent',hExportDlg,...
    'BackgroundColor',[1 1 1],...
    'Callback',@SmoothLevelEditFcn,...
    'Position',[66 43 30 18],...
    'String','4.0',...
    'Style','edit',...
    'Enable', 'off');
    function SmoothLevelEditFcn(Src, Evnt)
        UpSampling = str2double(get(Src, 'String'));
        if UpSampling > 8
            UpSampling = 8;
        elseif UpSampling < 1;
            UpSampling = 1;
        end
        set(Src, 'String', num2str(UpSampling, '%.1f'));
        set(hSmoothLevelSlider, 'Value', UpSampling);
    end

hSmoothLevelSlider = uicontrol(...
    'Parent',hExportDlg,...
    'Callback',@SmoothLevelSliderFcn,...
    'Position',[99 44 160 16],...
    'String','Smoothing Level',...
    'Style','slider',...
    'Min', 1, 'Max', 8, 'value', 4,...
    'SliderStep',[0.1/7 1/7],...
    'Enable', 'off');
    function SmoothLevelSliderFcn(Src, Evnt)
        UpSampling = get(Src, 'Value');
        UpSampling = round(UpSampling * 10) / 10;
        set(Src, 'Value', UpSampling);
        set(hSmoothLevelEdit, 'String', num2str(UpSampling, '%.1f'));
    end
end
