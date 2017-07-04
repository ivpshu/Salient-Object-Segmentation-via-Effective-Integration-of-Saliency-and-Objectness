function [adjcMatrix, fgIds, bgIds, salIds, objIds] = Linkfgbgmasks(adjcMatrix, pixelList, sal, obj, param)
ratio=0.5;%control sp number
th_O=multithresh(obj,2);
param_O.Tf=th_O(2);
Ta_O=mean(obj(:));
param_O.Ta=Ta_O;
% param_O.T1=th_O(1);

%% fgIds
sal_mask=im2bw(sal,param.Tf);
obj_mask=im2bw(obj,param_O.Tf);
sal_mask_SP=im2SP(sal_mask, pixelList);
obj_mask_SP=im2SP(obj_mask, pixelList);

salIds=find(sal_mask_SP>=ratio);
objIds=find(obj_mask_SP>=ratio);


fgIds=intersect(salIds,objIds);

%% bgIds
sal_mask_bg=1-im2bw(sal,param.Ta);
obj_mask_bg=1-im2bw(obj,param_O.Ta);

sal_mask_bg_SP=im2SP(sal_mask_bg, pixelList);
obj_mask_bg_SP=im2SP(obj_mask_bg, pixelList);

salIds_bg=find(sal_mask_bg_SP>=ratio);
objIds_bg=find(obj_mask_bg_SP>=ratio);

bgIds=cat(1,salIds_bg,objIds_bg);
bgIds=unique(bgIds); 

adjcMatrix(bgIds, bgIds)=1;

end

