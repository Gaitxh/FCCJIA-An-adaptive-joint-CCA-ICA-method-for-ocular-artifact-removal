function Data = Denoising_Estimate(NoiseData,flag,Fs)
% 1-Infomax ICA
% 2-Fast ICA
ICA_type = 2;

switch flag
    case 1
        Data = real(Zeroing_ICA(NoiseData,Fs,ICA_type)); % ZICA
    case 2
        Data = real(wICA(NoiseData,Fs,ICA_type)); % WICA 
    case 3
        Data = real(ATICA(NoiseData,Fs,ICA_type)); % ATICA
    case 4
        Data = real(MEICA(NoiseData,Fs,ICA_type));% MEICA
    case 5
        Data = real(FCCJIA(NoiseData,Fs,ICA_type));% FCCJIA
end
end