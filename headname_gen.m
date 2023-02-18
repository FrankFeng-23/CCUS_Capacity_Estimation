function headname_list = headname_gen(base)
%HEADNAME_GEN 生成每个结果表xls的列名
%   此处显示详细说明
    headname_list = [];
    for i = 2020:2100
        headname = strcat(base,"_",num2str(i));
        headname_list = [headname_list,headname];
    end
end

