clear
clc
close all

%% system parameters
global cam camOrder
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHANGE HERE, IF NECESSARY  (START) %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Camera order - it may change when the cameras are plugged in. Check using
% FindingCameraOrder.m
cam_F1 = [1, 3];
cam_F2 = [5, 6];
cam_F3 = [2, 4];
camOrder = [cam_F1, cam_F2, cam_F3];

%period between capturing two images [s]
nperiod = 30; % average time for running the code = 15s, hence nperiod > 15

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHANGE HERE, IF NECESSARY  (STOP) %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% webcam configuration
%number of cameras
nc = 6; 

%checking if all cameras have been assigned
for ii = 1:nc
    temp = find(camOrder == ii);
    if length(temp) ~= 1 %more than one value assigned, or no assignment
        disp('Check cam_F1, cam_F2, and cam_F3')
        return %break program
    end
end

%camera resolution
res = 'YUY2_800x600'; 

for ii = 1:nc
    % camera configurations
    cam{ii} = videoinput('winvideo',ii,res);
    % choose config.
    set(cam{ii},'ReturnedColorSpace','RGB');
end

%% choosing the directory for saving the images
global dir_name  
dir_name = pwd;
today = datestr(now,'yy-mm-dd');

% checking if directory already exists
if ~exist([dir_name,'\',today],'dir')
    mkdir(dir_name, today);
    %disp('This directory does not exist');
else
    disp('Image directory already exists');
    return 
end

%% preparing timer for computations
global t
t = timer;
set(t, 'executionMode','fixedRate','Period',nperiod); %%%% PERIOD [s]
t.TimerFcn = @(x,y) ImageCapturingFunction;

% starting timer
start(t)
%stop(t)

%%
function ImageCapturingFunction()
    
    global dir_name cam camOrder
    % time for differentiate between frames 
    time = datestr(now,'yy-mm-dd-HHMMSS');
    today = datestr(now,'yy-mm-dd');
    
    name = {'F1C1','F1C2','F2C1','F2C2','F3C1','F3C2'};
    
    % show the time step we are taking the pictures
    picTakenTime = ['Pictures taken: ', num2str(time)];
    disp(picTakenTime);
    
    tic
    for ii = 1:6
        index = camOrder(ii); %finding the right camera
        % Take a picture
        [temp,~] = getsnapshot(cam{index});
        picture{ii} =  imrotate(temp,90);% Change orientation of the picture
        
        % save it
        imwrite(picture{ii},[dir_name,'\', today, '\',name{ii},'_',time,'.png'])
    end
    
    % open plot, using the currently opened window
    f = gcf;
    
    montage(picture,'Size',[3,2]);% Show the picture
    title(picTakenTime)% Show the time we took the pictures
      
    %%%%%%%%%%%%%%%%%%
    % Insert stop button
    %%%%%%%%%%%%%%%%%%
    c2 = uicontrol('Parent',f,'Units','normal','Position',[0.45, 0.05, 0.1, 0.05]); % [left bottom width height]
    uicontrol(c2);
    c2.String = 'Stop';
    c2.Callback = {@StopTimer};
 
    drawnow;
    
    toc
    
end

function StopTimer(~,~)
    global t
    % Stopping timer
    stop(t)
    disp('Process Stoped');

end
   
