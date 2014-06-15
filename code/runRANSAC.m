function [inliers_id, H] = runRANSAC(Xs, Xd, ransac_n, eps)
%{ 
    Author : Vaibhav Malpani 
    Image Stitching
%}
max_num_inliers = 0;
% num_pts = size(Xs,1);
% mse_arr = [];
% src_pts = zeros(4,2);
% dest_pts = zeros(4,2);

display('Running RANSAC')
for i = 1:ransac_n
    idx = randperm(size(Xs,1),4);
    src_pts = Xs(idx,:);
    dest_pts = Xd(idx,:);
    
    H_temp = computeHomography(src_pts, dest_pts);
    out_pts = applyHomography(H_temp, Xs);

    mse = sqrt(sum(((out_pts-Xd).^2),2));
%     mse_arr = [mse_arr mse];
    [row,~,~] = find(mse < eps);
    temp_inliers_count = size(row,1);

    if temp_inliers_count > max_num_inliers
        inliers_id = row;
        H = H_temp;
        max_num_inliers = temp_inliers_count;
    end
end
display('RANSAC Converged. Homography in place.')
end