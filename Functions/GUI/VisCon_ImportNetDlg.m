function VisCon_ImportNetDlg()

hFig = findobj('Tag','VisConFig');
FigPos = get(hFig,'Position');
DlgPos = [FigPos([1 2])+FigPos([3 4])/2-[240 100], 480, 320];

ConMat = [];
PosMat = [];
NodeStyle = 'sphere';
NodeColor = 'y';
NodeName = [];
NodeSize = 2;
GroupLabel = [];
EdgeWidth = 1.5;

hImportNetDlg = dialog('Name', 'Import Networks ...',...
    'Units','Pixel','Position',DlgPos);

hImportNetBtn = uicontrol(...
    'Parent',hImportNetDlg,...
    'Callback',@ImportNetBtnFcn,...
    'Position',[25 275 120 24],...
    'String','Import Connectivity');
    function ImportNetBtnFcn(Src, Evnt)
        [File,Path,Type] = uigetfile({'*.mat'},'Select Connectivity Matrix ...');
        if Type ~= 0
            FilePath = fullfile(Path, File);
            try
                VarInfo = whos('-file', FilePath);
            catch Error
                if strcmpi(Error.identifier, 'MATLAB:whos:notValidMatFile')
                    errordlg(sprintf('%s is not a valid Matlab file!', File),...
                        'Import Connecitivity');
                end
                return;
            end
            ConMat = [];
            for i = 1:length(VarInfo)
                ErrorNet = 0;
                if (length(VarInfo(i).size) == 2 || length(VarInfo(i).size) == 3) && VarInfo(i).size(1) == VarInfo(i).size(2)
                    ConMat1 = getfield(load(FilePath, VarInfo(i).name), VarInfo(i).name);
                    SubjNum = size(ConMat1, 3);
                    for iSub = 1:SubjNum
                        if ~isequal(ConMat1(:,:,iSub), ConMat1(:,:,iSub))
                            ErrorNet = 1;
                            break;
                        end
                    end
                    if ErrorNet == 0
                        ConMat = ConMat1;
                        break;
                    end
                end
            end
            if isempty(ConMat)
                errordlg(sprintf('Cannot find connectivity matirx in %s !', File),...
                    'Import Connecitivity');
            else
                set(hImportNodePosBtn,'Enable', 'on');
            end
        end
    end

hImportNodePosBtn = uicontrol(...
    'Parent',hImportNetDlg,...
    'Callback',@ImportPosBtnFcn,...
    'Enable','off',...
    'Position',[25 230 120 24],...
    'String','Import Nodes Position');
    function ImportPosBtnFcn(Src, Evnt)
        [File,Path,Type] = uigetfile({'*.mat'},'Select Node Postion Matrix ...');
        if Type ~= 0
            FilePath = fullfile(Path, File);
            try
                VarInfo = whos('-file', FilePath);
            catch Error
                if strcmpi(Error.identifier, 'MATLAB:whos:notValidMatFile')
                    errordlg(sprintf('%s is not a valid Matlab file!', File),...
                        'Import Node Position');
                end
                return;
            end
            PosMat = [];
            for i = 1:length(VarInfo)
                if (isequal(VarInfo(i).size, [size(ConMat, 1), 3]))...
                        || (isequal(VarInfo(i).size, [size(ConMat, 1), 3, size(ConMat, 3)]))
                    PosMat = getfield(load(FilePath, VarInfo(i).name), VarInfo(i).name);
                end
            end
            if isempty(PosMat)
                errordlg(sprintf('Cannot find node position matirx in %s !', File),...
                    'Import Node Position');
            else
                set(hImportGroupLabelBtn,'Enable', 'off');
                set(hImportNodeNameBtn,'Enable', 'on');
                set(hNodeStylePop,'Enable', 'on');
                set(hImportNodeStyleBtn,'Enable', 'on');
                set(hNodeSizeEdit,'Enable', 'on');
                set(hImportNodeSizeBtn,'Enable', 'on');
                set(hNodeColorPop,'Enable', 'on');
                set(hImportNodeColorBtn,'Enable', 'on');
                set(hEdgeWidthEdit,'Enable', 'on');
                set(hImportNetOK,'Enable', 'on');
            end
        end
    end

