# afmd_proc: 快速处理AFM数据Matlab小工具库

本项目旨在为快速读取和处理AFM数据提供Matlab函数或脚本。

仅供南开大学人工智能学院微纳系统控制实验室使用。

afmd 是 Atomic Force Microscope Data 的缩写， proc是process的缩写。

## 当前支持的功能

1. 读取自研上位机软件AFM_AR保存的原始数据
2. 读取以矩阵形式保存的ASCII字符文本，分隔符需为空格
3. 对形貌图像进行去斜面去Z轴漂移处理
4. 自动将图像数据调整为可供显示的范围并显示

## 安装

1. clone 或 下载本项目后解压
2. 将 ./lib目录加入Matlab路径
3. enjoy it!

## 使用

键入以下代码以查看帮助
```Matlab
help afmd_read
help afmd_level
help afmd_imshow
```

### afmd_read

函数原型： function [data, param] = afmd_read(filename, filetype)
```
afmd_read 读取文件
输入 ： filename 文件名
       filetype 文件类型，可选'matrix', 'afm_ar', 默认为'afm_ar'
输出 ： data 结构体
       param 结构体， 扫描参数
example : [data, param] = afmd_read('20191114_164921.data');
```

### afmd_level

函数原型： function [leveled_topo] = afmd_level(topography, method, std_thres)
```
afmd_level 对形貌图像进行level操作(去漂移与去斜面)
输入： 	topography  原始形貌图像
      	method  level方法，可选 'linefit', 'subfit'(仅拟合基底，参考《提高原子力显微镜成像性能的若干方法研究》 2.4节)
      	std_thres  标准差阈值，使用'subfit'时使用
输出 ： 	leveled_toop level后的形貌图像
example: leveled_topo = afmd_level(topo) % 默认使用'linefit'
         leveld_topo = afmd_level(topo,'subfit') % 默认std_thres 为0.01
```

### afmd_imshow

函数原型： function [] = afmd_imshow(image, fig_id, colorbar_title, colormap)
```
afmd_imshow 自动对z轴数据缩放以显示图像
输入： 	image 显示图像
     	fig_id 显示图像窗口id, 默认为1
     	colorbar_title 标尺单位, 默认为'unknown'
     	colormap 3*m矩阵，颜色查找表,默认为copper
example:  afmd_imshow(image)
```

## 如何贡献代码？

测试完成后联系我merge到master分支。
