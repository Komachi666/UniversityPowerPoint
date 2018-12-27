function [Q, Qval]=process(section, masknum);

% take the 2-D dct of the image
A=dctus2(section);
%A=dct2(section);   % if we want to use matlab's dct2 function
mask=findmask(masknum);

[Q, Qval]=chunk(A, mask);

