%==========================================================================
%           利用幅度/相位重建原图像示例代码
%           name: myimreconst.m
%           IDIPLAB, 
%           School of Information and communication engineering,
%           University of Electronic Science and Technology of China
%           Date: 2018.10.20; revised 
%           Author：Zhenming Peng
%==========================================================================
clc,clear all;
im = imread('Aishwarya.jpg'); 
other = imread('Greek churck.png');
subplot(131),imshow(im),title('Original image');
%set(gcf, 'Position', get(0, 'ScreenSize')); % maximize the figure window
%--------------------------------------------------------------------------

% 若输入RGB图像，则进行灰度化;否则，直接处理！
%==========================================================================
if ndims(im)==3,          
    im = rgb2gray(im);       % RGB is given    
end

if ndims(other)==3,          
    other = rgb2gray(other);       % RGB is given   
end

F = fft2(double(im));
F_mag = abs(F);             % has the same magnitude as image, 0 phase 
F_pha = exp(1i*angle(F));   % has magnitude 1, same phase as image
% OR: F_pha = cos(angle(F)) + 1i*(sin(angle(F)));
%F_pha = F_mag.*exp(1i*angle(F)); % same as ifft2(F)
%--------------------------------------------------------------------------
% Reconstruction
f_mag = log(real(ifft2(F_mag.*exp(1i*0))+1));
f_pha = ifft2(F_pha);
%--------------------------------------------------------------------------
% Calculate limits for plotting
% To display the images properly using imshow, the color range
% of the plot must the minimum and maximum values in the data.
% f_mag_min = min(abs(f_mag(:)));
% f_mag_max = max(abs(f_mag(:)));

% f_pha_min = min(abs(f_pha(:)));
% f_pha_max = max(abs(f_pha(:)));
%--------------------------------------------------------------------------
% Display reconstructed images
% because the magnitude and phase were switched, the image will be complex.
% This means that the magnitude of the image must be taken in order to
% produce a viewable 2-D image.
subplot(132),imshow(abs(f_mag),[]), colormap gray 
title('Reconstructed image only by Magnitude');
subplot(133),imshow(real(f_pha),[]), colormap gray 
title('Reconstructed image only by Phase');

%--------------------------------------------------------------------------
% 两幅图交换幅度和相位的图像重构
%--------------------------------------------------------------------------
figure,
subplot(221)
imshow(im);title('Aishwarya Rai')

subplot(222)
imshow(other);title('Greek churc')

F_o = fft2(double(other));
F_mago = abs(F_o);
F_phao = exp(1i*angle(F_o));
f_o = ifft2(F_mago.*F_pha);

subplot(223)
imshow(abs(f_o),[]);title('Aishwarya相位 + Greek churck幅度')

f_o = ifft2(F_mag.*F_phao);
subplot(224)
imshow(abs(f_o),[]);title('Aishwarya幅度 + Greek churck相位')

