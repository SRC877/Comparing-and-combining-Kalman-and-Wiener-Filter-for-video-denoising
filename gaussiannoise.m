
% Example of how the Kalman filter performs for real data
%{
obj=VideoReader('pod.avi');

aviobj=VideoWriter('pocha.avi')
open(aviobj)
nFrames=obj.NumberOfFrames;
for k=1:nFrames
    img=read(obj,k);
    im2 = imnoise(img,'gaussian',0.1,0.2)
    f=im2frame(im2)
    writeVideo(aviobj,f)
    figure(1),imshow(im2,[]);
end
close(aviobj)
implay(aviobj)

/*outputVideo = VideoWriter(fullfile('shuttle_out.avi'));
outputVideo.FrameRate = shuttleVideo.FrameRate;
open(outputVideo)
for ii = 1:length(imageNames)
   img = imread(fullfile(workingDir,'images',imageNames{ii}));
   writeVideo(outputVideo,img)
end
close(outputVideo)*/

...code to be commented

shuttleVideo = VideoReader('pod.avi');
ii = 1;

while hasFrame(shuttleVideo)
   img = readFrame(shuttleVideo);
   filename = [sprintf('%03d',ii) '.jpg'];
   fullname = fullfile('images',filename);
   imwrite(img,fullname)    % Write out to a JPEG file (img1.jpg, img2.jpg, etc.)
   ii = ii+1;
end

filename = 'pocha.avi';
mov = VideoReader(filename);

% Output folder
outputFolder = fullfile(cd, 'frames');
if ~exist(outputFolder, 'dir')
   mkdir(outputFolder);
end

%getting no of frames
videoFrames=[];
newframes=[];

numberOfFrames = mov.NumberOfFrames;
numberOfFramesWritten = 0;
x=0;
y=5;
for frame = 1 :12
   thisFrame = read(mov, frame);
   outputBaseFileName = sprintf('%3.3d.bmp', frame);
   disp(x);
   disp(outputBaseFileName);
   outputFullFileName = fullfile(outputFolder, outputBaseFileName);
   disp(outputFullFileName);
   disp(y);
   imwrite(thisFrame, outputFullFileName, 'bmp');
   progressIndication = sprintf('Wrote frame %4d of %d.', frame,numberOfFrames);
   videoFrames = cat(3,videoFrames,thisFrame);
   disp(progressIndication);
   numberOfFramesWritten = numberOfFramesWritten + 1;
end
%implay(videoFrames);
outputFolder= fullfile(cd, 'filteredframe');
if ~exist(outputFolder, 'dir')
   mkdir(outputFolder);
end
for frame=1:12
    thisframe=videoFrames(:,:,frame);
    outputBaseFileName1 = sprintf('%3.3d.bmp', frame);
    disp(x);
   disp(outputBaseFileName1);
    outputFullFileName1 = fullfile(outputFolder, outputBaseFileName1);
    disp(outputFullFileName1);
   disp(y);
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

for frame=1:size(videoFrames,3)
    I=videoFrames(:,:,frame);
    x=frame+5;
    outputBaseFileName1 = sprintf('%3.3d.bmp',x);
    outputFullFileName1 = fullfile(outputFolder3, outputBaseFileName1);
    disp(outputFullFileName1);
    J=wiener2(I,[5 5]);
    imwrite(J,outputFullFileName1);
end

img=imread('realimage.bmp')
img=im2double(img)
wimg=(imread('008.bmp'))
fimg=im2double(imread('filteredimge.bmp'))

wimg=im2double(wimg)
imshow(wimg)
mse = sum((fimg(:)-img(:)).^2) / prod(size(img));
%now find the psnr, as peak=255
psnr = 10*log10(255*255/mse);
fprintf('\n The Peak-SNR value is %0.4f', psnr);
msewin = sum((wimg(:)-img(:)).^2) ;
%now find the psnr, as peak=255
psnrwin = 10*log10(255*255/msewin);


I=anoframe
%Kaverage = filter2(fspecial('average',3),I)/255;
Kmedian = medfilt2(I);
figure;
 h    = [];
 h(1) = subplot(2,2,1);
 h(2) = subplot(2,2,2);
 h(3) = subplot(2,2,3);
 h(4) = subplot(2,2,4);
 image(Kaverage,'Parent',h(1));
 image(Kmedian,'Parent',h(2));
 image(anoframe,'Parent',h(3));
 image(I,'Parent',h(4));
%}
function [noisyframes,videoframe]=gaussiannoise()
obj=VideoReader('julius.avi');
videoframe=[];
noisyframes=[];
noofframe=obj.NumberofFrames;
for frame=1:noofframe
    thisframe=read(obj,frame);
    thisframe=im2single(thisframe);
    videoframe=cat(3,videoframe,thisframe);
end
videosize=size(videoframe,3);
for k=1:videosize
    img=videoframe(:,:,k);
    f = imnoise(img,'gaussian',0.1,0.2)
    %f=im2frame(im2)
    noisyframes=cat(3,noisyframes,f);
end
end
