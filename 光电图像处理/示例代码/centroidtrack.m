clc;clear all; close all;
%======================================================
path = '.\image200s';        % 定义文件路径
totalfrm = 200;                    % 设置图像总帧数

%======================================================
% 多帧循环处理
%======================================================
for i = 1 : totalfrm
    if  i <= 9
        I = imread([path '\0000000', num2str(i) '.bmp']);
    else if  i <= 99
            I = imread([path '\000000', num2str(i) '.bmp']);
        else
            I = imread([path '\00000', num2str(i) '.bmp']);
        end
    end
    imshow(I), title(['第#' num2str(i) '图像']);   hold on

    I = uint8(I);
    [m,n] = size(I);
    bw = zeros(m,n);
    for j = 1:n   % 图像二值化
        for k = 1:m
            if I(k,j) > 200
                bw(k,j) = 255;
            else
                bw(k,j) = 0;
            end
        end
    end
    E = uint8(bw);
    [m,n] = find(E==0);
    M = [m,n];
    N = M(M(:,2)<480,:);                        % 去边缘线
    Y = fix(mean(N(:,1)));
    X = fix(mean(N(:,2)));
    plot(X,Y,'g*'), hold on
    %加边框
    xu = 38;                                      % 波门的半高度
    yu = 16;                                      % 波门的半长度
    XX = [X-xu  X-xu  X+xu   X+xu   X-xu ];       % 波门四个点的位置坐标
    YY = [Y-yu  Y+yu  Y+yu   Y-yu   Y-yu ];
    line(XX,YY);                                % 波门
    text (360,260,sprintf('形心(%3.2f,%3.2f)',X,Y));   %在图像上实时显示形心位置
    %title (sprintf('坐标(%3.2f,%3.2f)',X,Y));    
    pause(0.001); %设置暂停
end
%======================================================
