function [] = afmd_imshow(image, fig_id, colorbar_title, colormap)
% afmd_imshow 自动对z轴数据缩放以显示图像
%   输入： image 显示图像
%          fig_id 显示图像窗口id, 默认为1
%          colorbar_title 标尺单位, 默认为'unknown'
%          colormap 3*m矩阵，颜色查找表,默认为copper
%   example:  afmd_imshow(image)
%   by 王超 20191118
    if nargin < 4
        colormap = copper;
    end
    if nargin < 3
        colorbar_title = 'unknown';
    end
    if nargin < 2
        fig_id = 1;
    end
    
    figure(fig_id);
    data = image - min(min(image));
    imshow(data, 'DisplayRange',[min(min(data)), max(max(data))], 'Colormap', colormap);
    
    colorbar_positon = [0.82 0.175 0.04 0.745];
    h = colorbar('Position',colorbar_positon);
    set(get(h,'title'),'string',colorbar_title);
    
    set(gca,'fontSize',12);
    set(gca, 'fontName', 'Times New Roman');
end

