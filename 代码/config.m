% 路径设置

pathimg = [ 'C:\Users\shuai\Desktop\崔绿叶+陈帅+贺辉\数据\basketball\img\'];
pathanno = ['C:\Users\shuai\Desktop\崔绿叶+陈帅+贺辉\数据\basketball\groundtruth_rect.txt'];

imfiles = dir([pathimg '*.jpg']);
nframe = length(imfiles);

anno = dlmread(pathanno);
rect = anno(1,:);
nparticle=30;

% 采样参数

sigxy = [8 8];
ntrain =100;

% 特征参数

sbin = 8;

% 更新参数

learnrate = 0.1;

% 回归参数

ncascade = 3;


