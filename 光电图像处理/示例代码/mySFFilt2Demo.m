%==========================================================================
% Demo：图像空/频域滤波一致性测试代码
%       Program name: mySFFilt2Demo.m
%       Course:Optoelectronic Image Processing(OIP)
% Copyright (c) 2006-2017 Zhenming Peng
% GISPALAB
% School of Opto-Electronic Information, 
% University of Electronic Science and Technology of China
% http://gispalab.uestc.edu.cn/
%
% Revised: 2017.11.12
%==========================================================================
clc;clf;clear all;close all;
%==========================================================================
img = imread('Fig0526(a)(original_DIP).tif'); % Fig0438(a)(bld_600by600).tif cameraman.tif
img = im2double(img);
% subplot(131)
imshow(img,[]),title('Original image')
[M,N] = size(img);             % Original image size
%==========================================================================
% 空域滤波器生成
%h = ones(3,3)/9;                      % average
%h = [-1 0 1;-2 0 2;-1 0 1];           % sobel
%h = [0 1 0;1 -4 1;0 1 0];             % laplacian
%h = fspecial('gaussian',9,2);         % gaussian
h = fspecial('motion',100,-45);        % motion
%==========================================================================
% 空域滤波
gx = imfilter(img,h,'replicate');%'symmetric','circular','X'
% subplot(132)
figure, imshow(gx,[]);title('Spatial domain filtering')
%==========================================================================
% 频域滤波
%==========================================================================
center_h = floor((size(h)+1)/2);        % 确定滤波器h中心点坐标
padsb = center_h + 1;                   % 单边填充像素数
imp = padarray(img,[padsb(1),padsb(2)],'replicate'); % Padding border
PQ = 2*size(imp);
Fp = fft2(imp, PQ(1), PQ(2));           % 图像补零延拓后FFT
h  = rot90(h,2);                        % mask旋转180度

%Hp = fft2(h, PQ(1), PQ(2));            % 滤波器补零延拓后FFT（未做循环移位）

%==========================================================================
% 滤波器中心像素移到延拓区域的左上角
%==========================================================================
P = PQ(1); Q = PQ(2);
hp = zeros(P,Q);                       % 生成零PXQ矩阵
hp(1:size(h,1), 1:size(h,2)) = h;      % 零填充延拓后，h置于hp左上角
%==========================================================================
% h中心点置于hp的左上角方式之一 （可选方式,等效circshift函数）
% row_indices = [center_h(1):P, 1:(center_h(1)-1)]'; 
% col_indices = [center_h(2):Q, 1:(center_h(2)-1)];
% hp = hp(row_indices, col_indices);  
%==========================================================================
% h中心点置于hp的左上角方式之二:直接调用matlab（循环移位）函数
hp = circshift(hp,[-(center_h(1)-1),-(center_h(2)-1)]); 
%==========================================================================
Hp = fft2(hp);
%==========================================================================
%Hp = ifftshift(freqz2(rot90(h,2),P,Q)); % 调用matlab函数产生频域滤波器（中心化）
%==========================================================================
Gp = Hp.*Fp;                        % 频域滤波
gp = real(ifft2(Gp));               % 反变换/取实部
%gf = gp(1:M,1:N);                  % 裁剪有效数据（补0边界方式调用）
gf = gp(padsb(1)+1:M + padsb(1),padsb(2)+1:N + padsb(2));   % 裁剪有效数据（其他边界方式调用）
%subplot(133)
figure, imshow(gf,[]),title('Frequency domain filtering')