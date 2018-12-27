%==========================================================================
%          图像约束平滑（正则）复原示例代码
% Name: oipdeconreg.m
% Course: Optoelectronic Image Processing(OIP)
% Copyright (c) 2006-2017 Zhenming Peng
% IDIPLAB,
% School of Information and communication engineering,
% University of Electronic Science and Technology of China
% http://gispalab.uestc.edu.cn/
%
% Revised: 2018.11.08
%==========================================================================
close all;clear all;clc;
%--------------------------------------------------------------------------
% Display the original image.
im = im2double(imread('cameraman.tif'));% lena256.jpg
[hei,wid,~] = size(im);
subplot(2,3,1),imshow(im);
title('Original Image');

%--------------------------------------------------------------------------
% Simulate a Motion Blur.
LEN = 21;
THETA = 11;
PSF = fspecial('motion', LEN, THETA);
blurred = imfilter(im, PSF, 'conv', 'circular');
subplot(2,3,2), imshow(blurred); title('Blurred Image');

%--------------------------------------------------------------------------
% Inverse filter
If = fft2(blurred);
Pf = psf2otf(PSF,[hei,wid]);
deblurred = real(ifft2(If./Pf));
subplot(2,3,3), imshow(deblurred); title('Deblurred with Inverse Filter')

%--------------------------------------------------------------------------
% Simulate Additive Noise.
noise_mean = 0;
noise_var = 0.0001;
blurred_noisy = imnoise(blurred, 'gaussian', ...
                        noise_mean, noise_var);
subplot(2,3,4), imshow(blurred_noisy)
title('Simulate Blur and Noise')

%--------------------------------------------------------------------------
% Try Restoration Using  Constrained Least Squares Filtering.
p = [0 -1 0;-1 4 -1;0 -1 0];
P = psf2otf(p,[hei,wid]);

gama = 0.002;
If = fft2(blurred_noisy);
%--------------------------------------------------------------------------
numerator = conj(Pf);
denominator = Pf.^2 + gama*(P.^2);
%--------------------------------------------------------------------------
deblurred2 = ifft2( numerator.*If./ denominator );
subplot(2,3,5), imshow(deblurred2)
title('Deblurred Using Constrained Least Squares Filtering');
%--------------------------------------------------------------------------
subplot(2,3,6); imshow(deconvreg(blurred_noisy, PSF,0)); title('Result Using Matlab Function');