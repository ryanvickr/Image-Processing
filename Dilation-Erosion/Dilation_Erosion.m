im = imread('blobs.png');

% Create structuring element
SE = strel('square', 5);

% Perform dilation
im_dilate = imdilate(im, SE);

% display both side-by-side
subplot(1,2,1), imshow(im)
subplot(1,2,2), imshow(im_dilate)