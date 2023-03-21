function Data = Zeroing_ICA(Add_NoiseData,Fs,ICA_type)
switch ICA_type
    case 1
        [weights,sphere,~,~,~,~,data] = runica(Add_NoiseData);
        Matrix_A = real(inv(weights*sphere));
        ICA_Ingredient = real(data);
    case 2
        [ICA_Ingredient,Matrix_A,~]=fastica(Add_NoiseData, 'approach', 'symm', 'g', 'tanh','initGuess', eye(size(Add_NoiseData,1)));
end
Data = Zeroing_ICA_affiliated(Add_NoiseData,size(Add_NoiseData,1),Fs,10,Matrix_A,ICA_Ingredient);
end

function [EEGData,A,Denoised_ica_comp] = Zeroing_ICA_affiliated(EEGData,Channel,Fs, Threo,A,icasig)
% function EEGData = FastICA_LeeI(EEGData,Channel,Fs, Threo)
    Duration = 0.1;
    ThreoPeak = 2;
    if size(EEGData,1) ~= Channel
        EEGData = EEGData';
    end
    OldEEGData = EEGData;
    for channel_i = 1:1:size(icasig,1)
        temp_sig = icasig(channel_i,:);
        [maxv1,maxk1]=findpeaks(temp_sig,'minpeakdistance',Duration*Fs);
        [maxv2,maxk2]=findpeaks(abs(temp_sig),'minpeakdistance',Duration*Fs);
        if std(temp_sig) > Threo
            % 信号按尺度压缩
            temp_sig = ((abs(temp_sig)).^0.2).*(abs(temp_sig)./temp_sig);
            continue;
        end        
       
        New_temp_sig = temp_sig;
        if abs(max(maxv1)) > std(temp_sig)*2*ThreoPeak || abs(max(maxv2)) > std(temp_sig)*2*ThreoPeak
          
            ArtifactIndex1 = find(maxv1>std(temp_sig)*2*ThreoPeak);
            maxk1Inx = maxk1(ArtifactIndex1);
            ArtifactIndex2 = find(maxv2>std(temp_sig)*2*ThreoPeak);
            maxk2Inx = maxk2(ArtifactIndex2);
            ArtifactIndex = unique([ArtifactIndex1 ArtifactIndex2]);
            maxInx = unique([maxk1Inx maxk2Inx]);                 
            
            denose_sig = temp_sig;
            % Add by LPY 2020-09-22
            denoise_sig_inverse = abs(temp_sig);
            % -end
            % denose_sig(maxk1) = 0;mean_denose_sig = mean(denose_sig);
            % Add by LPY 2020-09-22
            denoise_sig_inverse(maxk2) = 0;
            mean_denose_sig_inverse = mean(denoise_sig_inverse);
            % -end
            SeriBeg = 1; SeriEnd = round(Duration*Fs/2);
            count = 0;temp_median_value = [];
            while(SeriEnd<length(temp_sig)+1)
                count = count + 1;
                temp_median_value(count) = max(abs(denose_sig(SeriBeg:SeriEnd)))/2;
                SeriBeg = SeriEnd + 1;
                SeriEnd = SeriBeg + round(Duration*Fs/2) - 1;
                if SeriEnd > length(temp_sig)
                    SeriEnd = length(temp_sig);
                end
                if SeriBeg > length(temp_sig)
                    break;
                end
            end
            % median_value = std(denose_sig);
            median_value = max(temp_median_value);
            
            median_value_inverse = std(denoise_sig_inverse);
            temp = abs(temp_sig)>median_value; inx = find(temp>0);
            temp_inverse = abs(temp_sig)>median_value_inverse; 
            inx_iverse = find(temp_inverse>0);
            recoverdata = zeros(1,length(denose_sig));
            New_temp_sig = temp_sig;
            
            
            inx = []; inx = maxInx;
            
            
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>       
            for data_j = 1:1:length(inx)
                range = []; 
                % 确定时间坐标的最大界和最小界                
            range = [max(inx(data_j)-floor(round(Duration*Fs)/2),1):...
                min(inx(data_j)+floor(round(Duration*Fs)/2), length(denose_sig))];
            
            New_temp_sig(range) = 0;
            end
            
        end
        temp_sig = New_temp_sig;        
        Denoised_ica_comp(channel_i,:) = temp_sig;    
    end
    
    EEGData = A*Denoised_ica_comp;    
    
end
