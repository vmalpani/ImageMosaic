function [mask, result_img] = backwardWarpImg(src_img, resultToSrc_H,...
    dest_canvas_width_height)
%{ 
    Author : Vaibhav Malpani 
    Image Stitching
%}
display('Backward Warping...')
wd_src = dest_canvas_width_height(1);
ht_src = dest_canvas_width_height(2);

[xi yi] = meshgrid( 1:wd_src, 1:ht_src );
xx = (resultToSrc_H(1,1)*xi+resultToSrc_H(1,2)*yi+resultToSrc_H(1,3))./(resultToSrc_H(3,1)*xi+resultToSrc_H(3,2)*yi+resultToSrc_H(3,3));
yy = (resultToSrc_H(2,1)*xi+resultToSrc_H(2,2)*yi+resultToSrc_H(2,3))./(resultToSrc_H(3,1)*xi+resultToSrc_H(3,2)*yi+resultToSrc_H(3,3));
result_img = zeros(ht_src,wd_src,3);
result_img(:,:,1) = (interp2(src_img(:,:,1),xx,yy,'*bilinear'));
result_img(:,:,2) = (interp2(src_img(:,:,2),xx,yy,'*bilinear'));
result_img(:,:,3) = (interp2(src_img(:,:,3),xx,yy,'*bilinear'));
result_img = im2uint8(result_img);
mask = ((result_img(:,:,3))>0);
end