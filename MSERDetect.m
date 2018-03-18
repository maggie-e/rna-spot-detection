function [bin, num_spots] = MSERDetect(img)
%This method detects Maximally Stable Extremal 
%Regions (MSER) in the FISH images, as defined by
%their intensity and the outer border of each
%region. Because in testing the MSER algorithm
%tends to underdetect the RNA spots, we use 
%a low threshold delta parameter that identifies 
%a higher number of MSER regions and mark 
%those pixels with a 1.
bin = zeros(size(img));
[regions, ~] = detectMSERFeatures(img, 'ThresholdDelta', 0.1, 'RegionAreaRange', [5 100]);
spot_pixels = [];
for j=1:regions.Count
    spot_pixels = [spot_pixels; regions.PixelList{j}];
end
for j=1:length(spot_pixels)
    r = spot_pixels(j, 2);
    c = spot_pixels(j, 1);
    bin(r, c) = 1;
end
[~, num_spots] = bwlabel(bin);
end

