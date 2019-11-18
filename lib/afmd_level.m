function [leveled_topo] = afmd_level(topography, method, std_thres)
%afmd_level ����òͼ�����level����(ȥƯ����ȥб��)
%   ���룺 topography  ԭʼ��òͼ��
%          method  level��������ѡ 'linefit', 'subfit'(����ϻ��ף��ο�����ʦ������)
%          std_thres  ��׼����ֵ��ʹ��'subfit'ʱʹ��
%   ��� �� leveled_toop level�����òͼ��
%   example: leveled_topo = afmd_level(topo) % Ĭ��ʹ��'linefit'
%              leveld_topo = afmd_level(topo,'subfit') % Ĭ��std_thres Ϊ0.01
%   by ���� 20191118
    if nargin < 2
        method = 'linefit';
        std_thres = 0.01;
    elseif nargin < 3
        std_thres = 0.01;
    end
    
    sz = size(topography);
    leveled_topo = zeros(sz);
    
    % �������
    if strcmp(method, 'subfit')
        for i = 1:sz(1)
            % ��ÿ�������ڵ����б�ʺ�ƫ��
            for j = 1:sz(2)-1
                slope(j) = topography(i,j+1) - topography(i,j) ;
                off(j) = (j+1)*topography(i,j) - j*topography(i,j+1);
            end
            % ��һ��
            slope_norm = sqrt(sum(slope.^2));
            slope = slope/slope_norm;
            off_norm = sqrt(sum(off.^2));
            off = off/off_norm;
            pt(1,:) = slope;
            pt(2,:) = off;
            % ����ȥ��ƫԶֱֵ������С����ֵ
            std_pt = mean(std(pt,0,2));
            while std_pt > std_thres
                mean_pt = mean(pt, 2);
                distance = pt - mean_pt;
                distance = sqrt(distance(1,:).^2 + distance(2,:).^2);
                [~, max_idx] = max(distance);
                pt(:, max_idx) = [];
                std_pt = mean(std(pt,0,2));
            end
            % �������ֱ��
            mean_pt = mean(pt, 2);
            mean_slope = mean_pt(1) * slope_norm;
            mean_off = mean_pt(2) * off_norm;
            clear pt;
            % ȥ��б��
            idx = 1:sz(2);
            leveled_topo(i, :) = topography(i,:) - idx*mean_slope - mean_off;
            clear idx;
        end
    
    % ���
    elseif strcmp(method, 'linefit')
        for i = 1:sz(1)
            fit = polyfit(1:sz(2),topography(i,:),1);
            for j = 1:sz(2)
                leveled_topo(i,j) = topography(i,j) - (fit(1)*j + fit(2));
            end
        end
    end
    
end

