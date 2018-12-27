%==========================================================================
%                一维快速FDCT分解与重构示例代码
%                name: myFDCTDemo.m
%                School of Opto-Electronic Information, University of
%                Electronic Science and Technology of China
%                Date: 2017.4.17
%                Author：Zhenming Peng
% =========================================================================
clc,clear all,close all;
load handel; % ..\toolbox\compiler\mcr\matlab\audiovideo
% chirp, gong, laughter, handel,...
% wavplay(y)    % Play recorded sound on PC-based audio output device
% wavwrite(y,Fs,'chirp.wav'); % Write WAVE (.wav) sound file
%[y,Fs] = wavread('no2');     % Fs/Hz
N = length(y);
t = (0:N-1)/Fs;
subplot(311)
plot(t,y);title('An original audio signal')
xlabel('t/s'),ylabel('Amplitude'),xlim([0 max(t)])

% =========================================================================
%  DCT using matlab fuction
% =========================================================================
Fx = dct(y);
u = 0:N-1;       % 广义频率序列
subplot(312)
plot(u,Fx);title('DCT coefficients')
xLabel('The generalized frequency/u'),yLabel('Magnitude'),xlim([0 N])

% =========================================================================
%  IDCT using matlab fuction
% =========================================================================
g = idct(Fx);
subplot(313)
plot(t,g);title('Reconstruction from DCT coefficients')
xLabel('t/s'),yLabel('Amplitude'),xlim([0  max(t)])

% =========================================================================
%   Fast dct using fft
% =========================================================================
yp = zeros(1,2*N);
yp(1:N) = y;
Fu = fft(yp);
Fu = Fu.*sqrt(2).*exp(-1j*pi*(0:2*N-1)/(2*N));
Fu(1) = Fu(1)./sqrt(2);
Fu = real(Fu)./sqrt(N);
Fy = Fu(1:N);
figure,
subplot(211)
plot(u(1:N),Fy);title('DCT coefficients using fft')
xLabel('The generalized frequency/u'),yLabel('Magnitude'),xlim([0 N])

% =========================================================================
%   Fast idct using ifft
% =========================================================================
Fe = zeros(1,2*N);
Fe(1:N) = Fy;
c = 2*sqrt(2*N).* exp(1j.*(0:2*N-1)*pi./(2*N)); % why?
c(1) = c(1)* sqrt(2);
Fe = c.*Fe;
ye = real(ifft(Fe));
subplot(212)
plot(t,ye(1:N));title('Reconstruction using ifft')
xLabel('t/s'),yLabel('Amplitude'),xlim([0  max(t)]),%ylim([-1 1])