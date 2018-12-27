%==========================================================================
% 教学演示程序： 图像巴特沃斯(Butterworth)滤波
%               Program Name: myBTWFDemo.m
%               Course:Optoelectronic Image Processing(OIP)
% Copyright (c) 2006-2018 Zhenming Peng
% IDIPLAB,
% School of Information and communication engineering,
% University of Electronic Science and Technology of China
% http://gispalab.uestc.edu.cn/
%
% Revised:2018.10.22
% =========================================================================
clc,clear all,close all
f = imread('rice.png');
[M, N]= size(f);
imshow(f),title('原始图像');
% =========================================================================
% zeros padding,such as [256,256]->[512,512]
% =========================================================================
P = 2*M; Q = 2*N;
fp = zeros(P,Q);
fp(1:M, 1:N) = f;

% =========================================================================
% FFT+频谱中心化
% =========================================================================
Fp = fftshift(fft2(fp));
%Fp = fftshift(fft2(double(f),P,Q)); 利用FFT自动补零

% =========================================================================
% Build the Butterworth filter in frequence domain
% =========================================================================
%设定截止频率
D0 = 60; n = 3;

% 预分配内存
Hp = zeros(P,Q);
for u = 1:P
    for v = 1:Q
        D = sqrt((u-1-P/2).^2+(v-1-Q/2).^2);  % 中心（化）对称滤波器
        Hp(u,v) = 1./(1+(D./D0).^(2*n)); % lowpass
        %Hp(u,v) = 1./(1+(D0./D).^(2*n)); % highpass       
    end
end

% 2D滤波器频响
figure,imshow(Hp,[]),title('Butterworth 2D滤波器响应');

% =========================================================================
% 布局新的x-y网格，3D滤波器频响
% =========================================================================
dr = 0.5; dc = 0.5;
Fx = ((0:Q-1)-floor(Q/2))/(Q*dc);
Fy = ((0:P-1)-floor(P/2))/(P*dr);
[Fx,Fy] = meshgrid(Fx, Fy);
figure,surfl(Fx,Fy,Hp(1:P,1:Q));%title('3D理想滤波器响应')
xlabel('u'), ylabel('v'), zlabel('H(u,v)'),grid on
xlim([min(Fx(:)) max(Fx(:))]),ylim([min(Fx(:)) max(Fx(:))])
%xlabel('Fx'), ylabel('Fy'), zlabel('Magnitude'),grid on
shading interp,colormap copper

% 频域滤波
Gp = Hp .* Fp;

% 反中心化+傅立叶反变换
gp = real(ifft2(ifftshift(Gp)));
% =========================================================================
% 频谱反中心化
% =========================================================================

figure,imshow(uint8(gp)),title('扩充图像滤波结果');

% 扩大图像中截取需要的部分
gpi = gp(1:M, 1:N);
figure,imshow(uint8(gpi)),title('最终滤波结果');