function overlap = overlaprate(rects, rect)

n = size(rects,1);

left_tracker = rects(:,1);
bottom_tracker = rects(:,2);
right_tracker = left_tracker + rects(:,3) - 1;
top_tracker = bottom_tracker + rects(:,4) - 1;

left_anno = repmat(rect(1), n,1);
bottom_anno = repmat(rect(2), n,1);
right_anno = left_anno + repmat(rect(3), n,1) - 1;
top_anno = bottom_anno + repmat(rect(4), n,1) - 1;

tmp = (max(0, min(right_tracker, right_anno) - max(left_tracker, left_anno)+1 )) .* (max(0, min(top_tracker, top_anno) - max(bottom_tracker, bottom_anno)+1 ));
area_tracker = rects(:,3) .* rects(:,4);
area_anno = rect(:,3) .* rect(:,4);
overlap = tmp./(area_tracker+area_anno-tmp);

end