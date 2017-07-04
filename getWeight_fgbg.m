function [ weight_my2]=getWeight_fgbg( weightMatrix, bdIds, clipVal,fgIds, bgIds, sal, obj, QS,RSO)

% % % % dist��
salMatrix=GetDistanceMatrix(sal);
objMatrix=GetDistanceMatrix(obj);

%% optional weight_col
weightMatrix = max(0, weightMatrix - clipVal);
weightMatrix=weightMatrix./max(weightMatrix(:));
% % % % % % % %%----------------fg ---------------------------%%

%% method
salobjMatrix2=sqrt( (salMatrix.^2+objMatrix.^2) );
salobjMatrix2=salobjMatrix2./max(salobjMatrix2(:));

weight_my2=exp(-RSO)*salobjMatrix2+(1-exp(-RSO))*weightMatrix;
weight_my2(fgIds,fgIds)=(1-QS)*weight_my2(fgIds,fgIds);     % saliency unformity

end

