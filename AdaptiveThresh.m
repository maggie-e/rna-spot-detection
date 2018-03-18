function [bin, sensitivity, num_spots, spots_found, img_mask] = AdaptiveThresh(img)
%Performs locally adaptive thresholding on input image.
%Iterates over possible sensitivity factors to find the
%sensitivity value where the number of spots found changes
%the least, indicating a threshold where the foreground pixels
%are most stable. Returns the binarized image, sensitivity factor,
%and the number of spots identified.
sensitivity_factors = 0:0.05:1;
spots_found = zeros(1, length(sensitivity_factors));
for i=1:length(sensitivity_factors)
    bin_img = imbinarize(img, 'adaptive', 'Sensitivity', sensitivity_factors(i));
    [~, N] = bwlabel(bin_img);
    spots_found(i) = N;
end
min_difference = Inf;
min_index = 0;
for j=1:length(spots_found)-1
    difference = abs(spots_found(j+1)-spots_found(j));
    if difference < min_difference
        min_difference = difference;
        min_index = j+1;
    end
end
bin = imbinarize(img, 'adaptive', 'Sensitivity', sensitivity_factors(min_index));
sensitivity = sensitivity_factors(min_index);
num_spots = spots_found(min_index);
%Limit locally adaptive thresholding to
%areas with some minimum variance 
%to reduce amplification of background noise.
img_mask = im2double(img);
[height, width] = size(img_mask);
window_width = 10;
window_height = 10;
local_var_thresh = 0.00001;
for row = 1:height/window_height
    for col = 1:width/window_width
        in_cols = max(1,(col-1)*window_width+1) : min(width,col*window_width); 
        in_rows = max(1,(row-1)*window_height+1) : min(height,row*window_height);
        in_tile = img_mask(in_rows, in_cols);
        local_var = std(in_tile(:))^2;
        if local_var > local_var_thresh
            img_mask(in_rows, in_cols) = ones(size(in_tile));
        else
            img_mask(in_rows, in_cols) = zeros(size(in_tile));
        end
    end
end
bin = bin.*img_mask;
end

