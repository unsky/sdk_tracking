% ·������

pathimg = [ 'C:\Users\shuai\Desktop\����Ҷ+��˧+�ػ�\����\basketball\img\'];
pathanno = ['C:\Users\shuai\Desktop\����Ҷ+��˧+�ػ�\����\basketball\groundtruth_rect.txt'];

imfiles = dir([pathimg '*.jpg']);
nframe = length(imfiles);

anno = dlmread(pathanno);
rect = anno(1,:);
nparticle=30;

% ��������

sigxy = [8 8];
ntrain =100;

% ��������

sbin = 8;

% ���²���

learnrate = 0.1;

% �ع����

ncascade = 3;


