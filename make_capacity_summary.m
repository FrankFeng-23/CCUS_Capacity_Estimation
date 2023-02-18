%% 分别汇总US和ROW
for estimationLevel = 1:3
    dirNameList = ["low_estimation","medium_estimation","high_estimation"];
    %% 先写ROW的
    %EOR
    base_url = strcat(".\result_data\",dirNameList(estimationLevel),"\");
    region_url = ["ROW","US"];
    type_url = ["EOR","Dpl_Oil","NGD","Dpl_Gas"];

    for j = 1:2
        for i = 1:4
            url = strcat(base_url,type_url(i),"_",region_url(j),".xls");
            data = readmatrix(url);%函数自动了去除第一行
            sum_data = {strcat(type_url(i),"_",region_url(j)),sum(data)};
            if i*j==1
                writecell(sum_data,strcat(base_url,'capacity_summary',".xls"),'WriteMode','overwritesheet');
            else
                writecell(sum_data,strcat(base_url,'capacity_summary',".xls"),'WriteMode','append');
            end
        end
    end
end

%% 计算整合
type = ["EOR","Dpl_Oil","NGD","Dpl_Gas"];
for estimationLevel = 1:3
    for item = 1:4
    dirNameList = ["low_estimation","medium_estimation","high_estimation"];
    base_url = strcat(".\result_data\",dirNameList(estimationLevel),"\");
    url = strcat(base_url,"capacity_summary",".xls");
    data = readmatrix(url);
    data = data(:,2:end);
    total_sum_data = {type(item),data(item,:)+data(item+4,:)};
    writecell(total_sum_data,strcat(base_url,'capacity_summary',".xls"),'WriteMode','append');
    end
end


