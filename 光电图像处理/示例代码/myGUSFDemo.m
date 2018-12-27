%==========================================================================
%                Gaussian Filetering in Frequence Domain
% Name:myGUSFDemo.m
% Copyright (c) 2006-2018
% IDIPLAB,
% School of Information and communication engineering,
% Electronic Science and Technology of China
% Date: 2018.10.20
% Author：Zhenming Peng
% =========================================================================
clc,clear all,close all
f = imread('Fig0432(a)(square_original).tif');
[M, N]= size(f);
imshow(f),title('原始图像');

% =========================================================================
% Zeros padding,such as [256,256]->[512,512]
% =========================================================================
P = M; Q = N;
fp = zeros(P,Q);
fp(1:M,1:N) = f; % 复制原图像块至左上角（优势：比循环方式运算快）

% =========================================================================
% 空域实现频谱中心化
% =========================================================================
for i = 1:P
    for j = 1:Q
        fp(i,j) = fp(i,j).*(-1)^(i-1+j-1);
    end
end
Fp = fft2(fp);
%Fp = fftshift(Fp);
%Fp = fftshift(fft2(double(f),P,Q)); 利用FFT自动补零

% =========================================================================
% Build the Gaussian filter in frequence domain
% =========================================================================

D0 = 200;         % 设定截止频率
Hp = zeros(P,Q); % 预分配内存/全0元素矩阵

for u = 1:P
    for v = 1:Q
        D = sqrt((u-1-P/2).^2+(v-1-Q/2).^2);
        Hp(u,v) = exp(-(D.^2)/(2*(D0^2)));
    end
end
%Hp = 1-Hp + 0.2;%  GHPF
figure,imshow(Hp),title('2D-Gaussian 滤波器响应')

% =========================================================================
% 布局新的x-y网格，3D滤波器频响
% =========================================================================
dr = 0.8; dc = 0.8;
Fx = ((0:Q-1)-floor(Q/2))/(Q*dc);
Fy = ((0:P-1)-floor(P/2))/(P*dr);
[Fx,Fy] = meshgrid(Fx, Fy);
figure,surfl(Fx,Fy,Hp(1:P,1:Q));%title('3D理想滤波器响应')
xlabel('u'), ylabel('v'), zlabel('H(u,v)'),grid on
xlim([min(Fx(:)) max(Fx(:))]),ylim([min(Fx(:)) max(Fx(:))])
%xlabel('Fx'), ylabel('Fy'), zlabel('Magnitude'),grid on
shading interp,colormap copper

% =========================================================================
% 点乘实现频域滤波
Gp = Hp .* Fp;
% =========================================================================

% 扩充图像的傅立叶反变换
% Gp = ifftshift(Gp);
gp = real(ifft2(Gp)); % 取实部，忽略寄生的虚部数据
% =========================================================================
% 频谱反中心化
% =========================================================================
for i = 1:P
    for j = 1:Q
        gp(i,j) = gp(i,j).*(-1)^(i-1+j-1);
    end
end
figure,imshow(uint8(gp)),title('扩充图像滤波结果');

% 扩大图像中截取需要的部分
gpi = gp(1:M, 1:N);
figure,imshow(uint8(255*mat2gray(gpi)),[]),title('最终滤波结果');