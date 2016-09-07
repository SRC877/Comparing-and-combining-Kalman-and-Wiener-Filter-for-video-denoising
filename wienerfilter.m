function wienervideo=wienerfilter(noisyframes)
noofframes=size(noisyframes,3);
wienervideo=[];
for frame=1:noofframes
    thisframe=noisyframes(:,:,frame);
    thisframe=wiener2(thisframe,[3 3]);
    wienervideo=cat(3,wienervideo,thisframe);
end
end