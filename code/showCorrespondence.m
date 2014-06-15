function result_img = ...
    showCorrespondence(orig_img, warped_img, test_pts_nx2, test_out_pts_nx2)
    num_pts = size(test_pts_nx2,1);
    concat_img = [orig_img, warped_img];
    shift_horizontal = size(orig_img,2);
    shifted_img_x = test_out_pts_nx2(:,1)+shift_horizontal;
    fh1 = figure;
    imshow(concat_img);
    hold on
    plot(test_pts_nx2(:,1),test_pts_nx2(:,2),'*');
    plot(shifted_img_x,test_out_pts_nx2(:,2),'*');
    for i = 1:num_pts
        plot([test_pts_nx2(i,1) shifted_img_x(i,1)],[test_pts_nx2(i,2) test_out_pts_nx2(i,2)],'r');
    end
    hold off
    result_img = saveAnnotatedImg(fh1);
end

function annotated_img = saveAnnotatedImg(fh)
figure(fh); % Shift the focus back to the figure fh

% The figure needs to be undocked
set(fh, 'WindowStyle', 'normal');

% The following two lines just to make the figure true size to the
% displayed image. The reason will become clear later.
img = getimage(fh);
truesize(fh, [size(img, 1), size(img, 2)]);

% getframe does a screen capture of the figure window, as a result, the
% displayed figure has to be in true size.
frame = getframe(fh);
frame = getframe(fh);
pause(0.5);
% Because getframe tries to perform a screen capture. it somehow
% has some platform depend issues. we should calling
% getframe twice in a row and adding a pause afterwards make getframe work
% as expected. This is just a walkaround.
annotated_img = frame.cdata;
end