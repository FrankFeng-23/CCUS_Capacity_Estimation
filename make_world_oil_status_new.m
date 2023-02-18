%%% 运行该程序前需要运行make_USoil_yearbooks
%% 获取石油数据
url = "C:\Users\frankfeng1223\Desktop\Graduation_Design_Data\DataFile\tps_sumg.xls";
opts = detectImportOptions(url);
opts.SelectedVariableNames = [1,10:12,20];
ROW_Oil_data = readmatrix(url,opts);
ROW_Oil_data(find(ROW_Oil_data<0))=0;%将负数置零

US_Oil_data = UStile_yearly_table(:,2:end)/1e6;%去除第一列关于X坐标的信息,转换单位为百万桶

% %% 补全ROW_Cum数据，利用make_USoil_yearbooks最后算出的拟合曲线
% t = 1; %t=1代表2000年
% mining_rate = 0.0004*t + 0.0176; %make_USoil_yearbooks最后算出的拟合曲线

%% 填充Rem_matrix矩阵
%先考虑ROW
rem_ROW_matrix = zeros(size(ROW_Oil_data,1),101);%构建Rem_ROW_matrix矩阵存放ROW每个部分2000-2100年的剩余可采量
rem_US_matrix = zeros(size(US_Oil_data,1),101);%构建Rem_US_matrix矩阵存放US每个部分2000-2100年的剩余可采量
dis_count = 0;%记录勘探新石油的次数
for i = 1:101
    %%%储采比%%%
    if i <=21
        RP_ratio = 50;
    end
    if i > 21
        RP_ratio = -0.175*(i-21) + 50;%储采比i = 1为2000年，i = 51为2050年
    end
    %%%%%%%%%%%%

    %%%%%%US%%%%
    %先考虑2000-2020年，因为这部分有每年的产量数据
    if i <=21
        remain = US_Oil_data(:,i)*RP_ratio;%计算剩余可采量，单位为百万桶
        remain(remain<=0.01) = 0;%如果剩余油量仅为0.01百万桶，则一年直接采完
        rem_US_matrix(:,i) = remain;
    end
    if i >21
        produced = rem_US_matrix(:,i-1)/RP_ratio;
        remain = rem_US_matrix(:,i-1) - produced;
        remain(remain<=1) = 0;%如果剩余油量仅为1百万桶，则一年直接采完
        rem_US_matrix(:,i) = remain;
    end

    %%%%%ROW%%%%%
    if i==1%2000年ROW数据是有的，直接填入
        rem_ROW_matrix(:,i) = ROW_Oil_data(:,3);
    end
    if i > 1 %在考虑2000之后年份
        produced = rem_ROW_matrix(:,i-1)/RP_ratio;
        remain = rem_ROW_matrix(:,i-1) - produced;
        remain(remain<=10) = 0;%如果剩余油量仅为10百万桶，则一年直接采完
        rem_ROW_matrix(:,i) = remain;
        %%%%考虑加入未探明的%%%%
        %%%先计算未探明的总量%%%
        
        if dis_count < 10
            if mod(i,5)==1
                rem_ROW_matrix(:,i) = rem_ROW_matrix(:,i) + 0.1 * ROW_Oil_data(:,5);%每五年将未探明油田的10%加入到剩余开采中
                if i > 21
                    rem_US_matrix(:,i) = rem_US_matrix(:,i) + 0.15 * 0.1 * sum(ROW_Oil_data(:,5))/size(rem_US_matrix,1);%假设US占全球的13%，则US/ROW = 15%分配到每个tile
                end
                dis_count = dis_count + 1;
            end
        end
    end
end



