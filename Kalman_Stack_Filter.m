function imageStack=Kalman_Stack_Filter(imageStack,gain,percentvar)


% Process input arguments
if nargin<2, gain=0.5;          end
if nargin<3, percentvar = 0.05; end


if gain>1.0||gain<0.0
    gain = 0.8;
end

if percentvar>1.0 || percentvar<0.0
    percentvar = 0.05;
end


%Copy the last frame onto the end so that we filter the whole way
%through
imageStack(:,:,end+1)=imageStack(:,:,end);


%Set up variables
width = size(imageStack,1);
height = size(imageStack,2);
stacksize = size(imageStack,3);

tmp=ones(width,height);


%Set up priors
predicted = imageStack(:,:,1); 
predictedvar = tmp*percentvar;
noisevar=predictedvar;

x=0;
%Now conduct the Kalman-like filtering on the image stack
for i=2:stacksize-1
  stackslice = imageStack(:,:,i+1); 
  observed = stackslice;
  Kalman = predictedvar ./ (predictedvar+noisevar);
  corrected = gain*predicted + (1.0-gain)*observed + Kalman.*(observed-predicted);        
  correctedvar = predictedvar.*(tmp - Kalman);
 
  predictedvar = correctedvar;
  predicted = corrected;
  imageStack(:,:,i)=corrected;
end


imageStack(:,:,end)=[];
