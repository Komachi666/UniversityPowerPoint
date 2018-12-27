%==========================================================================
% 教学演示程序： Build the Frequency Filter from the Small Mmask 
%               in Spatial Domain
%               Program Name: myfreqz2.m
%               Course:Optoelectronic Image Processing(OIP)
% Copyright (c) 2006-2017 Zhenming Peng
% GISPALAB
% School of Opto-Electronic Information, 
% University of Electronic Science and Technology of China
% http://gispalab.uestc.edu.cn/
%
% Revised:2017.10.24
% =========================================================================

clc,clf,clear all,close all; 
% =========================================================================
% 空域滤波器构建
% =========================================================================
h1 = [-1 0 1;-2 0 2;-1 0 1];  %  Sobel filter with x-direction(odd)
h2 = ones(9,9);               %  Average filter(even)
h3 = [1  4  7  4 1
         4 16 26 16 4
         7 26 41 26 7
         4 16 26 16 4
        1  4  7  4 1];         % Gaussian filter(even)
h4 = [0 -1  0
        -1  4 -1
        0 -1  0];              % Laplace filter(even)
% =========================================================================
h0 = h3;          % 选择给定的空域滤波器
if sum(h0(:))~= 0
    h0 = h0/sum(h0(:)); % 滤波器系数处理，归一化滤波响应
end
h = rot90(h0,2); % Unrotate filter since FIR filters are rotated.
center_h = ceil((size(h) + 1)/2); % 确定滤波器中心点坐标（r,c）
% =========================================================================

Nr = 256; Nc = 256;  % 扩充后的尺寸(行/列数)，可依据待处理图像的尺寸改变！
% =========================================================================
hp = zeros(Nr,Nc);
hp(1:size(h,1),1:size(h,2)) = h;  % right-down parts with zeros padding
% =========================================================================
% h中心点置于hp的左上角方式之一 （可选方式,等效circshift函数）
% Circularly shift h to put the center element at the upper left corner.
row_indices = [center_h(1):Nr, 1:(center_h(1)-1)]';
col_indices  = [center_h(2):Nc, 1:(center_h(2)-1)]';
hp = hp(row_indices, col_indices);

% =========================================================================
% h中心点置于hp的左上角方式之二:直接调用matlab（循环移位）函数
% hp = circshift(hp,[-(center_h(1)-1),-(center_h(2)-1)]); 
% =========================================================================

H = fftshift(fft2(hp));      % 频率原点中心化

% Convert to real if possible
% 时域f实/偶函数，对应频域F为实/偶函数
if all(max(abs(imag(H)))<sqrt(eps)) 
    H = real(H);              % 仅取实部
end

% Also check if the response is all imaginary
% 时域f实/奇函数，对应频域F虚/奇函数
if all(max(abs(real(H)))<sqrt(eps))
    %H = complex(0,imag(H));   % 实部置零
    H = imag(H);               % 仅取虚部
end

%subplot(122)
imshow(H,[]);             % 显示实部或虚部幅度,有正负号之分。
%imshow(abs(H),[]);       % 显示实部或虚部幅度
title('2-D frequency response');
% =========================================================================
% 设置x-y网格，显示滤波器3D频率响应
% =========================================================================
dr = 0.8; dc = 0.8;
x = ((0:Nc-1)-floor(Nc/2))/(Nc*dc); %列
y = ((0:Nr-1)-floor(Nr/2))/(Nr*dr); %行
[Fx,Fy] = meshgrid(x, y);
figure,mesh(Fx,Fy,H(1:Nr,1:Nc));title('3-D frequency response');
%figure,mesh(Fx,Fy,abs(H(1:Nr,1:Nc)));
xlabel('Fx'), ylabel('Fy'), zlabel('Magnitude'),grid on

% =========================================================================
Hm = freqz2(h0,[Nr Nc]);   % or freqz2(h0,Nc,Nr])-MATLAB函数（对应空域FIR滤波器）;
% =========================================================================
if all(max(abs(imag(Hm)))<sqrt(eps)) 
    Hm = real(Hm); % even：取实部
end
if all(max(abs(real(Hm)))<sqrt(eps))
    Hm = imag(Hm); % odd： 取虚部
end
figure,mesh(Fx,Fy,Hm(1:Nr,1:Nc)); 
title('3-D frequency response using matlab freqz2');