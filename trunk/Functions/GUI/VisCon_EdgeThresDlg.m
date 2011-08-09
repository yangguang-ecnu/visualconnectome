%VISCON_EDGETHRESDLG Summary of this function goes here
%   Detailed explanation goes here
function VisCon_EdgeThresDlg()
global gVisConFig;
global gVisConNet;
hFig = findobj('Tag','VisConFig');
FigPos = get(hFig,'Position');
DlgPos = [FigPos([1 2])+FigPos([3 4])/2-[200 0],400,165];

EdgeThresTypeOld = gVisConFig.EdgeThresType;
EdgeAbsThresOld = gVisConNet(gVisConFig.CurSubj).EdgeAbsThres;
EdgeCountThresOld = gVisConNet(gVisConFig.CurSubj).EdgeCountThres;

InitAbsThres = gVisConNet(gVisConFig.CurSubj).EdgeAbsThres;
InitCountThres = gVisConNet(gVisConFig.CurSubj).EdgeCountThres;

MinAbsThres = gVisConNet(gVisConFig.CurSubj).MinWeight;
MaxAbsThres = gVisConNet(gVisConFig.CurSubj).MaxWeight;
MaxCountThres = gVisConNet(gVisConFig.CurSubj).NzEdgeNum;

InitPropThres = InitCountThres/gVisConFig.EdgeNum;
MaxPropThres = MaxCountThres/gVisConFig.EdgeNum;

%Create dialog and bottongroup
hEdgeThresDlg = dialog('Name', 'Edge Threshold',...
    'Units','Pixel','Position',DlgPos,'CloseRequestFcn',@DlgCloseFcn);
hButtonGroup = uibuttongroup(hEdgeThresDlg,'Units','normalized',...
    'Position',[0 0 1 1],'SelectionChangeFcn',@ButtonGroupFcn);
uicontrol('Parent',hButtonGroup,...
    'Position',[10 28 230 20],...
    'Style','checkbox',...
    'Max',1,...
    'Min',0,...
    'Value',gVisConFig.IdenEdgeThres,...
    'String','Identical Edge Threshold (across subjects).',...
    'Tag','IdenEdgeThresCheck1',...
    'Callback',@IdenEdgeThresCheck1Fcn);
    function IdenEdgeThresCheck1Fcn(Src, Evnt)
        gVisConFig.IdenEdgeThres = get(Src, 'Value');
    end
%Create sliders
hAbsThresSlider = uicontrol(hButtonGroup,'Style','slider',...
    'Units','Pixel','Position',[50 115 240 16],...
    'Min',MinAbsThres,'Max',MaxAbsThres,...
    'Value',InitAbsThres,...
    'Callback',@AbsThresSliderFcn);
hCountThresSlider = uicontrol(hButtonGroup,'Style','slider',...
    'Units','Pixel','Position',[50 70 240 16],...
    'Min',1,'Max',MaxCountThres,...
    'SliderStep',[10/(MaxCountThres-1),100/(MaxCountThres-1)],...
    'Value',InitCountThres,...
    'Callback',@CountThresSliderFcn);
%Create edits
hAbsThresEdit = uicontrol(hButtonGroup,'Style','edit',...
    'Units','Pixel','Position',[335 114 46 18],...
    'String',sprintf('%.5f',InitAbsThres),...
    'BackgroundColor',[1 1 1],...
    'Callback',@AbsThresEditFcn);
hCountThresEdit = uicontrol(hButtonGroup,'Style','edit',...
    'Units','Pixel','Position',[335 79 46 18],...
    'String',sprintf('%d',InitCountThres),...
    'BackgroundColor',[1 1 1],...
    'Callback',@CountThresEditFcn);
hPropThresEdit = uicontrol(hButtonGroup,'Style','edit',...
    'Units','Pixel','Position',[335 60 40 18],...
    'String',sprintf('%.2f',InitPropThres*100),...
    'BackgroundColor',[1 1 1],...
    'Callback',@PropThresEditFcn);
%Create radio buttons
hAbsThresRadio = uicontrol(hButtonGroup,'Style','radiobutton',...
    'Min', 0, 'Max', 1,...
    'Units','Pixel','Position',[10 140 280 14],...
    'String','Absolute Threshold (Min Weight)');
hCountThresRadio = uicontrol(hButtonGroup,'Style','radiobutton',...
    'Min', 0, 'Max', 1,...
    'Units','Pixel','Position',[10 95 280 14],...
    'String','Counting Threshold (Proportional Threshold)');
if(gVisConFig.EdgeThresType == 0)
    set(hAbsThresRadio, 'Value', 1);
    set(hCountThresSlider,'Enable','off');
    set(hCountThresEdit,'Enable','off');
    set(hPropThresEdit,'Enable','off');
