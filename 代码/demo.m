clc;
clear;
close all;
addpath(genpath('dependency'));
addpath('utils');
warning off;

config;

for t = 1:nframe
    frame = imread( [pathimg, imfiles(t).name] );
    if t == 1
        % 采样样本，学习层次回归模型
        rects = repmat(rect, ntrain, 1);
        rects(:,1:2) = rects(:,1:2) + randn(ntrain, 2) .* repmat(sigxy, ntrain, 1);
        R = cell(ncascade, 1);
        for i = 1:ncascade
            feats = extractfeature(frame, rects);
            delrects = bsxfun(@minus, rects, rect);
            wx = linearregress(delrects(:,1), feats);
            wy = linearregress(delrects(:,2), feats);
            rects(:,1:2) = rects(:,1:2) - feats *[wx wy];
           
            overlap = overlaprate(rects, rect);
            ro =linearregress(overlap, feats);
            R{i} = [wx wy ro];
        end
    else
        % 预测目标位置
        rects=repmat(rect,nparticle,1);
        rects(:,1:2)=rects(:,1:2)+randn(nparticle,2).*repmat(sigxy,nparticle,1);
        weight = ones(nparticle,1);
        for i = 1:ncascade
            feats= extractfeature(frame,rects);
            rects(:,1:2)=rects(:,1:2)-feats*R{i}(:,1:2);
            weight = feats * R{i}(:,3) .* weight;
        end

        w=dominantset(rects(:,1:2),weight);
        rect=w' * rects;
        
        % 更新回归模型
        rects = repmat(rect, ntrain, 1);
        rects(:,1:2) = rects(:,1:2) + randn(ntrain, 2) .* repmat(sigxy, ntrain, 1);
        R_new = cell(ncascade, 1);
        for i = 1:ncascade
            feats = extractfeature(frame, rects);
            delrects = bsxfun(@minus, rects(:,1:2), rect(1:2));
            wx = linearregress(delrects(:,1), feats);
            wy = linearregress(delrects(:,2), feats);
            rects(:,1:2) = rects(:,1:2) - feats * [wx wy];
            overlap = overlaprate(rects, rect);
            ro = linearregress(overlap, feats);
            R_new{i} = [wx wy ro];
            R{i} = learnrate * R_new{i} + (1 - learnrate) * R{i};
        end
    end
     % 显示结果
    if t == 1
        handleim = imshow(frame);
        handlerect = rectangle('Position', rect, 'edgecolor', 'r', 'linewidth', 3);
    else
        set(handleim, 'CData', frame);
        set(handlerect, 'Position', rect);
    end
    drawnow;
end