function [data, param] = afmd_read_prev(filename, filetype, prevtype)
%afmd_read 读取文件 并预览形貌图像
%   输入 ： filename 文件名
%           filetype 文件类型，可选'matrix', 'afm_ar', 默认为'afm_ar'
%           prevtype 预览图像类型，暂默认且只能为'vzf'，即预览形貌图像
%   输出 ： data 结构体
%           param 结构体， 扫描参数
%   example : [data, param] = afmd_read('20191114_164921.data', 'afm_ar');
%   by 王超 20200318

    if nargin < 3
        prevtype = 'vzf';
    end
    
    if nargin < 2
        filetype = 'afm_ar';
    end
    
    [data, param] = afmd_read(filename, filetype);
    
    if strcmp(prevtype, 'vzf')
        prev_img = afmd_level(data.vz_f);
        afmd_imshow(prev_img, 11, 'nm');
%    elseif strcmp(prevtype, 's.th')
    else
        disp 'unsupported prevtype'
    end
    
end

