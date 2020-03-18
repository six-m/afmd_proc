function [data, param] = afmd_read_prev(filename, filetype, prevtype)
%afmd_read ��ȡ�ļ� ��Ԥ����òͼ��
%   ���� �� filename �ļ���
%           filetype �ļ����ͣ���ѡ'matrix', 'afm_ar', Ĭ��Ϊ'afm_ar'
%           prevtype Ԥ��ͼ�����ͣ���Ĭ����ֻ��Ϊ'vzf'����Ԥ����òͼ��
%   ��� �� data �ṹ��
%           param �ṹ�壬 ɨ�����
%   example : [data, param] = afmd_read('20191114_164921.data', 'afm_ar');
%   by ���� 20200318

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

