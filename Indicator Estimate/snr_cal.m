function res_snr = snr_cal(Expec_Data,Esti_Data)
for chan_i = 1:size(Expec_Data,1)
    res_snr(chan_i) = 10*log10(sum( Expec_Data(chan_i,:).^2 )/(sum((Expec_Data(chan_i,:)-Esti_Data(chan_i,:)).^2)));
end
end