hImportGroupLabelBtn = uicontrol(...
    'Parent',hImportNetDlg,...
    'Callback',@ImportGroupLabelBtnFcn,...
    'Enable','off',...
    'Position',[95 185 50 24],...
    'String','Import');
    function ImportGroupLabelBtnFcn(Src, Evnt)
        
    end

hImportNodeNameBtn = uicontrol(...
    'Parent',hImportNetDlg,...
    'Callback',@ImportNodeNameBtnFcn,...
    'Enable','off',...
    'Position',[95 155 50 24],...
    'String','Import');
    function ImportNodeNameBtnFcn(Src, Evnt)
        [File,Path,Type] = uigetfile({'*.mat'},'Select Node Name Cell Array ...');
        if Type ~= 0
            FilePath = fullfile(Path, File);
            try
                VarInfo = whos('-file', FilePath);
            catch Error
                if strcmpi(Error.identifier, 'MATLAB:whos:notValidMatFile')
                    errordlg(sprintf('%s is not a valid Matlab file!', File),...
                        'Import Node Name');
                end
                return;
            end
            NodeName = [];
            for i = 1:length(VarInfo)
                if isequal(VarInfo(i).size, [size(ConMat, 1), 1]) && strcmpi(VarInfo(i).class, 'cell')
                    NodeName1 = getfield(load(FilePath, VarInfo(i).name), VarInfo(i).name);
                    if iscellstr(NodeName1)
                        NodeName = NodeName1;
                        break;
                    end
                end
            end
            if isempty(NodeName)
                errordlg(sprintf('Cannot find node name cell array in %s !', File),...
                    'Import Node Name');
            end
        end
    end

hNodeStylePop = uicontrol(...
    'Parent',hImportNetDlg,...
    'Callback',@NodeStylePopFcn,...
    'BackgroundColor',[1 1 1],...
    'Enable','off',...
    'Position',[95 126 70 23],...
    'String',{  'Sphere'; 'Cube' ;'Custom'; },...
    'Style','popupmenu',...
    'Value',1);
    function NodeStylePopFcn(Src, Evnt)
        if get(Src, 'Value') == 1
            NodeStyle = 'sphere';
        elseif get(Src, 'Value') == 2
            NodeStyle = 'cube';
        else
            ImportNodeStyleBtnFcn([],[]);
        end
    end

hImportNodeStyleBtn = uicontrol(...
    'Parent',hImportNetDlg,...
    'Callback',@ImportNodeStyleBtnFcn,...
    'Enable','off',...
    'Position',[175 125 50 24],...
    'String','Import');
    function ImportNodeStyleBtnFcn(Src, Evnt)
        [File,Path,Type] = uigetfile({'*.mat'},'Select Node Style Cell Array ...');
        if Type ~= 0
            FilePath = fullfile(Path, File);
            try
                VarInfo = whos('-file', FilePath);
            catch Error
                if strcmpi(Error.identifier, 'MATLAB:whos:notValidMatFile')
                    errordlg(sprintf('%s is not a valid Matlab file!', File),...
                        'Import Node Style');
                end
                return;
            end
            for i = 1:length(VarInfo)
                if isequal(VarInfo(i).size, [size(ConMat, 1), 1]) &&  strcmpi(VarInfo(i).class, 'cell')
                    NodeStyle1 = getfield(load(FilePath, VarInfo(i).name), VarInfo(i).name);
                    if iscellstr(NodeStyle1) && (length(unique(NodeStyle1)) == 1 || length(unique(NodeStyle1)) == 2)
                        NodeStyle = NodeStyle1;
                        set(hNodeStylePop, 'Value', 3);
                        break;
                    end
                end
            end
            if ischar(NodeStyle)
                errordlg(sprintf('Cannot find node style cell array in %s !', File),...
                    'Import Node Style');
            end
        else
            NodeStyle = 'sphere';
            set(hNodeStylePop, 'Value', 1);
        end
    end

