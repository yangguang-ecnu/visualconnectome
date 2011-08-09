clc;
clear;
load Network.mat
load AAL_Reg_Name.mat
%SurfStat exsits?
path = which('SurfStatReadSurf');
if isempty(path)
    VisConPath = which('VisualConnectome.m');
    addpath(fullfile(VisConPath(1:end-18),'Plugins','SurfStat'));
end
%Load surface data
LSurf = SurfStatReadSurf('ICBM152_midsurf_left.obj');
RSurf = SurfStatReadSurf('ICBM152_midsurf_right.obj');
%Change field names of surface structure
LSurfData.Faces = LSurf.tri;
LSurfData.Vertices = LSurf.coord.';
RSurfData.Faces = RSurf.tri;
RSurfData.Vertices = RSurf.coord.';
clear LSurf RSurf;
ConMat(:,:,2) = (ConMat(:,:,1) + 0.5) /1.5 ;
ConMat(:,:,3) = (ConMat(:,:,1) + 0.2) /1.2 ;
ConMat(:,:,4) = (ConMat(:,:,1) + 0.1) /1.1;
ConMat(:,:,5) = (ConMat(:,:,1) + 0.4) /1.4;
ConMat(:,:,6) = (ConMat(:,:,1) + 0.3) /1.4;
PosMat(:,:,2) = PosMat(:,:,1) * 0.95 + 2;
PosMat(:,:,3) = PosMat(:,:,1) * 0.94 + 3;
PosMat(:,:,4) = PosMat(:,:,1) * 0.93 + 4;
PosMat(:,:,5) = PosMat(:,:,1) * 0.92 + 5;
PosMat(:,:,6) = PosMat(:,:,1) * 0.91 + 6;
%Run VisualConnectome
VisualConnectome(ConMat,PosMat,'NodeName',AAL_Reg_Name,'NodeStyle','Cube');
%VisualConnectome(ConMat,PosMat,'LSurfData',LSurfData,'RSurfData',RSurfData,'NodeName',AAL_Reg_Name,'NodeStyle','Cube');