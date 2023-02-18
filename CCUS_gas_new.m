%运行该程序之前需要运行make_world_gas_status
level = 2;%最佳估计
file_base_url = "C:\Users\frankfeng1223\Desktop\Graduation_Design_Data\DataFile\result\";

%% 计算CO2平替甲烷
Ratio = [1.5,2,3];
effe_ratio = 0.75;

storage_US_CH4_list = zeros(size(US_Gas_data,1),101);%存放US的某个估计的EOR潜力,只有2020到2100年有效，对应下标为20-101
storage_ROW_CH4_list = zeros(size(ROW_Gas_data,1),101);%存放US的某个估计的EOR潜力,只有2020到2100年有效，对应下标为20-101
for i = 1:101
    cap_ROW = effe_ratio*Ratio(level)*1.98*0.028317/1000*rem_ROW_matrix(:,i);%单位Gt CO2
    cap_US = effe_ratio*Ratio(level)*1.98*0.028317/1000*rem_US_matrix(:,i);%单位Gt CO2
    storage_ROW_CH4_list(:,i) = cap_ROW;
    storage_US_CH4_list(:,i) = cap_US;
end
base = "NGD_US";
head_list = headname_gen(base);
writematrix(head_list,strcat(file_base_url,base,".xls"),'WriteMode','overwritesheet');
writematrix(storage_US_CH4_list(:,21:end),strcat(file_base_url,base,".xls"),'WriteMode','append');%1-81列表示2020-2100年，每行表示US的每个tile的容量

base = "NGD_ROW";
head_list = headname_gen(base);
writematrix(head_list,strcat(file_base_url,base,".xls"),'WriteMode','overwritesheet');
writematrix(storage_ROW_CH4_list(:,21:end),strcat(file_base_url,base,".xls"),'WriteMode','append');%1-81列表示2020-2100年，每行表示ROW的每个basin的容量
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%删除了excel里面前20列，只保留2020-2100年数据%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 计算Depleted Gas Basins
%%首先需要计算截至某年累计生产的天然气量
%先计算US的
US_produced_list = zeros(size(US_Gas_data,1),81);%从2020年开始，到2100年
for i = 1:81
    RP_ratio = -0.175*(i-1) + 50;%需要用到RP_ratio
    if i == 1
        US_produced_list(:,1) = UStile_yearly_table(:,end)/1e6;%2020年数据直接可获取，转换单位为十亿立方英尺
    end
    if i > 1
        if mod(i,5)==1
            produced = rem_US_matrix(1,i)/RP_ratio;
        else
            produced = rem_US_matrix(1,i+19)-rem_US_matrix(1,i+20);
        end
        US_produced_list(:,i) = US_produced_list(:,i-1)+produced;
    end
end
%再计算ROW的
ROW_produced_list = zeros(size(ROW_Gas_data,1),101);%从2000年开始，到2100年
for i = 1:101
    %需要用到RP_ratio
    if i <=21
        RP_ratio = 50;
    end
    if i > 21
        RP_ratio = -0.175*(i-21) + 50;%储采比i = 1为2000年，i = 51为2050年
    end

    if i == 1
        ROW_produced_list(:,1) = ROW_Gas_data(:,2);%2020年数据直接可获取，单位十亿立方英尺
    end
    if i > 1
        if mod(i,5)==1
            produced = rem_ROW_matrix(:,i)/RP_ratio;
        else
            produced = rem_ROW_matrix(:,i-1)-rem_ROW_matrix(:,i);
        end
        ROW_produced_list(:,i) = ROW_produced_list(:,i-1)+produced;
    end
end
%计算Storage in Depleted Gas Basins
S = [0.4,0.6,0.8];%空间占比参数
storage_US_Dpl_Gas_list = zeros(size(US_Gas_data,1),81);%存放最佳估计的EOR潜力，下标1代表2020年
storage_ROW_Dpl_Gas_list = zeros(size(ROW_Gas_data,1),81);%存放最佳估计的EOR潜力，下标1代表2020年
for i = 1:81
    cap_US = effe_ratio*Ratio(level)*1.98*0.028317/1000*US_produced_list(:,i);%单位Gt CO2
    storage_US_Dpl_Gas_list(:,i) = cap_US;
    cap_ROW = effe_ratio*Ratio(level)*1.98*0.028317/1000*ROW_produced_list(:,i);%单位Gt CO2
    storage_ROW_Dpl_Gas_list(:,i) = cap_ROW;
end
base = "Dpl_Gas_US";
head_list = headname_gen(base);
writematrix(head_list,strcat(file_base_url,base,".xls"),'WriteMode','overwritesheet');
writematrix(storage_US_Dpl_Gas_list,strcat(file_base_url,base,".xls"),'WriteMode','append');%1-81列表示2020-2100年，每行表示US的每个tile的容量

base = "Dpl_Gas_ROW";
head_list = headname_gen(base);
writematrix(head_list,strcat(file_base_url,base,".xls"),'WriteMode','overwritesheet');
writematrix(storage_ROW_Dpl_Gas_list,strcat(file_base_url,base,".xls"),'WriteMode','append');%1-81列表示2020-2100年，每行表示US的每个tile的容量

