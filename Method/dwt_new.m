function [cA]=dwt_new(X)
%input:data
%output:process_data

%-----------------------------------
wave='bior4.4';
[c,l]=wavedec(X,4,wave);

a{1,1}=appcoef(c,l,wave,1);%��ȡ��һ��Ľ��Ʒ���

d{1,1}=detcoef(c,l,1);%��ȡ��һ���ϸ�ڷ���

a{1,2}=appcoef(c,l,wave,2);%��ȡ�ڶ���Ľ��Ʒ���

d{1,2}=detcoef(c,l,2);%��ȡ�ڶ����ϸ�ڷ���

a{1,3}=appcoef(c,l,wave,3);%��ȡ������Ľ��Ʒ���

d{1,3}=detcoef(c,l,3);%��ȡ�������ϸ�ڷ���

a{1,4}=appcoef(c,l,wave,4);%��ȡ���Ĳ�Ľ��Ʒ���

d{1,4}=detcoef(c,l,4);%��ȡ���Ĳ��ϸ�ڷ���


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

c1=[a{1,4} d{1,4} d{1,3} d{1,2} d{1,1}];%�ع�С���ֽ����������е�ϸ�ڷ�����Ϊ��

cA=waverec(c1,l,wave);%�ع��ź�
% plot(X);
% hold on;
% plot(cA);

end