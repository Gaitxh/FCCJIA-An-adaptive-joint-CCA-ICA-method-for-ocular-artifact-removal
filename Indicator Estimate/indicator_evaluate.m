function res = indicator_evaluate(Expec_Data,Esti_Data)
for chan_i = 1:size(Expec_Data,1)
    SNR_chan(chan_i) = snr_cal(Expec_Data(chan_i,:),Esti_Data(chan_i,:));
    RMSE_chan(chan_i)= rmse(Expec_Data(chan_i,:),Esti_Data(chan_i,:));
%     RMSE_chan(chan_i)= sqrt((1/size(Expec_Data,2))*sum((Expec_Data(chan_i,:)-Esti_Data(chan_i,:)).^2));
end
res.snr_chan = SNR_chan;
res.rmse_chan = RMSE_chan;
end