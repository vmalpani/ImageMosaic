function stitched_img = stitchImg(varargin)
%{ 
    Author : Vaibhav Malpani 
    Image Stitching
%}
time = tic();
ransac_n = 500; % Max number of iteractions
ransac_eps = 2; %Acceptable alignment error

if (~isempty(varargin))
    num_images = length(varargin);
    base_img = varargin{1};
else
    display('No arguments passed.')
end

display('Stiching Images...')
display('Please wait...')
base_ht = size(base_img,1);
base_wd = size(base_img,2);

% min x, max x, min y, max y
boundingBox = [1 base_wd 1 base_ht];
homographies = zeros(3,3,num_images);
homographies(:,:,1) = eye(3);
for i = 2 : num_images
    src_img_ht = size(varargin{i},1);
    src_img_width = size(varargin{i},2);
    
    [xs, xd] = genSIFTMatches(varargin{i},base_img);
    
    [~, H_3x3] = runRANSAC(xs, xd, ransac_n, ransac_eps);
    homographies(:,:,i) = H_3x3;
    
    boundingBoxSource = [1 1;src_img_width 1;1 src_img_ht;src_img_width src_img_ht];
    baseImageBoundingBox = applyHomography(H_3x3,boundingBoxSource);
    minCoords = min(baseImageBoundingBox);
    maxCoords = max(baseImageBoundingBox);
    
    boundingBox = [ ceil(min(boundingBox(1), minCoords(1))) ...
        ceil(max(boundingBox(2), maxCoords(1))) ...
        ceil(min(boundingBox(3), minCoords(2))) ...
        ceil(max(boundingBox(4), maxCoords(2))) ];
end

xOffsetBase = 1 - boundingBox(1);
yOffsetBase = 1 - boundingBox(3);

dest_canvas_width_height = [1+boundingBox(2) - boundingBox(1) 1+boundingBox(4) - boundingBox(3)];

translation_matrix = eye(3);
translation_matrix(1,3) = xOffsetBase;
translation_matrix(2,3) = yOffsetBase;

all_imgs = cell(1,num_images);
mask = cell(1,num_images);
for i = 1 : num_images
    translate_homographies = translation_matrix*homographies(:,:,i);
    translate_homographies = inv(translate_homographies);
    [mask{i}, all_imgs{i}] = backwardWarpImg(varargin{i}, translate_homographies, dest_canvas_width_height);
    figure, imshow(all_imgs{i})
end

stitched_img = all_imgs{1};
tmp_mask = mask{1};
for i = 2:num_images
    stitched_img = blendImagePair(stitched_img, im2uint8(tmp_mask).*255, all_imgs{i}, im2uint8(mask{i}).*255, 'blend');
    tmp_mask = tmp_mask | mask{i};
end

display('Stitching Completed...!');
toc(time);
end