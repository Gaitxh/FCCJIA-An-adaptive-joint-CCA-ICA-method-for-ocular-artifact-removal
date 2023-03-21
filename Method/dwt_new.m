function [cA]=dwt_new(X)
%input:data
%output:process_data

%-----------------------------------
wave='bior4.4';
[c,l]=wavedec(X,4,wave);

a{1,1}=appcoef(c,l,wave,1);%提取第一层的近似分量

d{1,1}=detcoef(c,l,1);%提取第一层的细节分量

a{1,2}=appcoef(c,l,wave,2);%提取第二层的近似分量

d{1,2}=detcoef(c,l,2);%提取第二层的细节分量

a{1,3}=appcoef(c,l,wave,3);%提取第三层的近似分量

d{1,3}=detcoef(c,l,3);%提取第三层的细节分量

a{1,4}=appcoef(c,l,wave,4);%提取第四层的近似分量

d{1,4}=detcoef(c,l,4);%提取第四层的细节分量


dd=a{1,4};
N = length(dd);
sig_i = median(abs(dd)/0.6745); %constant for threshold
K = sig_i*sqrt(2.*log(N));
k=1;
while(k < N+1)
    if( abs(dd(k)) > K )
        dd(k)=0;
    end
        k=k+1;
end
a{1,4}=dd;
% i=1;
% while (i < size(d,2) +1)
%     cD_i = d{1,i};  %current vector of coefficient at level i
% 
%     l_d = length(cD_i);
%     m_i = median(abs(cD_i));
%     sig_i = m_i/0.6745;   %constant for threshold
%     T = sig_i*sqrt(2.*log(l_d));
%     k=1;
%     while(k < l_d+1)
%         if( abs(cD_i(k)) < T )
%             cD_i(k)=0;
%         end
%             k=k+1;
%     end
%     d{1,i} = cD_i;
%     i=i+1;
% end

c1=[a{1,4} d{1,4} d{1,3} d{1,2} d{1,1}];%重构小波分解向量，所有的细节分量变为零

cA=waverec(c1,l,wave);%重构信号
% plot(X);
% hold on;
% plot(cA);

end