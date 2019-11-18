function [leveled_topo] = afmd_level(topography, method, std_thres)
%afmd_level 对形貌图像进行level操作(去漂移与去斜面)
%   输入： topography  原始形貌图像
%          method  level方法，可选 'linefit', 'subfit'(仅拟合基底，参考任逍师兄论文)
%          std_thres  标准差阈值，使用'subfit'时使用
%   输出 ： leveled_toop level后的形貌图像
%   example: leveled_topo = afmd_level(topo) % 默认使用'linefit'
%              leveld_topo = afmd_level(topo,'subfit') % 默认std_thres 为0.01
%   by 王超 20191118
    if nargin < 2
        method = 'linefit';
        std_thres = 0.01;
    elseif nargin < 3
        std_thres = 0.01;
    end
    
    sz = size(topography);
    leveled_topo = zeros(sz);
    
    % 基底拟合
    if strcmp(method, 'subfit')
        for i = 1:sz(1)
            % 对每两个相邻点计算斜率和偏差
            for j = 1:sz(2)-1
                slope(j) = topography(i,j+1) - topography(i,j) ;
                off(j) = (j+1)*topography(i,j) - j*topography(i,j+1);
            end
            % 归一化
            slope_norm = sqrt(sum(slope.^2));
            slope = slope/slope_norm;
            off_norm = sqrt(sum(off.^2));
            off = off/off_norm;
            pt(1,:) = slope;
            pt(2,:) = off;
            % 迭代去除偏远值直至方差小于阈值
            std_pt = mean(std(pt,0,2));
            while std_pt > std_thres
                mean_pt = mean(pt, 2);
                distance = pt - mean_pt;
                distance = sqrt(distance(1,:).^2 + distance(2,:).^2);
                [~, max_idx] = max(distance);
                pt(:, max_idx) = [];
                std_pt = mean(std(pt,0,2));
            end
            % 计算基底直线
            mean_pt = mean(pt, 2);
            mean_slope = mean_pt(1) * slope_norm;
            mean_off = mean_pt(2) * off_norm;
            clear pt;
            % 去除斜面
            idx = 1:sz(2);
            leveled_topo(i, :) = topography(i,:) - idx*mean_slope - mean_off;
            clear idx;
        end
    
    % 拟合
    elseif strcmp(method, 'linefit')
        for i = 1:sz(1)
            fit = polyfit(1:sz(2),topography(i,:),1);
            for j = 1:sz(2)
                leveled_topo(i,j) = topography(i,j) - (fit(1)*j + fit(2));
            end
        end
    end
    
end