hNodeSizeEdit = uicontrol(...
    'Parent',hImportNetDlg,...
    'Callback',@NodeSizeEditFcn,...
    'BackgroundColor',[1 1 1],...
    'Callback','',...
    'Enable','off',...
    'Position',[95 68 40 18],...
    'String','2',...
    'Style','edit');
    function NodeSizeEditFcn(Src, Evnt)
        if isempty(get(Src, 'String'))
            set(Src, num2str(2));
            NodeSize = 2;
        else
            NodeSize = str2double(get(Src, 'String'));
        end
    end

hImportNodeSizeBtn = uicontrol(...
    'Parent',hImportNetDlg,...
    'Callback',@ImportNodeSizeBtnFcn,...
    'Enable','off',...
    'Position',[145 65 50 24],...
    'String','Import');
    function ImportNodeSizeBtnFcn(Src, Evnt)
        [File,Path,Type] = uigetfile({'*.mat'},'Select Node Size Vector ...');
        if Type ~= 0
            FilePath = fullfile(Path, File);
            try
                VarInfo = whos('-file', FilePath);
            catch Error
                if strcmpi(Error.identifier, 'MATLAB:whos:notValidMatFile')
                    errordlg(sprintf('%s is not a valid Matlab file!', File),...
                        'Import Node Size');
                end
                return;
            end
            for i = 1:length(VarInfo)
                if isequal(VarInfo(i).size, [size(ConMat, 1), 1]) && strcmpi(VarInfo(i).class, 'double')
                    NodeSize = getfield(load(FilePath, VarInfo(i).name), VarInfo(i).name);
                    set(hNodeSizeEdit, 'String', 'Custom');
                    break;
                end
            end
            if ~isvector(NodeName)
                errordlg(sprintf('Cannot find node size vector in %s !', File),...
                    'Import Node Size');
            end
        end
    end

hNodeColorPop = uicontrol(...
    'Parent',hImportNetDlg,...
    'BackgroundColor',[1 1 1],...
    'Callback',@NodeColorPopFcn,...
    'Enable','off',...
    'Position',[96 96 70 23],...
    'String',{  'Yellow'; 'Magenta'; 'Cyan'; 'Red'; 'Green'; 'Blue'; 'Custom';},...
    'Style','popupmenu',...
    'Value',1);
    function NodeColorPopFcn(Src, Evnt)
        switch get(Src, 'Value')
            case 1
                NodeColor = 'y';
            case 2
                NodeColor = 'm';
            case 3
                NodeColor = 'c';
            case 4
                NodeColor = 'r';
            case 5
                NodeColor = 'g';
            case 6
                NodeColor = 'b';
            case 7 
                ImportNodeColorBtnFcn([],[]);
        end
    end

hImportNodeColorBtn = uicontrol(...
    'Parent',hImportNetDlg,...
    'Callback',@ImportNodeColorBtnFcn,...
    'Enable','off',...
    'Position',[175 95 50 24],...
    'String','Import');
    function ImportNodeColorBtnFcn(Src, Evnt)
               [File,Path,Type] = uigetfile({'*.mat'},'Select Node Color Matirx ...');
        if Type ~= 0
            FilePath = fullfile(Path, File);
            try
                VarInfo = whos('-file', FilePath);
            catch Error
                if strcmpi(Error.identifier, 'MATLAB:whos:notValidMatFile')
                    errordlg(sprintf('%s is not a valid Matlab file!', File),...
                        'Import Node Color');
                end
                return;
            end
            for i = 1:length(VarInfo)
                if (isequal(VarInfo(i).size, [size(ConMat, 1), 3]) && strcmpi(VarInfo(i).class, 'double')...\
                        || isequal(VarInfo(i).size, [size(ConMat, 1), 1]) && strcmpi(VarInfo(i).class, 'cell'))
                    NodeColor = getfield(load(FilePath, VarInfo(i).name), VarInfo(i).name);
                    set(hNodeColorPop, 'Value', 7);
                    break;
                end
            end
            if ischar(NodeColor)
                errordlg(sprintf('Cannot find node color cell array in %s !', File),...
                    'Import Node Color');
            end
        else
            NodeColor = 'y';
            set(hNodeColorPop, 'Value', 1);
        end
    end

