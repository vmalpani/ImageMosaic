function out_img = blendImagePair(wrapped_imgs, masks, wrapped_imgd, maskd, mode)
%{ 
    Author : Vaibhav Malpani 
    Image Stitching
%}
height = size(wrapped_imgs, 1);
width = size(wrapped_imgs, 2);

if strcmp(mode, 'overlay')
    maskd = ~maskd;
    out_img = double(wrapped_imgs) .* cat(3, maskd, maskd, maskd) + double(wrapped_imgd);
end

if strcmp(mode,'blend')
%     mask = zeros(height,width);
%     mask(1,:) = 1;
%     mask(:,1) = 1;
%     mask(end,:) = 1;
%     mask(:,end) = 1;
    masks = ~ logical(masks);
    maskd = ~ logical(maskd);
    
    dst_fish =bwdist(masks);
    dst_fish = dst_fish./max(max(dst_fish));
%     figure, imshow(dst_fish)
    
    dst_horse =bwdist(maskd);
    dst_horse = dst_horse./max(max(dst_horse));
%     dst_horse = 1 - dst_horse;
%     figure,imshow(dst_horse)
    
    dst_total = dst_fish + dst_horse;
    nzidx = find(dst_total > 0);
    
    % convert to double type
    wrapped_imgs = double(wrapped_imgs);
    wrapped_imgd = double(wrapped_imgd);

    weightFish = 1 : -1/(width-1) : 0;
    weightFishMatrix = repmat(weightFish, size(wrapped_imgs, 1), 1);

    weightHorse = 1 - weightFish;
    weightHourseMatrix = repmat(weightHorse, size(wrapped_imgd, 1), 1);

    out_img = zeros(size(wrapped_imgs));
    for i = 1 : 3
%       out_img(:, :, i) = wrapped_imgs(:, :, i) .* weightFishMatrix + wrapped_imgd(:, :, i) .* weightHourseMatrix;
      out_img(:, :, i) = ((wrapped_imgs(:, :, i) .* dst_fish + wrapped_imgd(:, :, i) .* dst_horse));
    end
    
    red_channel = out_img(:,:,1);
    green_channel = out_img(:,:,2);
    blue_channel = out_img(:,:,3);
    
    red_channel(nzidx) = red_channel(nzidx)./dst_total(nzidx);
    green_channel(nzidx) = green_channel(nzidx)./dst_total(nzidx);
    blue_channel(nzidx) = blue_channel(nzidx)./dst_total(nzidx);
    
    out_img(:,:,1) = red_channel;
    out_img(:,:,2) = green_channel;
    out_img(:,:,3) = blue_channel;
end
out_img = uint8(out_img);
end