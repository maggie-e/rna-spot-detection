function [bin] = GraphCutSegment(img)
% This method uses GraphCut, a wrapper function
% for MATLAB of an algorithm implemented in C
% by image processing researchers (cited in paper and
% listed in GraphCut.m comments). We define a data cost 
% function around the mean intensity and a weighted
% smoothness cost for neighboring pixels.
% The binarized image is returned.
data_cost = zeros(2, size(img, 1)*size(img, 2));
cost_one = (img > graythresh(img));
cost_zero = (img < graythresh(img));
data_cost(1, :) = reshape(cost_one, 1, size(img, 1)*size(img, 2));
data_cost(2, :) = reshape(cost_zero, 1, size(img, 1)*size(img, 2));
smoothness_cost = [0, 1; 1 0];
sparse_smoothness = sparse(size(img, 1)*size(img, 2), size(img, 1)*size(img, 2));
gch = GraphCut('open', data_cost, smoothness_cost, sparse_smoothness);
[gch, bin] = GraphCut('expand', gch);
bin = reshape(bin, size(img, 1), size(img, 2));
gch = GraphCut('close', gch);
end

