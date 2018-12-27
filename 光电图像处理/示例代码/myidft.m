function x = myidft(y,n)
%==========================================================================
% MYIDFT 1-D Inverse Discrete Fourier Transform
%--------------------------------------------------------------------------
%  y -  the Input sequence
%  n -  the sample number of IDFT
%  x -  the output sequence
%--------------------------------------------------------------------------
%
% Course: Optoelectronic Image Processing(OIP)
% Copyright (c) 2006-2018 Zhenming Peng
% IDIPLAB, 
% School of Information and communication engineering,
% University of Electronic Science and Technology of China
% http://gispalab.uestc.edu.cn/
%
% Revised: 2018.10.12
%==========================================================================
% 判断函数是否有输入参数
if nargin == 0,
	error(generatemsgid('Nargchk'),'Not enough input arguments.');
end

% 判断输入y是否为 NULL
if isempty(y),
    x = [ ];   return;
end

% If input is a vector, make it a column:
do_trans = (size(y,1) == 1);
if do_trans, y = y(:); end

% 设置n的缺省值等于y长度
if nargin == 1,
    n = size(y,1);
end

l = size(y,2);  % l column vectors

% Pad or truncate input if necessary
if size(y,1)<n,
    yp = zeros(n,l);
    yp(1:size(y,1),:) = y;
else
    yp = y(1:n,:);
end

%--------------------------------------------------------------------------
% IDFT key codes
%--------------------------------------------------------------------------
x = zeros(n,l);  % l column vectors
for u = 1:n
    x(u) = 0;
    for k = 1:n
         x(u) = x(u) + yp(k)*exp(((1i)*2*pi*(k-1)*(u-1))/n);
    end
end
x = x/n;

%--------------------------------------------------------------------------
% Re-order the elements of the columns of y
if isreal(y), x = real(x); end
if do_trans, x = x.'; end  % if y is row vectors