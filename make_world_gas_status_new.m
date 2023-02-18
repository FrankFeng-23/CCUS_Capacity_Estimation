%%% 运行该程序前需要运行make_USgas_yearbooks
%% 获取石油数据
url = ".\origin_data\tps_sumg.xls";
opts = detectImportOptions(url);
opts.SelectedVariableNames = [1,13:15,21];
ROW_Gas_data = readmatrix(url,opts);
ROW_Gas_data(find(ROW_Gas_data<0))=0;%将负数置零

US_Gas_data = UStile_yearly_table(:,2:end)/1e6;%去除第一列关于X坐标的信息,转换单位为十亿立方英尺

% %% 补全ROW_Cum数据，利用make_USGas_yearbooks最后算出的拟合曲线
% t = 1; %t=1代表2000年
% mining_rate = 0.0004*t + 0.0176; %make_USGas_yearbooks最后算出的拟合曲线

%% 填充Rem_matrix矩阵
%先考虑ROW
rem_ROW_matrix = zeros(size(ROW_Gas_data,1),101);%构建Rem_ROW_matrix矩阵存放ROW每个部分2000-2100年的剩余可采量
rem_US_matrix = zeros(size(US_Gas_data,1),101);%构建Rem_US_matrix矩阵存放US每个部分2000-2100年的剩余可采量
dis_count = 0;%记录勘探新天然气的次数
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
        remain = US_Gas_data(:,i)*RP_ratio;%计算剩余可采量，单位为十亿立方英尺
        remain(remain<=0.1) = 0;%如果剩余油量仅为0.1十亿立方英尺，则一年直接采完
        rem_US_matrix(:,i) = remain;
    end
    if i >21
        produced = rem_US_matrix(:,i-1)/RP_ratio;
        remain = rem_US_matrix(:,i-1) - produced;
        remain(remain<=10) = 0;%如果剩余油量仅为10十亿立方英尺，则一年直接采完
        rem_US_matrix(:,i) = remain;
    end

    %%%%%ROW%%%%%
    if i==1%2000年ROW数据是有的，直接填入
        rem_ROW_matrix(:,i) = ROW_Gas_data(:,3);
    end
    if i > 1 %在考虑2000之后年份
        produced = rem_ROW_matrix(:,i-1)/RP_ratio;
        remain = rem_ROW_matrix(:,i-1) - produced;
        remain(remain<=100) = 0;%如果剩余油量仅为100十亿立方英尺，则一年直接采完
        rem_ROW_matrix(:,i) = remain;
        %%%%考虑加入未探明的%%%%
        if dis_count < 10
            if mod(i,5)==1
                rem_ROW_matrix(:,i) = rem_ROW_matrix(:,i) + 0.1 * ROW_Gas_data(:,5);%每五年将未探明气田的10%加入到剩余开采中
                if i > 21
                    rem_US_matrix(:,i) = rem_US_matrix(:,i) + 0.3 * 0.1 * sum(ROW_Gas_data(:,5))/size(rem_US_matrix,1);%假设US占全球的23%，则US/ROW = 0.3分配到每个tile
                end
                dis_count = dis_count + 1;
            end
        end
    end
end



