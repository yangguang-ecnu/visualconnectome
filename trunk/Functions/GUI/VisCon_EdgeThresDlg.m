%VISCON_EDGETHRESDLG Summary of this function goes here
%   Detailed explanation goes here
function VisCon_EdgeThresDlg()
global gNetwork;

EdgeRangeOld=gNetwork.EdgeRange;
hFig=findobj('Tag','VisConFig');
FigPos=get(hFig,'Position');
DlgPos=[FigPos([1 2])+FigPos([3 4])/2-[200 0],400,190];
InitMinAbs=gNetwork.EdgeRange(1);
InitMaxAbs=gNetwork.EdgeRange(2);
MinAbs=gNetwork.MinWeight;
MaxAbs=gNetwork.MaxWeight;
InitCount=sum(gNetwork.SortedWeight>=gNetwork.MinWeight);
MaxCount=gNetwork.NzEdgeNum;
InitProp=InitCount/gNetwork.EdgeNum;
MaxProp=MaxCount/gNetwork.EdgeNum;

%Create dialog and bottongroup
hEdgeThresDlg=dialog('Name','Edge Threshold',...
    'Units','Pixel','Position',DlgPos,'CloseRequestFcn',@DlgCloseFcn);
hButtonGroup=uibuttongroup(hEdgeThresDlg,'Units','normalized',...
    'Position',[0 0 1 1],'SelectionChangeFcn',@ButtonGroupFcn);
%Create sliders
hAbsMinThresSlider=uicontrol(hButtonGroup,'Style','slider',...
    'Units','Pixel','Position',[50 135 240 16],...
    'Min',MinAbs,'Max',MaxAbs,...
    'Value',InitMinAbs,...
    'Callback',@AbsMinThresSliderFcn);
hAbsMaxThresSlider=uicontrol(hButtonGroup,'Style','slider',...
    'Units','Pixel','Position',[50 105 240 16],...
    'Min',MinAbs,'Max',MaxAbs,...
    'Value',InitMaxAbs,...
    'Callback',@AbsMaxThresSliderFcn);
hCountThresSlider=uicontrol(hButtonGroup,'Style','slider',...
    'Units','Pixel','Position',[50 60 240 16],...
    'Min',1,'Max',MaxCount,...
    'SliderStep',[10/MaxCount,100/MaxCount],...
    'Value',InitCount,...
    'Callback',@CountThresSliderFcn);
%Create edits
hAbsMinThresEdit=uicontrol(hButtonGroup,'Style','edit',...
    'Units','Pixel','Position',[335 134 46 18],...
    'String',sprintf('%.5f',InitMinAbs),...
    'Callback',@AbsMinThresEditFcn);
hAbsMaxThresEdit=uicontrol(hButtonGroup,'Style','edit',...
    'Units','Pixel','Position',[335 104 46 18],...
    'String',sprintf('%.5f',InitMaxAbs),...
    'Callback',@AbsMaxThresEditFcn);
hCountThresEdit=uicontrol(hButtonGroup,'Style','edit',...
    'Units','Pixel','Position',[335 68 46 18],...
    'String',sprintf('%d',InitCount),...
    'Callback',@CountThresEditFcn);
hPropThresEdit=uicontrol(hButtonGroup,'Style','edit',...
    'Units','Pixel','Position',[335 50 40 18],...
    'String',sprintf('%.2f',InitProp*100),...
    'Callback',@PropThresEditFcn);
%Create radio buttons
hAbsThresRadio=uicontrol(hButtonGroup,'Style','radiobutton',...
    'Units','Pixel','Position',[10 160 280 14],...
    'String','Absolute Threshold');
hCountThresRadio=uicontrol(hButtonGroup,'Style','radiobutton',...
    'Units','Pixel','Position',[10 85 280 14],...
    'String','Counting Threshold (Proportional Threshold)');
%Create buttons
hOkButton=uicontrol(hButtonGroup,'Style','pushbutton',...
    'Units','Pixel','Position',[130 8 60 25],...
    'Callback',@OkButtonFcn,...
    'String','OK');
hCancelButton=uicontrol(hButtonGroup,'Style','pushbutton',...
    'Units','Pixel','Position',[210 8 60 25],...
    'Callback',@CancelButtonFcn,...
    'String','Cancel');
