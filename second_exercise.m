%%%%%%%%%%%%%%%%%%%%%%%%%%
%      2nd exercise      %
%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; clear all; close all;

%image read
im = imread('MVI_4117_frame_0677.bmp');
a= size(im);    %image size

block = 8;      %block size --- allagi gia 16
%------------------------------
%arxikopoihsh x diastasis block
  x = zeros((a(1)/ block),1);
  for i = 1: length(x)
      x(i) = block;
  end
%arxikopoihsh y diastasis  block
   y = zeros(1,(a(2)/ block));
  for i = 1: length(y)
      y(i) = block;
  end
%------------------------------  
   dim = mat2cell(im,x,y,3);    %diairesi eikonas se mikrotera blocks
show nearest blocks of the leaf to track
  subplot(2,2,1);
  imshow(dim{51,37}), title('i=51,j=37'); 
  subplot(2,2,2);
  imshow(dim{51,38}), title('i=51,j=38');
  subplot(2,2,3);
  imshow(dim{52,37}), title('i=52,j=37');
  subplot(2,2,4);
  imshow(dim{52,38}), title('i=52,j=38');
  
  %26 19: gia 16x16----52 38: gia 8x8
  ref = dim{52,38};     %reference frame
  c1 = 52;              %dimention x of tracked block
  c2 = 38;              %dimention y of tracked block
  
  it = 678;             %metavliti gia ton upologismo twn epomenwn frames
  %teleutaio frame pou 8a diavasoume
  last = imread('C:\Users\Nionios\Desktop\HMMY\9o_6mino\Machine_Vision\Project\frames\MVI_4117_frame_0728.bmp');
  
  for k = 1:50      %epanalipsi gia ta epomena 50frames
 	name = ['C:\Users\Nionios\Desktop\HMMY\9o_6mino\Machine_Vision\Project\frames\MVI_4117_frame_0' num2str(it) '.bmp'];
    curr = imread(name);        %current frame
    it = it+1;                  %gia to epomeno frame
  
  a= size(curr);
  %arxikopoihsh x diastasis block sto current frame
  x = zeros((a(1)/ block),1);
  for i = 1: length(x)
      x(i) = block;
  end
  %arxikopoihsh y diastasis block sto current frame
   y = zeros(1,(a(2)/ block));
  for i = 1: length(y)
      y(i) = block;
  end
  
  dim = mat2cell(curr,x,y,3);   %diairesi eikonas se mikrotera blocks
  
  n=c1-1;
  m=c2-1;
  curr_dim=dim{n,m};            %block elegxou sto current frame
  
  %arxikopoihsh elaxistis diaforas metaksi tou reference kai current clock
  min = MSE (ref , dim{n,m});       
  minn = c1-1;              %8esi elaxistis diaforas ston aksona x
  minm = c2-1;              %8esi elaxistis diaforas ston aksona y
  %elegxoume gia 8-neighbors
  for n = c1-1:c1+1
      for m = c2-1 : c2+1
      % check = ref-dim{n,m};    %diafora twn 2 blocks
      check = MSE (ref , dim{n,m});
      if ( min > check )
             min = check;
             minn = n;
             minm = m;
         end         
      end
  end
  
  %periptwseis opou ta kenta ref kai current_dim den einai idia
  %opote sxediazoume tin grammi apo to ena kentro sto allo
  %gia na emfanistei i diadromi
      if(c1~=minn || c2~=minm)
          %periptwsi opou exei kouni8ei diagwnia
          if(c1~=minn && c2~=minm)
              i=c1*block-block/2;
              p = -1;       %gia na meiwnetai to vima, kinisi pros ta aristera
              %periptwsi opou kini8ike deksia ston aksona y
              if(c2*block-block/2 < minm*block -block/2)
                   p = 1;   %gia na auksanetai to vima
              end
              for j=c2*block-block/2:p:minm*block -block/2
                  %enisxuoume to r xrwma kai elaxistopoioume ta g,b
                  last(i,j, 1) = 255;
                  last(i,j, 2) = 0;
                  last(i,j, 3) = 0;
                  if(c1>minn) %periptwsi opou kini8ike pros ta panw
                      i = i - 1;    %meiwnoume to vima kata ton x aksona
                  else
                      i = i + 1;    %auksanoume to vima kata ton x aksona
                  end
              end               
          else
             %kinisi mono ston aksona x kata i
             if(c2==minm)
                 j = c2*block-block/2;  %sta8eri 8esi j ston y aksona
                 p = -1;
                 %periptwsi opou kini8ike pros ta katw kata ton x
                 if(c1*block-block/2 < minn*block -block/2)
                     p = 1;
                 end
                 
                 for i = c1*block-block/2:p:minn*block -block/2
                  %enisxuoume to r xrwma kai elaxistopoioume ta g,b
                  last(i,j, 1) = 255;
                  last(i,j, 2) = 0;
                  last(i,j, 3) = 0;
                 end
             end
             %if (c1==minn)
             %kinisi mono ston aksona y kata j
                  i = c1*block-block/2;     %sta8eri 8esi tou i
                  p = -1;
                  %periptwsi opou kini8ike deksia kata ton j
                 if(c2*block-block/2 < minm*block -block/2) 
                     p = 1;
                 end
                 for j = (c2*block-block/2):p:(minm*block -block/2)
                  last(i,j, 1) = 255;
                  last(i,j, 2) = 0;
                  last(i,j, 3) = 0;
                 end 
           end
      end
  
      c1 = minn;    %diastasi x tou neou tracked
      c2 = minm;    %diastasi y tou neou tracked
      ref = dim{c1,c2};
      %enisxuoume to r xrwma kai elaxistopoioume ta g,b
      %apo kentro se kentro
      for j=c2*block-block/2:c2*block -block/2 +1
          for i=c1*block-block/2:c1*block -block/2 +1
              curr(i,j, 1) = 255;
              curr(i,j, 2) = 0;
              curr(i,j, 3) = 0;
          end
      end
%     figure();
%   imshow(curr)
  end
 figure();
  imshow(last)
  
  