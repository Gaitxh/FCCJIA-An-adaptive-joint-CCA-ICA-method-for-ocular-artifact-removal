function [Data_wICA,Ingredient_Deal] = wICA(Add_NoiseData,Fs,ICA_type)
switch ICA_type
    case 1
        [weights,sphere,~,~,~,~,data] = runica(Add_NoiseData);
        Matrix_A = real(inv(weights*sphere));
        ICA_Ingredient = real(data);
    case 2
        [ICA_Ingredient,Matrix_A,~]=fastica(Add_NoiseData, 'approach', 'symm', 'g', 'tanh','initGuess', eye(size(Add_NoiseData,1)));
end
[Data_wICA,Ingredient_Deal] = WICA_affiliated(Add_NoiseData,Fs,Matrix_A,ICA_Ingredient);
end
function [Data_wICA,icaEEG2] = WICA_affiliated(data,Fs,A,icaEEG)
% data=double(data);
% [icaEEG, A, ~] = fastica(data);
nICs = 1:size(icaEEG,1);
Kthr = 1.1;
ArtefThreshold = 6;
verbose = 'off';
icaEEG = real(icaEEG);
% icaEEG2 = RemoveStrongArtifacts(icaEEG, nICs, Kthr, ArtefThreshold, Fs, verbose);
parfor chan_i = 1:size(icaEEG,1)
    icaEEG2(chan_i,:) = RemoveStrongArtifacts(icaEEG(chan_i,:), nICs, Kthr, ArtefThreshold, Fs, verbose);
end
Data_wICA = A*icaEEG2;
end