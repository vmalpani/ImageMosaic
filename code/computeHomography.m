function H_3x3 = computeHomography(src_pts_nx2, dest_pts_nx2)
%{ 
    Author : Vaibhav Malpani 
    Image Stitching
%}
num_pts = size(src_pts_nx2,1);

if (size(src_pts_nx2) ~= size(dest_pts_nx2))
    error('Unequal number of source and destination points!');
end

if (num_pts < 4)
    error('Less tH_han 4 points passed!');
end

A = zeros(2*num_pts, 9);

for i = 1:num_pts
    A(2*(i-1)+1,1:3) = [src_pts_nx2(i,:),1];
    A(2*(i-1)+1,7:9) = -1*dest_pts_nx2(i,1)*[src_pts_nx2(i,:),1];
    A(2*(i-1)+2,4:6) = [src_pts_nx2(i,:),1];
    A(2*(i-1)+2,7:9) = -1*dest_pts_nx2(i,2)*[src_pts_nx2(i,:),1];
end

A_pseudo_inverse = A'*A;

[V,D] = eig(A_pseudo_inverse);
H_3x3 = [V(1:3,1)';V(4:6,1)';V(7:9,1)'];
end