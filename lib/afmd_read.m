function [data, param] = afmd_read(filename, filetype)
%afmd_read 读取文件
%   输入 ： filename 文件名
%           filetype 文件类型，可选'matrix', 'afm_ar', 默认为'afm_ar'
%   输出 ： data 结构体
%           param 结构体， 扫描参数
%   example : [data, param] = afmd_read('20191114_164921.data', 'afm_ar');
%   by 王超 20191118

    if nargin < 2
        filetype = 'afm_ar';
    end

    % 矩阵式数据
    if strcmp(filetype, 'matrix')
        raw_data = dlmread(filename);
        data = struct('raw_data', raw_data);
        param = struct();
    
    % 自研上位机数据
    elseif strcmp(filetype, 'afm_ar')
        raw_data = load(filename);
        [m,~] = size(raw_data);
        
        Z_V2X = 11680/24; %Z向电压-位移系数 nm/V
        ZS_V2X = 24380/24; %Z向位移传感器电压-位移系数 nm/V
        %SP_V2X = 130; %灵敏度 nm/V
        SP_V2X = 1; % 暂不启用灵敏度补偿
        
        if(mod(m,2)==0) %无文件头
            m = sqrt(m/2);
            idx_off = 0;
        else  %有文件头
            m = sqrt((m-1)/2);
            idx_off = 1;
            scan_param = raw_data(1,:);
        end
        
        %正向数据
        vz_data_f = zeros(m); %Z-Axis
        zs_data_f = zeros(m); %Z-Sensor
        topdown_data_f = zeros(m); %A-B Signal
        leftright_data_f = zeros(m); %C-D Signal
        z_err_data_f = zeros(m); %Z向控制误差
        %反向数据
        vz_data_b = zeros(m);
        zs_data_b = zeros(m);
        topdown_data_b = zeros(m);
        leftright_data_b = zeros(m);
        z_err_data_b = zeros(m);
        
        for i = 1:m
            %正向数据
            vz_data_f(i,:) = Z_V2X*raw_data((i-1)*m*2+1+idx_off:(i-1)*m*2+m+idx_off,1);
            zs_data_f(i,:) = ZS_V2X*raw_data((i-1)*m*2+1+idx_off:(i-1)*m*2+m+idx_off,2);
            topdown_data_f(i,:) = SP_V2X*raw_data((i-1)*m*2+1+idx_off:(i-1)*m*2+m+idx_off,3);
            leftright_data_f(i,:) = raw_data((i-1)*m*2+1+idx_off:(i-1)*m*2+m+idx_off,4);
            z_err_data_f(i,:) = SP_V2X*raw_data((i-1)*m*2+1+idx_off:(i-1)*m*2+m+idx_off,5);
            %反向数据
            vz_data_b(i,:) = Z_V2X*raw_data((i-1)*m*2+2*m+idx_off:-1:(i-1)*m*2+m+1+idx_off,1);
            zs_data_b(i,:) = ZS_V2X*raw_data((i-1)*m*2+2*m+idx_off:-1:(i-1)*m*2+m+1+idx_off,2);
            topdown_data_b(i,:) = SP_V2X*raw_data((i-1)*m*2+2*m+idx_off:-1:(i-1)*m*2+m+1+idx_off,3);
            leftright_data_b(i,:) = raw_data((i-1)*m*2+2*m+idx_off:-1:(i-1)*m*2+m+1+idx_off,4);
            z_err_data_b(i,:) = SP_V2X*raw_data((i-1)*m*2+2*m+idx_off:-1:(i-1)*m*2+m+1+idx_off,5);
        end
        
        data = struct('vz_f', vz_data_f, 'zs_f', zs_data_f, 'topdown_f', topdown_data_f, 'leftright_f', leftright_data_f, 'z_err_f',z_err_data_f,'vz_b', vz_data_b, 'zs_b', zs_data_b, 'topdown_b', topdown_data_b, 'leftright_b', leftright_data_b, 'z_err_b',z_err_data_b);
        param = struct('fpga_mode', scan_param(1), 'width', scan_param(2), 'height', scan_param(3), 'point_number',scan_param(4), 'frequency',scan_param(5));
    
    % 文件类型不支持
    else
        data = struct();
        param = struct();
    end
    
end

