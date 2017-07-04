
clear, clc, 
close all
addpath(genpath('External/Sal_Opt_CVPR14'));

%% 1. Parameter Settings
doFrameRemoving = false;
im_Dir = 'Imgs/';       %Path of input images
sal_Dir='Input/Saliency/';
obj_Dir='Input/Objectness/';
SP_Dir = 'Output/SP/';         %Path for saving superpixel index image and mean color image
ObjP_Dir = 'Output/ObjP/';       %Path for saving object probability maps

imSuffix = '.jpg';     %suffix for your input image
salSuffix = '_DRFI.png';  
objSuffix='.png';
if ~exist(SP_Dir, 'dir')
    mkdir(SP_Dir);
end
if ~exist(ObjP_Dir, 'dir')
    mkdir(ObjP_Dir);
end

%% 
imfiles = dir(fullfile(im_Dir, strcat('*', imSuffix)));
for k=1:length(imfiles)
    disp(k);
    imName = imfiles(k).name(1:end-length(imSuffix));
if exist([ObjP_Dir, imName, '_ObjP.png'], 'file')
   continue;
end

    Img = imread(fullfile(im_Dir, [imName, imSuffix])); %fullfile ????????????\
    Sal=imread([sal_Dir, imName salSuffix]); 
    Obj=imread([obj_Dir, imName objSuffix]);

    [h, w, chn] = size(Img);
    frameRecord = [h, w, 1, h, 1, w];
    
    %% Segment input rgb image into patches (SP)
    if exist([SP_Dir, imName, '.mat'], 'file')
        load([SP_Dir, imName, '.mat'])
    else
        pixNumInSP = 600;                           %pixels in each superpixel
        spnumber = round( h * w / pixNumInSP );     %super-pixel number for current image  
    %1. save with color
        [idxImg,pixelList,spNum] = SLIC_Split(Img, spnumber,SP_Dir,imName); 
    end
% 

    %% Get super-pixel properties
    Sal=im2double(Sal);Obj=im2double(Obj);

    meanRgbCol = GetMeanColor(Img, pixelList);
    meanLabCol = colorspace('Lab<-', double(meanRgbCol)/255);
    meanPos = GetNormedMeanPos(pixelList, h, w); %normlized
    bdIds = GetBndPatchIds(idxImg); % Get super-pixels on image boundary
   %%
    meanLabCol=Lab_norm(meanLabCol);% 
    colDistM = GetDistanceMatrix(meanLabCol);
    posDistM = GetDistanceMatrix(meanPos);
    
    %% Orignal Fusion
    [QS,RSO,param]=fusion_salobj_analyse(Sal ,Obj);

        
    %% Graph
    adjcMatrix = GetAdjMatrix(idxImg, spNum);
    adjcMatrix = LinkBoundarySPs(adjcMatrix, bdIds);%
    [clipVal, geoSigma, neiSigma] = EstimateDynamicParas(adjcMatrix, colDistM);

    cut_threshold=param;
    weight_col=colDistM;
    
    %% generate ObjP_adjcMatrix_Geodesic
   [ObjP] = OP2_fg_bg( adjcMatrix,weight_col, pixelList, Sal, Obj, cut_threshold,bdIds, clipVal,QS,RSO );
    
    svmapName=[ObjP_Dir, imName, '_ObjP.png']; 
    ObjP=SaveSaliencyMap(ObjP, pixelList, frameRecord, svmapName, true);

end
