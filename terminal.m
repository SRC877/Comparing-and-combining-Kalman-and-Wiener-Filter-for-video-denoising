[noisyframes,videoframe]=gaussiannoise();
k=Kalman_Stack_Filter(noisyframes);
k77=Kalman_Stack_Filter(noisyframes,0.85);
wienervideo=wienerfilter(noisyframes);
%x=wienerframe(:,:,1)-wienervideo(:,:,1);

%array=cat(4,k,k75,wienervideo,realframe);
psnrs1=psnrcalculationnew(k,noisyframes);
psnrs2=psnrcalculationnew(k77,noisyframes);
psnrs3=psnrcalculationnew(wienervideo,noisyframes);
x=linspace(1,168,168);
plot(x,psnrs1,x,psnrs2,x,psnrs3);
legend('Kalman PSNR','Kalman','Wiener');
xlabel('Number of frames');
ylabel('PSNR values');