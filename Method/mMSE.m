function [mmse] = mMSE(Data,tao)
    %±ÈÀýÒò×Ó tao 
    N=size(Data,2);
    length=N/tao;
    for j=1:length
        y(j)=sum(Data(tao*(j-1)+1:j*tao))/tao;
    end
    m=2;
    r=std(y)*0.2;
    mmse=SampEn(y, m, r);
    if mmse==inf
        mmse=SampEn(y, 1, r);
    end
end

