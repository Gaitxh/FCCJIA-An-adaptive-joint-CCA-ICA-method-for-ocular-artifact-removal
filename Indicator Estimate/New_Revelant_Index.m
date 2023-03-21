function [SNR,MSE,PSNR,RMSE] = New_Revelant_Index2(OLDEEGdata,EEGdata)

for Data_ii =1:1:size(EEGdata,1)
    
    % % Signal to Noise Ratio(SNR)---信噪比__越大越好
    SNR(Data_ii,1) = 10*log10(sum( OLDEEGdata(Data_ii,:).^2 )/(sum((EEGdata(Data_ii,:)-OLDEEGdata(Data_ii,:)).^2)));
    
    % % Mean_Squre_Error(MSE)---均方误差_越小越好
    MSE(Data_ii,1) = pinv(size(EEGdata(Data_ii,:),2)) * sum((EEGdata(Data_ii,:)-OLDEEGdata(Data_ii,:)).^2);
    
    % % Peak Signal to Noise Ratio(PSNR)----峰值信噪比_越大越好
    PSNR(Data_ii,1) = 10*log10(255.^2/MSE(Data_ii,1));
    
    %%RMSE--均方根误差__越小越好
    RMSE(Data_ii,1) = sqrt( (1/size(EEGdata,2))*sum((EEGdata(Data_ii,:)-OLDEEGdata(Data_ii,:)).^2) );
    
end
MSE = mean(real(MSE));PSNR = mean(real(PSNR));
RMSE = mean(real(RMSE));SNR = mean(real(SNR));
end
snr
rmse