%Create static text
%Absolute threshold text
uicontrol(hButtonGroup,'Style','text',...
    'Units','Pixel','Position',[10 134 40 16],...
    'String',sprintf('%.4f',MinAbs));
uicontrol(hButtonGroup,'Style','text',...
    'Units','Pixel','Position',[290 134 45 16],...
    'String',sprintf('%.4f',MaxAbs));
uicontrol(hButtonGroup,'Style','text',...
    'Units','Pixel','Position',[10 104 40 16],...
    'String',sprintf('%.4f',MinAbs));
uicontrol(hButtonGroup,'Style','text',...
    'Units','Pixel','Position',[290 104 45 16],...
    'String',sprintf('%.4f',MaxAbs));
%Counting threshold and proportional threshold text
uicontrol(hButtonGroup,'Style','text',...
    'Units','Pixel','Position',[10 51 40 16],...
    'String',sprintf('(%.1f%%)',1/gNetwork.EdgeNum));
uicontrol(hButtonGroup,'Style','text',...
    'Units','Pixel','Position',[290 51 45 16],...
    'String',sprintf('(%.1f%%)',MaxProp*100));
uicontrol(hButtonGroup,'Style','text',...
    'Units','Pixel','Position',[378 51 10 16],...
    'String','%');
uicontrol(hButtonGroup,'Style','text',...
    'Units','Pixel','Position',[10 67 40 16],...
    'String','1');
uicontrol(hButtonGroup,'Style','text',...
    'Units','Pixel','Position',[290 67 45 16],...
    'String',sprintf('%d',MaxCount));
uicontrol(hButtonGroup,'Style','text',...
    'Units','Pixel','Position',[30,35,275,16],...
    'String',sprintf('*Totally %d edges, %d (%.1f%%) with non-zero weight',...
    gNetwork.EdgeNum,MaxCount,MaxProp*100));
