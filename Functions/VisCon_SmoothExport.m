function [ output_args ] = VisCon_SmoothExport( UpSamp, DnSamp )

global gVisConFig;
hFig = findobj('Tag', 'VisConFig');
ScreenDpi = get(0, 'ScreenPixelsPerInch');

print('temp_export',['-f',num2str(hFig)], ['-r',num2str(ScreenDpi * UpSamp)], '-dpng');
TempImg = imread('temp_export');
Kernel = LowPassButt(2, 3 * DnSamp, DnSamp);
if isempty(which('imfilter.m'))
    MyFilter = @conv2;
else
    MyFilter = @imfilter;
end
M = MyFilter(ones(size(TempImg(:,:,1))), Kernel, 'same');
ImgFiltered(:,:,1) = max(min(MyFilter(single(TempImg(:,:,1))/255, Kernel, 'same'), 1), 0) ./ M;
ImgFiltered(:,:,2) = max(min(MyFilter(single(TempImg(:,:,2))/255, Kernel, 'same'), 1), 0) ./ M;
ImgFiltered(:,:,3) = max(min(MyFilter(single(TempImg(:,:,3))/255, Kernel, 'same'), 1), 0) ./ M;
if abs(DnSamp - 1) > 0.01
    if(which


end

function Kernel = LowPassButt( N, KerSz, DnSamp )
KerSz = 2 * floor(KerSz / 2);
CutFreq = 0.5 / DnSamp;
Range = (-KerSz/2 : KerSz/2) / KerSz;
[X, Y] = ndgrid(Range, Range);
R = sqrt(X.^2 + Y.^2);
Kernel = ifftshift(1 ./ (1 + (R ./ CutFreq).^(2 * N)));
Kernel = fftshift(real(ifft2(Kernel)));
Kernel = Kernel ./ sum(Kernel(:));
end