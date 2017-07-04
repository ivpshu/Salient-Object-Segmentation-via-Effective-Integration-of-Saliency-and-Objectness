function [ ObjP] = OP2_fg_bg( adjcMatrix,weight_col, pixelList, Sal, Obj, cut_threshold,bdIds, clipVal, QS,RSO )
%SALOBJ_4B Summary of this function goes here
    Sal_SP=im2SP(Sal, pixelList);
    Obj_SP=im2SP(Obj, pixelList);
    
    [adjcMatrix, fgIds, bgIds] = Linkfgbgmasks(adjcMatrix, pixelList, Sal, Obj, cut_threshold);    
    [weight_my]=getWeight_fgbg( weight_col, bdIds, clipVal, fgIds, bgIds, Sal_SP, Obj_SP,QS,RSO);
    
    adjcMatrix = tril(adjcMatrix, -1); %提取矩阵下三角矩阵的函数 
    weight_my = weight_my((adjcMatrix > 0));
    geoDistMatrix = graphallshortestpaths(sparse(adjcMatrix), 'directed', false, 'Weights', weight_my);
    
%       ObjP = sum( geoDistMatrix(:, bdIds), 2);
        bg=intersect(bgIds,bdIds);
%         bg=unique(bg);
        ObjP = min( geoDistMatrix(:, bg),[],2); %bgIds

%     ObjP=mean(geoDistMatrix(:, bgIds),2);
%% Output2    
%     weight_my2 = weight_my2((adjcMatrix > 0));
%     geoDistMatrix2 = graphallshortestpaths(sparse(adjcMatrix), 'directed', false, 'Weights', weight_my2);
%     ObjP2 = min( geoDistMatrix2(:, bdIds),[],2);
end

