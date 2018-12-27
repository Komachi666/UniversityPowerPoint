%==========================================================================
%                Homomorphic filtering
%                Name: oipHomfilt.m
%               Course:Optoelectronic Image Processing(OIP)
% Copyright (c) 2006-2018 Zhenming Peng
% IDIPALAB
% School of Information and communication engineering,
% University of Electronic Science and Technology of China
% http://gispalab.uestc.edu.cn/
%
% Revised: 2018.11.14
%==========================================================================
clc; clf; clear all; close all;
%==========================================================================

inima = imread('Fig0462(a)(PET_image).tif'); %clocks.bmp, tun.bmp
f = im2double(inima);
[M, N] = size(f);

%==========================================================================
% 边界处理
%==========================================================================
padsiz = [7 7];                                       % boundary size
rb = padsiz(1); cb = padsiz(2);
fp = padarray(f, padsiz, 'replicate');     % padding border: symmetric,circular etc.

%==========================================================================
%P = 2*M; Q = 2*N;
P = 2*(M + 2*rb); Q = 2*(N + 2*cb);
%==========================================================================

fp = log(fp+0.01);           % 取对数并做傅立叶变换，log(I+1) for uint8
Fp = fft2(fp,P,Q);           % FFT with zeros padding
imshow(log(1+abs(fftshift(Fp))),[]),title('Log Image Spectrum')

%==========================================================================
% 同态滤波器设计
%==========================================================================
% set parameters 
D0 = 120;  % cutoff frequncy
c   = 2.00;  % the sharpness of the slope of H
rL  = 0.25;  % low frequncy
rH  = 2.20;  % high frequncy

%==========================================================================
% highpass  filter
%==========================================================================
[v, u] = meshgrid(1:Q, 1:P); % [y,x] = size(I)
u = u - floor(P/2);                  % u centralization
v = v - floor(Q/2);                  % v centralization
D = u.^2 + v.^2;                     % distance
H = 1-exp(-c*(D./D0^2));      % gaussian highpass  filter

%==========================================================================
H = (rH - rL)*H + rL;            % Homomorphic filter
%==========================================================================
% plot the filter curve
%==========================================================================
figure,
mesh(H); title('The 3D Filter Response')  
H = ifftshift(H);             % 反中心化
p = H(1,1:floor(P/2));  % 取一行数据
figure(2), plot(p,'-b','LineWidth',2)
title(['Homomorphic Filter: D0=' num2str(D0) ',c=' num2str(c)])
xlabel('u'),ylabel('H')

%==========================================================================
Gp = Fp.*H;
gp = real(ifft2(Gp));        % IFFT
%g = gp(1:M, 1:N);
g = gp(rb+1:M+rb, cb+1:N+cb);
g = exp(g) - 0.01;            % 反对数变换: log(I+0.01)

%==========================================================================
%  adjust intensity values for display
%==========================================================================
lambda = 4.0;            % scale factor [2.0~8.0]
g = oipadjust(g,lambda); % 调整对比度显示
%==========================================================================

figure,
subplot(1,2,1),imshow(inima),title('The Original Image')
subplot(1,2,2),imshow(g,[]),title('Hormomorphic Filtering Image')