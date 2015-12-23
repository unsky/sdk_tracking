function feats = extractfeature(frame, rects)

nfeat = size(rects,1);

if size(frame,3)>1
    frame = rgb2gray(frame);
end
frame = single(frame);

crop = frame( rects(1,2):rects(1,2)+rects(1,4), rects(1,1):rects(1,1)+rects(1,3) );
feat = fhog(crop, 8);

feat = feat(:)';
feats = zeros(nfeat, length(feat));
feats(1,:) = feat;

for i = 2:nfeat
    crop = frame( rects(i,2):rects(i,2)+rects(i,4), rects(i,1):rects(i,1)+rects(i,3) );
    feat = fhog(crop, 8);
    feats(i,:) = feat(:)';
end

end