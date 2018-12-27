%==========================================================================
%  教学演示程序： 1D Gaussian lowpass filetering in frequence domain
%                name:myglpf_1D.m
%                School of Opto-Electronic Information, University of
%                Electronic Science and Technology of China
%                Date: 2015.04.05
%                Author：zhenming peng
% =========================================================================
clc,clear all,close all;

% ========================================================================= 
% 测试信号的初始参数设定
%==========================================================================
dt = 0.001; fs = 1/dt; fn = fs/2; L = 0.6;
%==========================================================================
% 离散化原始测试信号，绘制原始信号曲线
%==========================================================================
t = 0:dt:L;% 按采样点间隔dt赋值，t形成一维数组
% 计算各时间点对应的x, x也为N+1个元素的数组
x = sin(2*pi*10*t)+10*sin(2*pi*50*t)+5*sin(2*pi*120*t);

% 便于滤波测试，原始信号中加随机噪声
y = x + 2.4*randn(size(t));

% 绘制原始信号/测试信号曲线
%subplot(211)
plot(1000*t,y,'-b') % 刻度：ms
%title('An initial signal')
title('Signal corrupted with zero-mean random noise')
xlabel('t/ms');ylabel('Amplitude')

% =========================================================================
% zeros padding,数据延拓，以防止频率纠缠错误
% =========================================================================
N = length(y);

% 数据延拓至2*N点
P = 2*N;
yp(1:P) = 0;
yp(1:N) = y;

% =========================================================================
% 空域调制实现频域频谱中心化(Spectrum Centralization)
% =========================================================================
for i = 1:P
    yp(i) = yp(i).*(-1)^(i); 
end

Fp = fft(yp);
%Fp = fftshift(Fp);
% =========================================================================
% Build 1D Gaussian lowpass filter in frequence domain
% 公式：GLPF = exp(-D(u).^2/(2.D0.^2))
% =========================================================================
% 设定截止频率(cut-off frequency)
D0 = 120;
% 预分配内存
Hp(1:P) = 0;
for u = 1:P
    D = u - P/2-1;
    Hp(u) = exp(-(D.^2)/(2*(D0.^2))); 
end

% 进行低通滤波
Gp = Hp .* Fp; 

% 扩充序列的傅立叶反变换
% Gp = ifftshift(Gp);
gp = real(ifft(Gp));
% =========================================================================
% 频谱反中心化（inverse centralization for its spectrum）
% =========================================================================
for i = 1:P
    gp(i) = gp(i).*(-1)^(i); 
end

% 从延拓序列2N点中截取前N点（原始信号长度）
gpi = gp(1:N);
%subplot(212)
hold on
plot(1000*t(1:N),gpi(1:N),'-r','LineWidth',2),title('Flitering result with GLPF');
xlabel('t/ms'),ylabel('Amplitude')
h = legend('Signal corrupted with zero-mean random noise','Flitering result with GLPF',1);
%set(h,'Interpreter','none')