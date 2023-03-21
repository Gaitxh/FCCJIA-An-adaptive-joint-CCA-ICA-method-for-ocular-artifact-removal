function [cA]=process_dwt(X)
%input:data
%output:process_data
%-----------------------------------
N = length(X);     %number of samples from original signal
% z = nextpow2(N);
% p = 2^z;
%update number samples if necessary by padding zeros at the end for a power
%of 2:
% if(p > N)
%     p = p-N;
%     X(end + p)=0;
%     N = length(X);
% end
%-----------------------------------
%2^7=128, 2^8=256 2^9=512
%-----------------------------------
i_max = 5;   %last level possible.  i = 0 is the first level
i=1;
%-----------------------------------
cD_cell = cell(1,1);  %cell unit of 1x1 dimension
cA_cell = cell(1,1);  %cell unit of 1x1 dimension
%-----------------------------------
%Decomposition
cA = X;

while (i < i_max +1)
    [LoD,HiD] = wfilters('bior4.4','d');
    [cA,cD] = dwt(cA,LoD,HiD);
    %[cA,cD]=dwt(cA,'bior4.4','mode','per');   %send current approximation and save cA and cD
    cD_cell{i,1}= cD;
    cA_cell{i,1}= cA;
    i=i+1;
end

i=1;
N1=N;
while (i < i_max +1)
    cD_i = cD_cell{i,1};  %current vector of coefficient at level i

    N = length(cD_i);
    sig_i = median(abs(cD_i)/0.6745); %constant for threshold
    K = sqrt(sig_i*2.*log(N1));
    k=1;
    while(k < N+1)
        if( abs(cD_i(k)) > K )
            cD_i(k)=0;
        end
            k=k+1;
    end
    cD_cell{i,1} = cD_i;
    i=i+1;
end
%-----------------------------------
%Reconstruction
i=i_max;
cA = cA_cell{i,1};
while (i > 0)
    %cA = idwt(cA,cD_cell{i,1},'bior4.4','mode','per');
    cD=cD_cell{i,1};
    p=1;
    while size(cA,2) ~= size(cD,2)
        cD(1,size(cD,2)+p)=0;
        p=p+1;
    end

    [LoR,HiR] = wfilters('bior4.4','r');
    cA = idwt(cA,cD,LoR,HiR);
    i=i-1;
end

end
