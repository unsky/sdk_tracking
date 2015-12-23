function R = linearregress(Y, X, lambda)

if ~exist('lambda','var')
    lambda = 0.005;
end

dimfeat   = size(X,2);
dimresponse  = size(Y,2);

R = zeros(dimfeat, dimresponse);
param = sprintf('-s 12 -p 0 -c %f -q', lambda);

for i = 1 : dimresponse
    model = train(Y(:,i), sparse(X), param);
    R(:,i) = model.w';
end

end
