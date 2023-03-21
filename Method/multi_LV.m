function [mT,w,E]=multi_LV(Data)
%data格式为N*P1,N为数据量，P1为通道数=channel
% clear
% time = 0;
% NLAG = 1;
% ChannelNum = 31;%通道数目
% Fs = 1000;%采样频率
% FreBand = [1 50];%带通滤波频率大小
% max_order = 60;   % 滤波器最大阶数
% %阶数设定
% if 3*Fs/(min(FreBand)) > max_order
%     filter_order = max_order;
% else
%     filter_order = 3*Fs/(min(FreBand));
% end
% %读取数据
% Temp = load('subject_48-TEST_1-3-negitive-19.mat');
% Temp = Temp.Data_filter;
% %将数据有single类型转换成double类型
% Temp = double(Temp);
% %带通滤波
% Temp = eegfilt(Temp,Fs,FreBand(1),FreBand(2), 0, filter_order);
% %>>>>>>>>>>>>>>>>>>下面就是做ICA<<<<<<<<<<<<<<<<<<<<<<<<<
% count = 0;
% Duration = 1;
% Threo = 10;
% EpochBeg = 1;
% EpochEnd = Duration*Fs;
% Dimension = 1;
% EpochBeg = 1; EpochEnd = Duration*Fs;
% while(EpochEnd<=size(Temp,2))
%     count = count + 1;
%     Ntemp = Temp(1:ChannelNum,EpochBeg:EpochEnd);
%     EpochBeg = EpochEnd + 1;
%     EpochEnd = EpochBeg + Duration*Fs - 1;
%     %EEG数据中心化处理，即去伪迹
%     for channel_i = 1:1:size(Ntemp,1)
%         Ntemp(channel_i,:) = Ntemp(channel_i,:) -  mean(Ntemp(channel_i,:));
%     end
%     Ntemp = detrend(Ntemp);
% end
data{1,1}=Data;
%data=data_make(Ntemp);

m = size(data,2);
% if m>1
    X=0;
    mi=[];
    for i = 1:m
        xi=data{1,i}';
        X=xi*xi'+X;
        mi=[mi size(xi,1)];
    end
    mm=max(mi);
    [Tg,lamda]=eig(X);
    lamda=diag(lamda);
    [lamda_sort,index]=sort(lamda,'ascend');
    L=floor(mm*0.9);
    for i=1:size(lamda,1)
        Tg_sort(:,i)=Tg(:,index(i));
    end
    
     %超潜变量
    count=L;
    Tg_sort=Tg_sort(:,1:L);
    for i = 1:m
        xi=data{1,i}';
        for ii = 1:size(Tg_sort,2)
            lamda1(ii)=Tg_sort(:,ii)'*xi*xi'*Tg_sort(:,ii);
            D(ii)=sqrt(1/lamda1(ii));
        end 
        DD{1,i}=diag(D);
    end
    
    for i = 1:m
        xi=data{1,m}';
        Ti{1,i}=xi*xi'*Tg_sort*DD{1,i};
    end
     for i = 1:m
         mT{1,i}=[];
         w{1,i}=[];
     end

    while count>0
 
       %提取所有数据的第一个向量
        for i =1:size(Ti,2)
           for l=1:size(Ti{1,i},2)
               T_cor1{1,l}(:,i)=Ti{1,i}(:,l);
           end
        end
        for l=1:size(Ti{1,i},2)
            rho = corr(T_cor1{1,l});
            ac=sum(rho(:,1))-1;
            A=m*(m-1)/2;
            acc(l)=ac/A;
        end
        [acc,l]=max(acc);
        Tii=T_cor1{1,l};
        for i = 1:m
            ti=Tii(:,i);
            mT{1,i}=[mT{1,i} ti];
            pp=inv(ti'*ti)*ti'*data{1,i}';
            E{1,i}=data{1,i}-(ti*pp)';  
        end
        

        ttg=Tg_sort(:,l);
        Tg_sort(:,l)=[];
        for i=1:size(DD,2)
            d=DD{1,i};
            w{1,i}=[w{1,i} d(l,l)*data{1,i}*ttg];
            d(l,:)=[];d(:,l)=[];
            DD{1,i}=d;
        end

        clear Ti
        for i = 1:size(E,2)
            xi=E{1,i}';
            Ti{1,i}=xi*xi'*Tg_sort*DD{1,i};
        end
        count=count-1;
    end
%     
% elseif  m==1
%     xi=data{1,1}';
%     X=xi*xi';
%     [Tg,lamda]=eig(X);
%     lamda=diag(lamda);
%     [lamda_sort,index]=sort(lamda,'descend');
%     L=floor(size(data,1)*0.9);
%     %or ceil
%     %L=ceil(size(data,2)*0.9);
%     for i=1:size(lamda,1)
%         Tg_sort(:,i)=Tg(:,index(i));
%     end
%     
%     %超潜变量
%     count=L;
%     Tg_sort=Tg_sort(:,1:L);
%     lamda_sort=lamda_sort(1:L);
%     for i = 1:size(lamda_sort,1)
%         a(i)=sqrt(1/lamda_sort(i));
%     end
%     D=diag(a);
%     Ti=xi*xi'*Tg_sort*D;
%     
%     mT=[];
%     while count>0
%         rho = corr(Ti, 'type','pearson');
%         A=sum(rho)-1;
%         [acc,p]=max(A);
%         ti=Tg(:,p);
%         mT=[mT ti];
%         for i=1:L
%             %p(i)'=inv(ti'*ti)*ti'*X;
%             E(i)=X;
%         
%         
%         end
%     end
end

