%==========================================================================
%  教学演示程序： 一维离散信号FFT/IFFT
%           Name: FFTDemo_1D.m
%           IDIPLAB, 
%           School of Information and communication engineering, 
%           University of Electronic Science and Technology of China
%           http://gispalab.uestc.edu.cn/
%           Date: 2018.10.14; revised 
%           Author：Zhenming Peng
% See fft(),ifft(),mydft(),myidft()
%==========================================================================
%   例1：y = 0.5*sin(2*pi*15*x)+2*sin(2*pi*40*x)。        % 正弦信号
%   例2：y = zeros(nsamp,1);y(nsamp/2-10:nsamp/2+10)=1;   % 方波信号
%   例3：语音信号
%          nsamp：时间域信号样点数
%          nfft： 傅里叶变换点数（频域样点）
%==========================================================================

clc;clf;clear all;close all;
%==========================================================================
% 加载语音（audio）信号
% load laughter; % ..\toolbox\compiler\mcr\matlab\audiovideo
% chirp, gong, laughter, handel,...
% wavplay(y)    % Play recorded sound on PC-based audio output device
% wavwrite(y,Fs,'chirp.wav');       % Write wave sound file(*.wav)
[y,Fs] = wavread('chirp.wav');    % Fs/Hz,采样频率
nsamp = length(y);
%==========================================================================

% 参数设置
%Fs = 100;               % 设定采样频率,单位：赫兹（Hz）
%nsamp = 200;       % 设定采样点数（信号长度）,Such as 64,128,256,...
%==========================================================================
n = 0:nsamp-1;     % 样点序列（矢量）
dt = 1/Fs;         % 采样时间间隔，单位：秒（s）
x = dt*n;          % 时间序列（矢量）
%==========================================================================
% 输入模拟信号(离散化)
%y = 0.5*sin(2*pi*15*x)+2*sin(2*pi*40*x); 
%y = zeros(nsamp,1);
%y(nsamp/2-10:nsamp/2+10)=1;                % 方波信号
%==========================================================================
F = fft(y);            % 对输入信号的FFT
%F = fft(y,10000);     % 对输入信号后端补零至10000后FFT。
mag = abs(F);          %  FFT幅值(未中心化)
%mag = sqrt(real(F).^2+imag(F).^2);  % FFT幅值
mag0 = abs(fftshift(F));             % FFT幅度(中心化)

%==========================================================================
nfft  = length(F);     % FFT频率轴点数(may be changed)
df = Fs/nfft;          % 频率间隔
f = (0:nfft-1)*df;     % 频率采样序列（矢量）

%==========================================================================
fchar = num2str(Fs);     % 采样率转化为char(本文)
nchar = num2str(nsamp);  % 样点数转化为char(本文)
ltext = strcat('fs =',fchar,'Hz',',nsamp =', nchar,' points'); % 字符串拼接
%==========================================================================

subplot(311),plot(f,mag);   % 随频率变化的振幅
xlabel('频率/Hz');ylabel('幅度'); xlim([min(f) max(f)]);
title(['频谱（未中心化）：',ltext]);grid on;

f0 = df*(-nfft/2:nfft/2-1);    % 对称频率轴(含负频)
subplot(312),plot(f0,mag0);    % 随频率变化的振幅
xlabel('频率/Hz');ylabel('幅度'); xlim([min(f0) max(f0)]);
title(['频谱（中心化）：',ltext]);grid on;

subplot(313),plot(f(1:nfft/2+1),mag(1:nfft/2+1)); % 绘制有效频谱/半周期
xlabel('频率/Hz');ylabel('振幅');xlim([min(f) max(f)/2]);
title(['频谱（半周期）：',ltext]);grid on;

figure
subplot(211),plot(x,y);   % 随时间变化的振幅
title('原始信号'); grid on;
xlabel('时间/s'); ylabel('振幅');xlim([0 max(x)]);

%==========================================================================
% 傅里叶反变换重构信号
%==========================================================================
z = real(ifft(F));
subplot(212),plot(x,z(1:nsamp));
title('重构信号'); grid on;
xlabel('时间/s'); ylabel('振幅'); xlim([0 max(x)]);

%==========================================================================
%
%  分析及结论：
%  假设Fs=100Hz，Nyquist频率为Fs/2=50Hz。整个频谱图是以Nyquist频率为对称轴的。
%  则可明显识别出信号中含有两种频率成分：15Hz和40Hz。由此，可以知道FFT变换
%  数据的对称性。因此用FFT做信号谱分析，只需考察0~Nyquist频率范围内的福频特性。
%  若没有给出采样频率fs或和采样间隔dt，则分析通常对归一化频率0~1进行。
%  另外，幅度的数值与所用采样点数有关，采用128点和1024点的相同频率的幅度是不同
%  的，在同一幅图中，40Hz与15Hz振动幅值之比均为4:1，与真实振幅0.5:2是一致的。
%  为了与真实振幅对应，需要将变换后结果乘以2除以nsamp。
%
%==========================================================================