%Seting Intial Enable
set(hCountThresSlider,'Enable','off');
set(hCountThresEdit,'Enable','off');
set(hPropThresEdit,'Enable','off');

    %Absolute minimal threshold slider function
    function AbsMinThresSliderFcn(Src,Evnt)
        AbsMinThres=get(Src,'Value');
        AbsMaxThres=get(hAbsMaxThresSlider,'Value');
        if AbsMinThres>AbsMaxThres
            AbsMinThres=AbsMaxThres;
            set(Src,'Value',AbsMinThres);
        end
        set(hAbsMinThresEdit,'String',sprintf('%.5f',AbsMinThres));
        EdgeThreshold('absolute',AbsMinThres,AbsMaxThres);
    end
    %Absolute maximal threshold slider function
    function AbsMaxThresSliderFcn(Src,Evnt)
        AbsMaxThres=get(Src,'Value');
        AbsMinThres=get(hAbsMinThresSlider,'Value');
        if AbsMaxThres<AbsMinThres
            AbsMaxThres=AbsMinThres;
            set(Src,'Value',AbsMaxThres);
        end
        set(hAbsMaxThresEdit,'String',sprintf('%.5f',AbsMaxThres));
        EdgeThreshold('absolute',AbsMinThres,AbsMaxThres);
    end
    %Counting threshold slider function
    function CountThresSliderFcn(Src,Evnt)
        CountThres=get(Src,'Value');
        CountThres=round(CountThres);
        set(Src,'Value',CountThres);
        set(hCountThresEdit,'String',sprintf('%i',CountThres))
        set(hPropThresEdit,'String',sprintf('%.2f',CountThres/gNetwork.EdgeNum*100));
        EdgeThreshold('counting',CountThres);
    end
    %Absolute minimal threshold edit function
    function AbsMinThresEditFcn(Src,Evnt)
        AbsMinThres=str2double(get(Src,'String'));
        AbsMaxThres=get(hAbsMaxThresSlider,'Value');
        errmsg=sprintf('You must enter a number between\n%.7f and %.7f',...
            gNetwork.MinWeight,gNetwork.MaxWeight);
        if ~isnan(AbsMinThres)
            if AbsMinThres<gNetwork.MinWeight || AbsMinThres>gNetwork.MaxWeight
                errordlg(errmsg,'Threshold error');
                set(Src,'String','');
                return;
            end
        else
            errordlg(errmsg,'Threshold error');
            set(Src,'String','');
            return;
        end
        if AbsMinThres>AbsMaxThres
            AbsMinThres=AbsMaxThres;
            set(Src,'String',sprintf('%.5f',AbsMinThres));
        end
        set(hAbsMinThresSlider,'Value',AbsMinThres);
        set(0,'CurrentFigure',hFig);
        EdgeThreshold('absolute',MinThres,MaxThres);
    end
    %Absolute maximal threshold edit function
    function AbsMaxThresEditFcn(Src,Evnt)
        AbsMaxThres=str2double(get(Src,'String'));
        AbsMinThres=get(hAbsMinThresSlider,'Value');
        errmsg=sprintf('You must enter a number between\n%.7f and %.7f',...
            gNetwork.MinWeight,gNetwork.MaxWeight);
        if ~isnan(AbsMaxThres)
            if AbsMaxThres<gNetwork.MinWeight || AbsMaxThres>gNetwork.MaxWeight
                errordlg(errmsg,'Threshold error');
                set(Src,'String','');
                return;
            end
        else
            errordlg(errmsg,'Threshold error');
            set(Src,'String','');
            return;
        end
        if AbsMaxThres<AbsMinThres
            AbsMaxThres=AbsMinThres;
            set(Src,'String',sprintf('%.5f',AbsMaxThres));
        end
        set(hAbsMaxThresSlider,'Value',AbsMaxThres);
        set(0,'CurrentFigure',hFig);
        EdgeThreshold('absolute',MinThres,MaxThres);
    end
    %Counting threshold edit function
    function CountThresEditFcn(Src,Evnt)
        CountThres=str2double(get(Src,'String'));
        errmsg=sprintf('You must enter a integer between 0 and %i',MaxCount);
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
        CountThres=round(CountThres);
        PropThres=CountThres/gNetwork.EdgeNum;
        set(Src,'String',sprintf('%i',CountThres));
        set(hCountThresSlider,'Value',CountThres);
        set(hPropThresEdit,'String',sprintf('%.2f',PropThres*100));
        EdgeThreshold('counting',CountThres);
    end
    %Propertional threshold edit function
    function PropThresEditFcn(Src,Evnt)
        PropThres=str2double(get(Src,'String'))/100;
        errmsg=sprintf('You must enter a integer between 0 and %.2f',MaxProp*100);
        if ~isnan(PropThres)
            if PropThres<0 || PropThres>MaxProp
                errordlg(errmsg,'Threshold error');
                set(Src,'String','');
                return;
            end
        else
            errordlg(errmsg,'Threshold error');
            set(Src,'String','');
            return;
        end
        CountThres=PropThres*gNetwork.EdgeNum;
        CountThres=round(CountThres);
        PropThres=CountThres/gNetwork.EdgeNum;  
        set(Src,'String',sprintf('%.2f',PropThres*100));
        set(hCountThresEdit,'String',sprintf('%i',CountThres));
        set(hCountThresSlider,'Value',CountThres);
        EdgeThreshold('counting',CountThres);
    end
    %Button group function
    function ButtonGroupFcn(Src,Evnt)
        if Evnt.NewValue==hAbsThresRadio
            set(hAbsMinThresSlider,'Enable','on');
            set(hAbsMaxThresSlider,'Enable','on');
            set(hAbsMinThresEdit,'Enable','on');
            set(hAbsMaxThresEdit,'Enable','on');
            set(hCountThresSlider,'Enable','off');
            set(hCountThresEdit,'Enable','off');
            set(hPropThresEdit,'Enable','off');
        elseif Evnt.NewValue==hCountThresRadio
            set(hAbsMinThresSlider,'Enable','off');
            set(hAbsMaxThresSlider,'Enable','off');
            set(hAbsMinThresEdit,'Enable','off');
            set(hAbsMaxThresEdit,'Enable','off');
            set(hCountThresSlider,'Enable','on');
            set(hCountThresEdit,'Enable','on');
            set(hPropThresEdit,'Enable','on');
        end
    end
    %Button functions
    function OkButtonFcn(Src,Evnt)
        delete(hEdgeThresDlg);
    end
    function CancelButtonFcn(Src,Evnt)
        close(hEdgeThresDlg);
    end
    %Close function
    function DlgCloseFcn(Src,Evnt)
        delete(hEdgeThresDlg);
        EdgeThreshold('absolute',EdgeRangeOld(1),EdgeRangeOld(2));
    end
end

