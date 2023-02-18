clc;
clear;
%获取US的ojectid,以便进行arcgis表链接

base_url = "C:\Users\frankfeng1223\Desktop\Graduation_Design_Data\DataFile\US_";
url1 = strcat(base_url,"total",".xls");
opts = detectImportOptions(url1);
opts.SelectedVariableNames = [1,7];
total_data = readmatrix(url1,opts);

url2="C:\Users\frankfeng1223\Desktop\Graduation_Design_Data\DataFile\result\EOR_US.xls";
opts = detectImportOptions(url2);
opts.SelectedVariableNames = 102;%读取X坐标列
result_data = readmatrix(url2,opts);
result_data = result_data(2:end,:);%去除第一行

index_list = zeros(size(result_data,1),1);%记录索引
for i = 1:size(result_data,1)
    flag_matrix = total_data - result_data(i);
    flag_matrix = flag_matrix(:,2);
    index = find(abs(flag_matrix)<=1e-8);%matlab中的索引
    index_mat = total_data(index,1);%表格对应的真实索引
    index_list(i) = index_mat;
end

