function g = oipadjust(x,lambda)
%OIPADJUST Adjust image intensity values for display.
%  Class support for input X: 
%          - uint8, float: double,single
%  X      - input an image or a matrix
%  lambda - standard deviation scalars [sqrt(2)~sqrt(8)]
%  g      - output image,uint8
%  Course:Optoelectronic Image Processing(OIP)
%  Copyright (c) 2006-2018 Zhenming Peng
%  IDIPLAB
%  School of Information and communication engineering,
%  University of Electronic Science and Technology of China
%  http://gispalab.uestc.edu.cn/
%
%  Revised:2018.11.14
% =========================================================================
if ~exist('lambda', 'var'), lambda = 4; end

if lambda < 2.0 || lambda > 8.0
        error(' lambda must be between 2.0 and 8.0');
end
%--------------------------------------------------------------------------
lambda = sqrt(lambda);
%--------------------------------------------------------------------------
if (~isa(x,'double'))
    f = double(x); 
else
    f = x;
end
%--------------------------------------------------------------------------
f = (f - min(f(:)))./(max(f(:)) - min(f(:)));
%--------------------------------------------------------------------------
fmean = mean(f(:));
fstd  = std(f(:));
mini = fmean - lambda * fstd; 
mini( mini<0 ) = 0;
maxi = fmean + lambda * fstd; 
maxi( maxi>1 ) = 1;
range = maxi - mini;
g = 255*(f - mini)./(range+eps);
g = max(min(g,255),0);
g = uint8(g); 
end
% =========================================================================
% End of this function
% =========================================================================