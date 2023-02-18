%% 先写ROW的
%EOR
base_url = "C:\Users\frankfeng1223\Desktop\Graduation_Design_Data\DataFile\result\";
region_url = ["ROW","US"];
type_url = ["EOR","Dpl_Oil","NGD","Dpl_Gas"];

for j = 1:2
    for i = 1:4
        url = strcat(base_url,type_url(i),"_",region_url(j),".xls");
        data = readmatrix(url);%函数自动了去除第一行
        sum_data = sum(data);
        writematrix(sum_data,strcat(base_url,'storage_summary',".xls"),'WriteMode','append');
    end
end
%先写入单独的数据
filedata = readmatrix("C:\Users\frankfeng1223\Desktop\Graduation_Design_Data\DataFile\result\storage_summary.xls");
EOR = 





