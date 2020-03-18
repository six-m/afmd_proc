function [] = afmd_imshow(image, fig_id, colorbar_title, colormap)
% afmd_imshow �Զ���z��������������ʾͼ��
%   ���룺 image ��ʾͼ��
%          fig_id ��ʾͼ�񴰿�id, Ĭ��Ϊ1
%          colorbar_title ��ߵ�λ, Ĭ��Ϊ'unknown'
%          colormap 3*m������ɫ���ұ�,Ĭ��Ϊcopper
%   example:  afmd_imshow(image)
%   by ���� 20191118
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

