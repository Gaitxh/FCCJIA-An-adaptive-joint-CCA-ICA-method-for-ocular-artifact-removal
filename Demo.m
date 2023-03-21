clc;
clear all;
close all;
warning off
addpath(genpath(pwd))
BasicFilePath = [pwd,'\'];
DataReadPath = [BasicFilePath,'Pure Data Simulation\'];
FileName = dir(fullfile(DataReadPath,'*.mat'));
cycle_Time = 100;
Method_flag = [1,2,3,4,5];
Method_Label = {'ZICA','WICA','ATICA','MEICA','FCCJIA'};
Noise_Fre = [.003];
Noise_Channel = [6];
Fs = 100;
[Value, Loc] = sort([length(Noise_Fre) length(Noise_Channel)],'descend');
noise_flag = {'Fre','Intensity','Channel'};
for Noise_S_i = 1:1
    sim.NF = Noise_Fre(min(Noise_S_i,length(Noise_Fre)));
    sim.NC = Noise_Channel(min(Noise_S_i,length(Noise_Channel)));
    for Cycle_ii=1:cycle_Time
        load(['ini data.mat']);
        loc_rand = randperm(size(data,2));
        sim.X = data{loc_rand(1)};
        sim.X = sim.X;
        sim = Add_artifact(sim);
            fprintf('Noise_S:%d, CycleTime:%d-',Noise_S_i,Cycle_ii);
            for method_ii = 1:1:length(Method_flag)
                Data_Recover = Denoising_Estimate(sim.noise_X,Method_flag(method_ii),Fs);
                indi = indicator_evaluate(sim.X,Data_Recover);
                res.SNR{Noise_S_i}(Cycle_ii,Method_flag(method_ii)) = mean(indi.snr_chan);
                res.RMSE{Noise_S_i}(Cycle_ii,Method_flag(method_ii)) = mean(indi.rmse_chan);
                fprintf('%s, ',Method_Label{Method_flag(method_ii)});
            end
            fprintf('\n');
    end
    res.mean_SNR(Noise_S_i,:) = mean(res.SNR{Noise_S_i})
    res.mean_RMSE(Noise_S_i,:) = mean(res.RMSE{Noise_S_i})
    res.std_SNR(Noise_S_i,:) = std(res.SNR{Noise_S_i})
    res.std_RMSE(Noise_S_i,:) = std(res.RMSE{Noise_S_i})
end