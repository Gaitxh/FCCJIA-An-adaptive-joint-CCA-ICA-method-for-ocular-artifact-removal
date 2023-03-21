function [SNR,MSE,PSNR,RMSE] = New_Revelant_Index2(OLDEEGdata,EEGdata)

for Data_ii =1:1:size(EEGdata,1)
    
    % % Signal to Noise Ratio(SNR)---�����__Խ��Խ��
    SNR(Data_ii,1) = 10*log10(sum( OLDEEGdata(Data_ii,:).^2 )/(sum((EEGdata(Data_ii,:)-OLDEEGdata(Data_ii,:)).^2)));
    
    % % Mean_Squre_Error(MSE)---�������_ԽСԽ��
    MSE(Data_ii,1) = pinv(size(EEGdata(Data_ii,:),2)) * sum((EEGdata(Data_ii,:)-OLDEEGdata(Data_ii,:)).^2);
    
    % % Peak Signal to Noise Ratio(PSNR)----��ֵ�����_Խ��Խ��
    PSNR(Data_ii,1) = 10*log10(255.^2/MSE(Data_ii,1));
    
    %%RMSE--���������__ԽСԽ��
    RMSE(Data_ii,1) = sqrt( (1/size(EEGdata,2))*sum((EEGdata(Data_ii,:)-OLDEEGdata(Data_ii,:)).^2) );
    
end
MSE = mean(real(MSE));PSNR = mean(real(PSNR));
RMSE = mean(real(RMSE));SNR = mean(real(SNR));
end
snr
rmse


