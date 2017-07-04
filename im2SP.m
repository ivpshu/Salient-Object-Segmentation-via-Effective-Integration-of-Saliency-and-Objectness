function out=im2SP(im, pixelList, form)


[h, w, chn] = size(im);
spNum = length(pixelList);

%SP form(vector)
if nargin<3
    form='SP';
end
if strcmp(form,'SP')
 tmpImg=reshape(im, h*w, chn);
 out = zeros(spNum, chn);
 for i = 1:spNum
    out(i,:) = mean(tmpImg(pixelList{i},:),1);  
 end
elseif strcmp(form,'Matrix')
% Ori Matrix  (need improve)  delete!!
out=zeros(h,w,chn);
for n=1:chn
    temp_out=zeros(h,w);
 for i = 1:spNum
    temp_im=im(:,:,n);
    temp_out(pixelList{i},:) = mean(temp_im(pixelList{i},:),1);  
 end
 out(:,:,n)=temp_out;
end

else
    error('error form');
end

end
