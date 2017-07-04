function [QS,RSO,param]=fusion_salobj_analyse(sal ,obj)
         Ta=mean(sal(:));
         Tave=im2bw(sal,Ta);
         
         th = multithresh(sal,2);
         if th(2)>1
             th(2)=1;
         end
         T1=im2bw(sal,th(1));
         T2=im2bw(sal,th(2));

         QS=sum(T2(:))/sum(Tave(:));
%         
  if QS>1
      QS=1;
      fprintf(2,'QS is more than 1');
  end
 
Tf=th(2);
   salbw=im2bw(sal,Tf);   
th_O = multithresh(obj,2);
   objbw=im2bw(obj,th_O(2));    
   [height,width]=size(sal);
   imdiagonal= sqrt(height^2+width^2);

   [sal_j,sal_i]=meshgrid(1:size(sal,2),1:size(sal,1));
   sal_ie=mean(sal_i(salbw));
   sal_je=mean(sal_j(salbw));
   [obj_j,obj_i]=meshgrid(1:size(obj,2),1:size(obj,1));
   obj_ie=mean(obj_i(objbw));
   obj_je=mean(obj_j(objbw));
   
   dist=sqrt((sal_ie-obj_ie)^2+(sal_je-obj_je)^2);
   dist=dist/imdiagonal;  
   RSO=dist;
   
   
   %
   param.Tf=Tf;
%    param.T1=th(1);
   param.Ta=Ta;
end
         
         
         
         
         
         