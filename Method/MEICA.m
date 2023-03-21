function Data=MEICA(Add_NoiseData,Fs,ICA_type)
switch ICA_type
    case 1
        [weights,sphere,~,~,~,~,data] = runica(Add_NoiseData);
        A = real(inv(weights*sphere));
        icasig = real(data);
    case 2
        [icasig,A,~]=fastica(Add_NoiseData, 'approach', 'symm', 'g', 'tanh','initGuess', eye(size(Add_NoiseData,1)));
end

for num =1:size(icasig,1)
    cal_mmse(num)=mMSE(icasig(num,:),20);
    cal_kurtosis(num)=kurtosis(icasig(num,:));
end
mmse_Mean=mean(cal_mmse); mmse_SD=std(cal_mmse);
kurtosis_Mean=mean(cal_kurtosis);kurtosis_SD=std(cal_kurtosis);
N=size(icasig,1);

a=0.05;
t=tinv(1-a/2,N-1);
mmse_SEM=std(cal_mmse,1)/sqrt(N-1)*t;
kurtosis_SEM=std(cal_kurtosis,1)/sqrt(N-1)*t;
%mMSE 和峰度提到的阈值（粗体）分别是平均值的 95% CI 的下限值和上限值。
Threshold_mMSE=mmse_Mean-mmse_SEM;
Threshold_Kutosis=kurtosis_Mean+kurtosis_SEM;

%加一个判断
nIC1=[];nIC2=[];
for count = 1:size(cal_mmse,2)
    if cal_mmse(count)<Threshold_mMSE
        nIC1=[nIC1 count];
    end
end

for count = 1:size(cal_mmse,2)
    if cal_kurtosis(count)>Threshold_Kutosis
        nIC2=[nIC2 count];
    end
end
nICs=union(nIC1,nIC2); % Components to be processed, e.g. [1, 4:7]
N=size(nICs,2);
for i = 1:N
    icasig(nICs(1,i),:)=dwt_new(icasig(nICs(1,i),:));
end
Data=A*icasig;
% plot(Add_NoiseData(1,:));
% hold on;
% plot(Data(1,:));
end