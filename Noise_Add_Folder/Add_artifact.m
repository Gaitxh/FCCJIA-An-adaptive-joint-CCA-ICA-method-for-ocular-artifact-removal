function [sim,Channel_select,rand_value] = Add_artifact(sim)
X = sim.X;
Noise_Fre = sim.NF;
Noise_Channel = sim.NC;
%生成要添加噪声的时间序列通道1~5
Channel_select = [1:size(X,1)];
%生成要添加的时间序列的位置1~1000
rand_value = randperm(size(X,2)-25);
load('artifact_noise.mat');
% rand_value = (randperm(size(X,2)/length(artifact))-1)*length(artifact)+1;
for channel_ii = 1:1:Noise_Channel
    for Change_ii = 1:1:(Noise_Fre*1000)
        X(Channel_select(channel_ii),rand_value(Change_ii):rand_value(Change_ii)+length(artifact)-1) =...
            X(Channel_select(channel_ii),rand_value(Change_ii):rand_value(Change_ii)+length(artifact)-1) ...
            + artifact;
    end
end

sim.noise_X = X;
end

