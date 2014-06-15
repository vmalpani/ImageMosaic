function test_out_pts_nx2 = applyHomography(H_3x3, test_pts_nx2)
%{ 
    Author : Vaibhav Malpani 
    Image Stitching
%}
    num_pts = size(test_pts_nx2,1);
    homogeneous_coords = ones(num_pts,3);
    homogeneous_coords(:,1:2) = test_pts_nx2;
    homogeneous_coords = homogeneous_coords';
    out = H_3x3*homogeneous_coords;
    out(2,:) = out(2,:)./out(3,:);
    out(1,:) = out(1,:)./out(3,:);
    test_out_pts_nx2 = out(1:2,:)';
end