%==========================================================================
%            The OTF Modeling in frequence domain
%            Name:myOTFmodel.m
% 1)The turbulence modeling
% 2)The motion modeling
%            Course:Optoelectronic Image Processing(OIP)
% Copyright (c) 2006-2017 Zhenming Peng
% GISPALAB
% School of Opto-Electronic Information, 
% University of Electronic Science and Technology of China
% http://gispalab.uestc.edu.cn/
%
% Revised: 2017.11.12
%==========================================================================
clc; clf; clear all; close all;
I = imread('Fig0526(a)(original_DIP).tif');% cameraman.tif,Fig0525(a)(aerial_view_no_turb).tif
I = im2double(I);
subplot(131),imshow(I,[]),title('原始图像')

% =========================================================================
[M, N] = size(I);
padsz = [0 0];  %直接频域滤波，空域h未知，可估计一个边界像素数。
rb = padsz(1); cb = padsz(2);  % Border size
P = 2*(M + 2*rb);  % zeros padding size in rows
Q = 2*(N + 2*cb); % zeros padding size in columns

% =========================================================================
[v,u] = meshgrid(1:Q,1:P); 
u = u - floor(P/2);            % centralization in rows
v = v - floor(Q/2);            % centralization in columns

% =========================================================================
% 一，湍流模型（The turbulence modeling）
% =========================================================================
k = 0.0025;                            % Set turbulence parameter
Duv = u.^2 + v.^2;
Htur = exp(-k.*Duv.^(5/6));    % Real value
clear Duv

% =========================================================================
% 二，运动模糊模型（The motion modeling）
% =========================================================================
T = 1.0;            % The duration of the exposure
a = 0.05;           % linear motion rates in the x-direction
b = 0.01;           % linear motion rates in the y-direction
Duv = pi *( a*u + b* v); % 最小浮点数的精度: eps = 2.2204e-016
Hmov = T./(Duv++ eps).* sin(Duv) .* exp( -1j * Duv ); % Complex value
clear Duv
%Hmov = psf2otf(fspecial('motion',100,-45),[P Q]); % 空域产生

% =========================================================================
OTF = Htur;         % Select the OTF (湍流或运动模糊)
subplot(132),imshow(abs(OTF),[]),title('光学传递函数(OTF)');

% =========================================================================
Ip = padarray(I, padsz, 'replicate'); %padding border,'circular'
FI = fft2(Ip,P,Q);
blurFT = FI.* ifftshift(OTF);  % Filtering
blurIp = real(ifft2(blurFT));  % Inverse transform

% =========================================================================
%blurI =  blurIp(1:M, 1:N);    % Crop the border（补零边界方式）
r1 =  rb+1;  r2 = M + rb;    % rows
c1 = cb+1; c2 = N + cb;   % columns
blurI= blurIp(r1:r2,  c1:c2);         % Crop the border（其他边界方式）
clear FI blurFT blurIp

% =========================================================================
subplot(133)
imshow(im2uint8(mat2gray(blurI))),title('模糊退化图像');