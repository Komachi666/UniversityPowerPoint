%==========================================================================
% Demo: Idel Lowpass & Highpass Filtering in Frequency Domain
%       Program Name:myidelfilt.m
%       Course:Optoelectronic Image Processing(OIP)
% Copyright (c) 2006-2018 Zhenming Peng
% IDIPLAB,
% School of Information and communication engineering,
% University of Electronic Science and Technology of China
% http://gispalab.uestc.edu.cn/
% 
% Include:
% Idel low-pass & highpass filtering
% Revised:2018.10.20
%==========================================================================
clc,clf,clear all,close all;
f = imread('rice.png');
[M, N] = size(f);                 % 原始图像尺寸
imshow(f), title('原始图像');

% =========================================================================
% Zeros padding,such as [256,256]->[512,512]
% =========================================================================
P = 2*M; Q = 2*N;   % 扩充后的图像尺寸
fp = zeros(P,Q);      % 预分配内存/全0元素矩阵，double型
fp(1:M,1:N) = f;        % 复制原图像块至左上角（优势：比循环方式运算快）

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

% =========================================================================
% Build the frequence domain filter
% =========================================================================

D0 = 200;              % 设定截止(cutoff)频率

Hp = zeros(P,Q); % 预分配内存/全0元素矩阵
for u = 1:P
    for v = 1:Q
        D = sqrt((u-1-P/2).^2+(v-1-Q/2).^2);  % 中心（化）对称滤波器
        if D <= D0
            Hp(u,v) =1.0;
        end
    end
end
%Hp = 1-Hp+0.8;       % 理想高通(ILHF)
figure,imshow(Hp,[]),title('2-D滤波器响应')

% =========================================================================
% 布局新的x-y网格，3D滤波器频响
% =========================================================================
dr = 0.8; dc = 0.8;
Fx = ((0:Q-1)-floor(Q/2))/(Q*dc);
Fy = ((0:P-1)-floor(P/2))/(P*dr);
[Fx,Fy] = meshgrid(Fx, Fy);
figure,surfl(Fx,Fy,Hp(1:P,1:Q)); title('3-D滤波器响应')
xlabel('u'), ylabel('v'), zlabel('H(u,v)'),grid on
xlim([min(Fx(:)) max(Fx(:))]),ylim([min(Fx(:)) max(Fx(:))])
%xlabel('Fx'), ylabel('Fy'), zlabel('Magnitude'),grid on
shading interp,colormap pink %copper 

% =========================================================================
% 频域滤波
Gp = Hp .* Fp;   % 点乘
% =========================================================================

% 填充图像的傅立叶反变换
% Gp = ifftshift(Gp);
gp = real(ifft2(Gp));    % 取实部
% =========================================================================
% 频谱反中心化
% =========================================================================
for i =1:P
    for j =1:Q
        gp(i,j) = gp(i,j).*(-1)^(i-1+j-1);
    end
end
figure,imshow(gp,[]),title('扩充图像滤波结果');

% 剪裁左上角有效图像
gpi = gp(1:M, 1:N);
figure,imshow(gpi,[]),title('最终滤波结果');