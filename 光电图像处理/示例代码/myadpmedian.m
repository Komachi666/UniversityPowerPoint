%==========================================================================
%                      Matlab 教学演示程序                                                
%                      课程：图像处理及应用                                                  
%                      功能：Adaptive Median Filtering for image
%                      名称：myadpmedian.com
%                      作者：zhenming peng
%                      单位：University of Electronic Science and Technology
%                           of China 
%                      时间：2014.10.05
%==========================================================================
clc;close all;clear all;

inimage = imread('leaf.jpg');
Smax = 7;
if ndims(inimage) == 3,   % RGB is given
    g = rgb2gray(inimage);
else
    g = inimage;
end

subplot(2,2,1)
imshow(g)
title('Original Image')
noise=imnoise(g,'salt & pepper',0.2);
subplot(2,2,2)
imshow(noise)
title('Image with noisy')
subplot(2,2,3)
imshow(medfilt2(g,[3,3]))
title('Median Filtering')

subplot(2,2,4)
%==========================================================================
%This file includes a function what is named Updated Median Filtering.
%The input should be a picture(g) and the size of moldboard(Smax).

%Smax is the size of filtering moldboard.It must be an odd integer.
%if (Smax<=1)||(Smax/2==round(Smax/2))||(Smax~=round(Smax))
 %   error('Smax must be an odd integer >1');
%end
%==========================================================================
[M,N]=size(g);
% Initializing...
f=g;
% f( : )=0;
alreadyProcessed=false(size(g));
%Start filtering
for k=3:2:Smax
    %k*k Minimum filter
    zmin=ordfilt2(g,1,ones(k,k),'symmetric');        % 最小值滤波
     %k*k Maximum filter
    zmax=ordfilt2(g,k*k,ones(k,k),'symmetric');      % 最大值滤波
    %k*k Median filter
    zmed=medfilt2(g,[k,k],'symmetric');              % 中值滤波
    
    %Judge that if Zmed is a pulse
    processUsingLevelB=(zmed>zmin)&(zmax>zmed)&~alreadyProcessed;   
   
    % Judge that if Zxy is a pulse
    zB=(g>zmin)&(zmax>g);
    
    outputZxy=processUsingLevelB&zB;
    outputZmed=processUsingLevelB&~zB;
    f(outputZxy)=g(outputZxy);
        f(outputZmed)=zmed(outputZmed);
    alreadyProcessed=alreadyProcessed | processUsingLevelB;
    if all(alreadyProcessed( : ))
        break;
    end
end
imshow(f);title('Image with adaptive median filtering')

%==========================================================================
%figure,imshow(g);title('Original Image')
figure,imshow(medfilt2(g));title('Image with median filtering')
figure,imshow(f);title('Image with adaptive median filtering')