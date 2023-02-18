clc;
clear;

%% 获取所有的X坐标
base_url = ".\origin_data\US_";
X_all = [];%存放single_X
for i=2000:2020
    url = strcat(base_url,num2str(i),".xls");
    opts = detectImportOptions(url);
    opts.SelectedVariableNames = [9];
    single_X = readmatrix(url,opts);
    X_all = [X_all;single_X];
end
X_list = unique(X_all);%获取所有的X坐标的升序排列，以便构建填值表

%% 构建一个表格存放每个tile每年及总的数据
UStile_yearly_table = zeros(length(X_list),23);
UStile_yearly_table(:,1) = X_list;

%% 依次读取每个xls文件，将数据填入UStile_yearly_table
count = 1;%先填写UStile_yearly_table的第二列（2000年的数据）
for i=2000:2020
    url = strcat(base_url,num2str(i),".xls");
    opts = detectImportOptions(url);
    opts.SelectedVariableNames = [4,9];
    single_year_data = readmatrix(url,opts);
    count = count+1;%填写下一列
    for j = 1:size(single_year_data,1)
        X = single_year_data(j,2);
        index = find(X_list==X);%寻找X坐标对应X_list的第几行，方便对行入座
        UStile_yearly_table(index,count) = single_year_data(j,1);
    end
end

%% 读取US_total文件，填入总产量
url = strcat(base_url,"total",".xls");
opts = detectImportOptions(url);
opts.SelectedVariableNames = [3,7];
total_data = readmatrix(url,opts);
for j = 1:size(total_data,1)
    X = total_data(j,2);
    index = find(abs(X_list-X)<=1e-6);%寻找X坐标对应X_list的第几行，方便对行入座
    if ~isempty(index)
        UStile_yearly_table(index,end) = total_data(j,1);
    end
end
UStile_yearly_table(find(isnan(UStile_yearly_table)==1)) = 0;%将NaN改为0

% %% 获得开采率矩阵
% UStile_yearly_rate_table = UStile_yearly_table;
% for i = 1:length(X_list)
%     if UStile_yearly_table(i,end) ~= 0
%         for j = 2:22
%             UStile_yearly_rate_table(i,j) = UStile_yearly_table(i,j)/UStile_yearly_table(i,end);
%         end
%     end
% end

% %% 获取2000-2020每年平均开采率
% rate_list = zeros(1,21);
% for i = 2:22
%     A1 = UStile_yearly_rate_table(:,i);
%     rate_list(1,i-1) = mean(A1(find(A1~=0)));
% end
% %拟合一条折线，发现有一定的相关性