else
    set(hCountThresRadio, 'Value', 1);
    set(hAbsThresSlider,'Enable','off');
    set(hAbsThresEdit,'Enable','off');
end
%Create buttons
hOkButton = uicontrol(hButtonGroup,'Style','pushbutton',...
    'Units','Pixel','Position',[135 6 60 22],...
    'Callback',@OkButtonFcn,...
    'String','OK');
hCancelButton=uicontrol(hButtonGroup,'Style','pushbutton',...
    'Units','Pixel','Position',[205 6 60 22],...
    'Callback',@CancelButtonFcn,...
    'String','Cancel');
%Create static text
%Absolute threshold text
uicontrol(hButtonGroup,'Style','text',...
    'Units','Pixel','Position',[10 114 40 16],...
    'String',sprintf('%.4f',MinAbsThres));
uicontrol(hButtonGroup,'Style','text',...
    'Units','Pixel','Position',[290 114 45 16],...
    'String',sprintf('%.4f',MaxAbsThres));
%Counting threshold and proportional threshold text
uicontrol(hButtonGroup,'Style','text',...
    'Units','Pixel','Position',[10 61 40 16],...
    'String',sprintf('(%.1f%%)',1/gVisConFig.EdgeNum));
uicontrol(hButtonGroup,'Style','text',...
    'Units','Pixel','Position',[290 61 45 16],...
    'String',sprintf('(%.1f%%)',MaxPropThres*100));
uicontrol(hButtonGroup,'Style','text',...
    'Units','Pixel','Position',[378 61 10 16],...
    'String','%');
uicontrol(hButtonGroup,'Style','text',...
    'Units','Pixel','Position',[10 77 40 16],...
    'String','1');
uicontrol(hButtonGroup,'Style','text',...
    'Units','Pixel','Position',[290 77 45 16],...
    'String',sprintf('%d',MaxCountThres));
