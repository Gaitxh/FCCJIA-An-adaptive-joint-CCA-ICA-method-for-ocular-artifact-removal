clear
load('data.mat');
x=Add_NoiseData;
y=zeros(5,1000);
y(:,2:end)=x(:,1:end-1);
[cca_image_x,~,cca_pos_x,~,~,~,~,~,~,~]=solve_cca(x,y);
pro_data = Multi_EMD(cca_image_x);
Data=inv(cca_pos_x)*pro_data;
h = figure;
for channel_i = 1:1:size(x,1)
    subplot(round(size(x,1)/3)+1,3,channel_i);
    plot(x(channel_i,:));%蓝_原始的EEG数据
    hold on;    
    plot(Data(channel_i,:));
    hold on;
end