hEdgeWidthEdit = uicontrol(...
    'Parent',hImportNetDlg,...
    'BackgroundColor',[1 1 1],...
    'Callback',@EdgeWidthEditFcn,...
    'Enable','off',...
    'Position',[95 38 40 18],...
    'String','1.5',...
    'Style','edit');
    function EdgeWidthEditFcn(Src, Evnt)
        if isempty(get(Src, 'String'))
            set(Src, num2str(1.5));
            EdgeWidth = 1.5;
        else
            EdgeWidth = str2double(get(Src, 'String'));
        end
    end

hImportNetOK = uicontrol(...
    'Parent',hImportNetDlg,...
    'Callback',@ImportNetOKFcn,...
    'Enable','off',...
    'Position',[175 10 60 24],...
    'String','OK');
    function ImportNetOKFcn(Src, Evnt)
        VisualConnectome(ConMat, PosMat, 'NodeStyle', NodeStyle, 'NodeSize', NodeSize,...
            'NodeColor', NodeColor, 'NodeName', NodeName, 'EdgeWidth', EdgeWidth);
        delete(hImportNetDlg);
    end

hImportNetCancel = uicontrol(...
    'Parent',hImportNetDlg,...
    'Callback',@ImportNetCancelFcn,...
    'Position',[245 10 60 24],...
    'String','Cancel');
    function ImportNetCancelFcn(Src, Evnt)
        delete(hImportNetDlg);
    end

uicontrol(...
    'Parent',hImportNetDlg,...
    'HorizontalAlignment','left',...
    'Position',[155 270 300 30],...
    'String','A connectivity matrix of P��P (or P��P��N), P is the Number of Nodes, and N is the Number of Subjects.',...
    'Style','text');

uicontrol(...
    'Parent',hImportNetDlg,...
    'HorizontalAlignment','left',...
    'Position',[155 225 300 30],...
    'String','A nodes postion matirx of P��3, if all the subjects share the same position matrix; or a matirx of P��3��N if different.',...
    'Style','text');

uicontrol(...
    'Parent',hImportNetDlg,...
    'HorizontalAlignment','left',...
    'Position',[155 158 215 16],...
    'String','A P��1 cell array of node (region) names.',...
    'Style','text');

uicontrol(...
    'Parent',hImportNetDlg,...
    'Position',[19 159 74 16],...
    'String','Node Names',...
    'Style','text');

uicontrol(...
    'Parent',hImportNetDlg,...
    'HorizontalAlignment','left',...
    'Position',[155 188 258 16],...
    'String','A N��1 vector or cell array of subject group labels.',...
    'Style','text');

uicontrol(...
    'Parent',hImportNetDlg,...
    'Position',[20 189 74 16],...
    'String','Group Labels',...
    'Style','text');

uicontrol(...
    'Parent',hImportNetDlg,...
    'Position',[17 129 74 16],...
    'String','Node Styles',...
    'Style','text');

uicontrol(...
    'Parent',hImportNetDlg,...
    'Position',[18 99 74 16],...
    'String','Node Colors',...
    'Style','text');

uicontrol(...
    'Parent',hImportNetDlg,...
    'Position',[16 69 74 16],...
    'String','Node Sizes',...
    'Style','text');

uicontrol(...
    'Parent',hImportNetDlg,...
    'Position',[16 39 74 16],...
    'String','Edge Width',...
    'Style','text');

uicontrol(...
    'Parent',hImportNetDlg,...
    'HorizontalAlignment','left',...
    'Position',[235 128 228 16],...
    'String','A P��1 cell array of element ''sphere'' or ''cube''.',...
    'Style','text');

uicontrol(...
    'Parent',hImportNetDlg,...
    'HorizontalAlignment','left',...
    'Position',[235 98 226 16],...
    'String','A P��3 matirx of RGB color or P��1 ColorSpec.',...
    'Style','text');

uicontrol(...
    'Parent',hImportNetDlg,...
    'HorizontalAlignment','left',...
    'Position',[205 68 226 16],...
    'String','A P��1 vector of node sizes.',...
    'Style','text');

end

