function startupFcn(app)
    app.cellArrayText{1} = sprintf('%s\n', '***此处输出信息提示***'); % 赋初值
    app.TextArea.Value=app.cellArrayText{1}; % 文本区域中的初始显示信息
end