uicontrol(hButtonGroup,'Style','text',...
    'Units','Pixel','Position',[46,46,280,16],...
    'String',sprintf('*Totally %d edges, %d (%.1f%%) with non-zero weight.',...
    gVisConFig.EdgeNum,MaxCountThres,MaxPropThres*100));

    %Absolute minimal threshold slider function
    function AbsThresSliderFcn(Src, Evnt)
        AbsThres = get(Src, 'Value');
        set(hAbsThresEdit,'String', sprintf('%.5f',AbsThres));
        EdgeThreshold('absolute', AbsThres, gVisConFig.CurSubj);
        set(hCountThresEdit,'String', num2str(gVisConNet(gVisConFig.CurSubj).EdgeCountThres));
        set(hPropThresEdit,'String', num2str(gVisConNet(gVisConFig.CurSubj).EdgeCountThres/gVisConFig.EdgeNum*100, '%.2f'));
    end
    %Counting threshold slider function
    function CountThresSliderFcn(Src, Evnt)
        CountThres = get(Src, 'Value');
        CountThres = round(CountThres);
        set(Src, 'Value', CountThres);
        set(hCountThresEdit, 'String', sprintf('%i',CountThres))
        set(hPropThresEdit, 'String', sprintf('%.2f',CountThres/gVisConFig.EdgeNum*100));
        EdgeThreshold('counting', CountThres, gVisConFig.CurSubj);
        set(hAbsThresEdit, 'String', num2str(gVisConNet(gVisConFig.CurSubj).EdgeAbsThres, '%.5f'));
    end
    %Absolute minimal threshold edit function
    function AbsThresEditFcn(Src,Evnt)
        AbsThres = str2double(get(Src,'String'));
        errmsg=sprintf('You must enter a number between\n%.7f and %.7f',...
            gVisConNet(gVisConFig.CurSubj).MinWeight,gVisConNet(gVisConFig.CurSubj).MaxWeight);
        if ~isnan(AbsThres)
            if AbsMinThres<gVisConNet(gVisConFig.CurSubj).MinWeight || AbsMinThres>gVisConNet(gVisConFig.CurSubj).MaxWeight
                errordlg(errmsg,'Threshold error');
                set(Src,'String','');
                return;
            end
        else
            errordlg(errmsg,'Threshold error');
            set(Src,'String','');
            return;
        end
        set(hAbsThresSlider,'Value',AbsThres);
        set(0,'CurrentFigure',hFig);
        EdgeThreshold('absolute',AbsThres,gVisConFig.CurSubj);
        set(hCountThresEdit,'String', num2str(gVisConNet(gVisConFig.CurSubj).EdgeCountThres));
        set(hPropThresEdit,'String', num2str(gVisConNet(gVisConFig.CurSubj).EdgeCountThres/gVisConFig.EdgeNum*100, '%.2f'));
    end
    %Counting threshold edit function
    function CountThresEditFcn(Src,Evnt)
        CountThres = str2double(get(Src,'String'));
        errmsg = sprintf('You must enter a integer between 0 and %i',MaxCount);
        if ~isnan(CountThres)
            if CountThres<0 || CountThres>MaxCount
                errordlg(errmsg,'Threshold error');
                set(Src,'String','');
                return;
            end
        else
            errordlg(errmsg,'Threshold error');
            set(Src,'String','');
            return;
        end
        CountThres = round(CountThres);
        PropThres = CountThres/gVisConFig.EdgeNum;
        set(Src,'String',sprintf('%i',CountThres));
        set(hCountThresSlider,'Value',CountThres);
        set(hPropThresEdit,'String',sprintf('%.2f',PropThres*100));
        EdgeThreshold('counting',CountThres,gVisConFig.CurSubj);
        set(hAbsThresEdit, 'String', num2str(gVisConNet(gVisConFig.CurSubj).EdgeAbsThres, '%.5f'));
    end
    %Propertional threshold edit function
    function PropThresEditFcn(Src,Evnt)
        PropThres = str2double(get(Src,'String'))/100;
        errmsg = sprintf('You must enter a integer between 0 and %.2f',MaxPropThres*100);
        if ~isnan(PropThres)
            if PropThres<0 || PropThres>MaxPropThres
                errordlg(errmsg,'Threshold error');
                set(Src,'String','');
                return;
            end
        else
            errordlg(errmsg,'Threshold error');
            set(Src,'String','');
            return;
        end
        CountThres = PropThres*gVisConFig.EdgeNum;
        CountThres = round(CountThres);
        PropThres = CountThres/gVisConFig.EdgeNum;  
        set(Src,'String',sprintf('%.2f',PropThres*100));
        set(hCountThresEdit,'String',sprintf('%i',CountThres));
        set(hCountThresSlider,'Value',CountThres);
        EdgeThreshold('counting',CountThres,gVisConFig.CurSubj);
        set(hAbsThresEdit, 'String', num2str(gVisConNet(gVisConFig.CurSubj).EdgeAbsThres, '%.5f'));
    end
    %Button group function
    function ButtonGroupFcn(Src,Evnt)
        if Evnt.NewValue == hAbsThresRadio
            set(hAbsThresSlider,'Enable','on', 'Value', gVisConNet(gVisConFig.CurSubj).EdgeAbsThres);
            set(hAbsThresEdit,'Enable','on', 'String', num2str(gVisConNet(gVisConFig.CurSubj).EdgeAbsThres, '%.5f'));
            set(hCountThresSlider,'Enable','off');
            set(hCountThresEdit,'Enable','off');
            set(hPropThresEdit,'Enable','off');
        elseif Evnt.NewValue == hCountThresRadio
            set(hAbsThresSlider,'Enable','off');
            set(hAbsThresEdit,'Enable','off');
            set(hCountThresSlider,'Enable','on', 'Value', gVisConNet(gVisConFig.CurSubj).EdgeCountThres);
            set(hCountThresEdit,'Enable','on', 'String', num2str(gVisConNet(gVisConFig.CurSubj).EdgeCountThres));
            set(hPropThresEdit,'Enable','on', 'String', num2str(gVisConNet(gVisConFig.CurSubj).EdgeCountThres/gVisConFig.EdgeNum*100, '%.2f'));
        end
    end
    %Button functions
    function OkButtonFcn(Src,Evnt)
        if gVisConFig.IdenEdgeThres
            if gVisConFig.EdgeThresType == 0
                EdgeThreshold('absolute', gVisConNet(gVisConFig.CurSubj).EdgeAbsThres, setdiff(1:length(gVisConNet), gVisConFig.CurSubj), 'off');
            elseif gVisConFig.EdgeThresType == 1
                EdgeThreshold('counting', gVisConNet(gVisConFig.CurSubj).EdgeCountThres, setdiff(1:length(gVisConNet), gVisConFig.CurSubj), 'off');
            end
        end
        delete(hEdgeThresDlg);
    end
    function CancelButtonFcn(Src,Evnt)
        close(hEdgeThresDlg);
    end
    %Close function
    function DlgCloseFcn(Src,Evnt)
        delete(hEdgeThresDlg);
        if(EdgeThresTypeOld == 0)
            EdgeThreshold('absolute', EdgeAbsThresOld, gVisConFig.CurSubj);
        else
            EdgeThreshold('counting', EdgeCountThresOld, gVisConFig.CurSubj);
        end
    end
end

