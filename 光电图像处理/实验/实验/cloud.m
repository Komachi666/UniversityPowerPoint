I=imread('C:\Users\jiang\Desktop\สตั้\cloud.jpg');
[ma,na,ca]=size(I);
b=max(I(:));
a=min(I(:));
c=0;
d=255;
Ip=zeros(ma,na,ca);
for k=1:3
for i=1:ma
    for j=1:na
        if I(i,j,k)>b
            Ip(i,j,k)=d;
        elseif I(i,j,k)<a
            Ip(i,j,k)=c;
        else 
            Ip(i,j,k)=(d-c)/(b-a)*(I(i,j,k)-a)+c;
        end
    end
end
end

Ip=uint8(Ip);

subplot(211)
imshow(I),title('original');
subplot(212)
imshow(Ip),title('linear');

