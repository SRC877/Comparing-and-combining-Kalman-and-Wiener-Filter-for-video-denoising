
% function exampleFilter
%
% Example of how the Kalman filter performs for real data
obj=VideoReader('julius.avi');

aviobj=VideoWriter('outputvideo.avi')
open(aviobj)
nFrames=obj.NumberOfFrames;
for k=1:nFrames
    img=read(obj,k);
    im2 = imnoise(img,'gaussian',0.1,0.2)
    f=im2frame(im2)
    writeVideo(aviobj,f)
end
    
close(aviobj)
%--------------------------------------------------------------------------
%---------------------End of Gaussian noise adding-------------------------
%--------------------------------------------------------------------------
%implay('outputvideo.avi');

filename = 'outputvideo.avi';
mov = VideoReader(filename);

% Output folder
%getting no of frames
videoFrames=[];
newframes=[];
realframe=[];
wienerframe=[];
psnrk=[];
filteredframe=[];
filteredframe1=[];
numberOfFrames = mov.NumberOfFrames;
numberOfFramesWritten = 0;

for frame = 1 :numberOfFrames
   thisFrame = read(mov, frame);
  % outputBaseFileName = sprintf('%3.3d.bmp', frame);
   
   %outputFullFileName = fullfile(outputFolder, outputBaseFileName);
   %imwrite(thisFrame, outputFullFileName, 'bmp');
   %progressIndication = sprintf('Wrote frame %4d of %d.', frame,numberOfFrames);
   videoFrames = cat(3,videoFrames,thisFrame);
   %disp(progressIndication);
   %numberOfFramesWritten = numberOfFramesWritten + 1;
end
for frame=1:size(videoFrames,3)
    x=videoFrames(:,:,frame);
    y=im2single(x);
    newframes = cat(3,newframes,y);
end

%Apply filter
k=Kalman_Stack_Filter(newframes);
k75=Kalman_Stack_Filter(newframes,0.75);
outputFolder= fullfile(cd, 'filteredframe');
if ~exist(outputFolder, 'dir')
   mkdir(outputFolder);
end
y=size(k,3);
disp(y);
for frame=1:y
    thisframe=k(:,:,frame);
    thisframe1=k75(:,:,frame);
    y=im2single(thisframe);
    y1=im2single(thisframe1);
    filteredframe = cat(3,filteredframe,y);
    filteredframe1=cat(3,filteredframe1,y1);

    %outputBaseFileName1 = sprintf('%3.3d.bmp', frame);
    %disp(x);
   %disp(outputBaseFileName1);
    %outputFullFileName1 = fullfile(outputFolder, outputBaseFileName1);
    %disp(outputFullFileName1);
   %disp(y);
   %imwrite(thisframe, outputFullFileName1, 'bmp');
end
%--------------------------------------------------------------------------
%---------------------Wiener Filering--------------------------------------
%--------------------------------------------------------------------------
%implay(videoFrames);

outputFolder3 = fullfile(cd, 'wienerframes');
if ~exist(outputFolder3, 'dir')
   mkdir(outputFolder3);
end
disp(outputFolder3);

for frame=1:size(newframes,3)
   I=videoFrames(:,:,frame);
   I=im2single(I);
    %x=frame+5;
    %outputBaseFileName1 = sprintf('%3.3d.bmp',x);
    %outputFullFileName1 = fullfile(outputFolder3, outputBaseFileName1);
    %disp(outputFullFileName1);
    J=wiener2(I,[5 5]);
    wienerframe=cat(3,wienerframe,J);
end
%--------------------------------------------------------------------------
%---------------------End of Wiener Filering-------------------------------
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
%-------------------------Real Frames--------------------------------------
%--------------------------------------------------------------------------
outputFolder3 = fullfile(cd, 'realvideoframes');
if ~exist(outputFolder3, 'dir')
   mkdir(outputFolder3);
end
x=size(videoFrames,3);
for i=1:x
    I=videoFrames(:,:,i);
    %z=i;
    %outputBaseFileName1 = sprintf('%3.3d.bmp',z);
    %outputFullFileName1 = fullfile(outputFolder3, outputBaseFileName1);
    %imwrite(I,outputFullFileName1);
    I=im2single(I);
    realframe=cat(3,realframe,I);
end
    
%--------------------------------------------------------------------------
%-------------------------End of Real Frames-------------------------------
%--------------------------------------------------------------------------

%{
%Set up image window
minMax=[min(newframes(:)),max(newframes(:))];
clf, colormap gray

subplot(1,3,1)
imagesc(newframes(:,:,1))
title('original')
set(gca,'clim',minMax), axis off equal

%subplot(1,3,2)
%imagesc(k(:,:,1))
%title('filtered, gain=0.5')
%set(gca,'clim',minMax), axis off equal

subplot(1,3,3)
imagesc(k75(:,:,1))
title('filtered, gain=0.75')
set(gca,'clim',minMax), axis off equal


%Loop movie 
%disp('crtl-c to stop movie')

while 1
    for i=1:size(k,3)
        
        subplot(1,3,1)
        set(get(gca,'children'),'CData',newframes(:,:,i))
        
       
        
        subplot(1,3,3)
        set(get(gca,'children'),'CData',k75(:,:,i))
        
        
        pause(0.05)
        drawnow
    end
end
%}
%--------------------------------------------------------------------------
%-------------------------PSNR---------------------------------------------
%--------------------------------------------------------------------------
psnrrealkalman=[];
psnwiener=[];
y=size(realframe,3);
%mseImage = (double(filteredframe(:,:,1) - (realframe(:,:,1)))) .^ 2;

for i=2:y
    %mseImage = ((filteredframe(:,:,i)) - (realframe(:,:,i))) .^ 2;
    %PSNR_Value = 10 * log10( 255^2 ./ mseImage);
    %PSNR_Value
    org=double(filteredframe(:,:,i));
    ork=double(filteredframe1(:,:,i));
    orgwiener=double(wienerframe(:,:,i))
    dist=double(realframe(:,:,i));
    [M N]=size(dist);
    error=org-dist;
    errorwiener=orgwiener-dist;
    errork=ork-dist;
    MSE=sum(sum(error .* error))/(M*N);
    MSEwiener=sum(sum(errorwiener .* errorwiener))/(M*N);
    MSEk=sum(sum(errork .* errork))/(M*N);
    PSNR_Value = (10 * log( 255^2 ./ MSE))/log(10);
    PSNRk_Value = (10 * log( 255^2 ./ MSEk))/log(10);
    PSNR_Valuewiener = (10 * log( 255^2 ./ MSEwiener))/log(10);
    psnwiener(i)=PSNR_Valuewiener;
    psnrk(i)=PSNRk_Value;
    psnrrealkalman(i)=PSNR_Value;
end
disp(psnwiener);
disp(psnrrealkalman);
x=linspace(1,168,168);
y1=psnrrealkalman;
disp(y1);
y2=psnwiener;
disp(y2);
plot(x,y1,x,y2);
legend('Kalman PSNR','Weiner psnr','psnrk');
xlabel('Number of frames');
ylabel('PSNR values');
