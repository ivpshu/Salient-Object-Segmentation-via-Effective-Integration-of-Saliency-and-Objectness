clear all;
clc;
warning off; %#ok<WNOFF>
addpath('External/GrabCut');
TestFileNames = dir(['Imgs' '/*.' 'jpg']);
numberOfFiles = size(TestFileNames,1);
seg_time=0;
svstr='Output/results/';
mkdir(svstr);
for img_no =1:numberOfFiles  

    [path name ext] = fileparts(TestFileNames(img_no).name);
svname=[name,'_SEG.png'];
 disp(['NO.' num2str(img_no)]); 
if exist([svstr,svname], 'file')
    continue;
end
   
    picstr = ['Imgs/' name '.jpg'];
    im = imread(picstr);
    im=double(im);
 
    salstr=['Output/ObjP/' name '_ObjP.png'];

    sal=imread(salstr);sal=mat2gray(sal);
       
    fixedBG=im2double(sal);
    K=6;                    
    Beta=0.2;                
    G = 50;
    maxIter = 10;
    diffThreshold = 0.001;
    lambda=0.5;
    tic
    finalLabel = GCAlgo( im, fixedBG,  K, G,maxIter,Beta,diffThreshold, lambda);
    seg_time=seg_time+toc;
    finalLabel=double(1-finalLabel);         



imwrite(finalLabel, [svstr, svname]);
   
end
seg_avetime=seg_time/numberOfFiles;
 disp('over');
 
 