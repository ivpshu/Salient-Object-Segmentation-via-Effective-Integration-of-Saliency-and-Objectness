function out=im2SP2(im, idxImg, form)


[h, w, chn] = size(im);

%SP form(vector)
if nargin<3
    form='SP';
end
if strcmp(form,'SP')
 tmpImg=reshape(im, h*w, chn);
 out = zeros(max(idxImg(:)), chn);
 for i = 1:max(idxImg(:))
    out(i,:) = mean(tmpImg((idxImg == i),:),1);  
 end
elseif strcmp(form,'Matrix')
% Ori Matrix  (need improve)
out=zeros(h,w,chn);
for n=1:chn
    temp_out=zeros(h,w);
 for i = 1:max(idxImg(:))
    temp_im=im(:,:,n);
    temp_out(idxImg==i) = mean(temp_im((idxImg == i)),1);  
 end
 out(:,:,n)=temp_out;
end

else
    error('error form');
end

end

