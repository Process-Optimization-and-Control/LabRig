% Copyright 2016 The MathWorks, Inc.

clear
clc
close all

%% webcam configuration
nc = 6; %number of cameras
res = 'YUY2_800x600'; %camera resolution

%control the image loop
for ii = 1:nc
    % camera configurations
    cam{ii} = videoinput('winvideo',ii,res);
    % choose config.
    set(cam{ii},'ReturnedColorSpace','RGB');
end

while true    
    %tic
    for ii = 1:6
        % Take a picture    
        [temp,~] = getsnapshot(cam{ii});
        picture{ii} =  imrotate(temp,90);% Change orientation of the picture
    end
    
    montage(picture,'Size',[3,2]);% Show the picture
    %tit = ['Camera: ',num2str(ii)];
    %title(tit)% Show the label
    drawnow;
    %toc
    
end

%% PRESS CTRL+C after finding which camera is which
    
     
