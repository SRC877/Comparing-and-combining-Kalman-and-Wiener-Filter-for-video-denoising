function psnrs= psnrcalculationnew(k,realframe)
framenum=size(realframe,3);
psnrs=[];
for i=2:framenum
    org=double(realframe(:,:,i));
    errorimage=double(k(:,:,i));
    M=size(realframe,1);
    N=size(realframe,2);
    error=org-errorimage;
    MSE=sum(sum(error .* error))/(M*N);
    PSNR_Value = (10 * log( 255^2 ./ MSE))/log(10);
    psnrs(i)=PSNR_Value;
end
end