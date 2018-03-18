function [best_bin, best_k] = KMeansSegment(img)
%Performs K-means segmentation on input image.
%Chooses K by computing the variance of the 
%spots identified at different values
%K = 2, 3, 4...and selecting the 
%parameter where the area of the spots
%varies the least.
cc_var = Inf;
best_k = 1;
best_bin = zeros(size(img));
for k=2:10
    img = im2double(img);
    vec = reshape(img,size(img,1)*size(img,2), 1);
    % Initialize random cluster centers
    centers = vec(ceil(rand(k,1)*size(vec,1)) ,:);        
    dists_labels = zeros(size(vec,1),k+2);                        
    num_iters = 10;                                  
    for n = 1:num_iters
       for i = 1:size(vec,1)
          for j = 1:k  
            dists_labels(i,j) = norm(vec(i,:) - centers(j,:));      
          end
          [dist, closest] = min(dists_labels(i,1:k));                 
          dists_labels(i,k+1) = closest;                                
          dists_labels(i,k+2) = dist;                          
       end
       for i = 1:k
          cluster_points = (dists_labels(:,k+1) == i);                         
          centers(i,:) = mean(vec(cluster_points,:));
          % In case of NaN centers, reassign random point
          if sum(isnan(centers(:))) ~= 0                    
             nan_center = find(isnan(centers(:,1)) == 1);           
             for index = 1:size(nan_center,1)
             centers(nan_center(index),:) = vec(randi(size(vec,1)),:);
             end
          end
       end
    end
    bin_vec = zeros(size(vec));
    for i = 1:k
        index = find(dists_labels(:,k+1) == i);
        bin_vec(index,:) = repmat(centers(i,:),size(index,1),1); 
    end
    bin = reshape(bin_vec,size(img,1),size(img,2),1);
    bin = (bin == max(max(bin)));
    [labeled, ~] = bwlabel(bin);
    props = regionprops(labeled, 'area');
    if var([props.Area]) < cc_var
       cc_var = var([props.Area]);
       best_bin = bin;
       best_k = k;
    end
end
end