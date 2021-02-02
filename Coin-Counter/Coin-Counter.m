% Coin Counting Code (Image B)

% Process the raw image to binary
im_raw = imread('IM1b_HW1.jpg');
im_gs = rgb2gray(im_raw); % convert to grayscale first
im_bw0 = imbinarize(im_gs); % get the binary image
im_bw = (im_bw0 == 0); % invert binary image

subplot(1,3,1), imshow(im_bw)

% Clean image so that we are left with blank disks
strelSize = 5;
SE = strel('disk', strelSize);
im = imclose(im_bw, SE);
im = imfill(im, 'holes');
subplot(1,3,2), imshow(im)

% clean the image until the correct number of elements are found
numCoins = -1;
closeIm = 0;
while numCoins < 16
    strelSize = strelSize + 1;
    
    % perform an erosion
    SE = strel('disk', strelSize);
    im = imerode(im, SE);
    
    % Label image and get areas of blobs:
    labeledImage = bwlabel(im, 8);
    stats = regionprops(im, 'Area');
    allBlobAreas = [stats.Area];
    
    % check if we have eroded far enough
    szBlobAreas = size(allBlobAreas);
    numCoins = szBlobAreas(2);
end

% perform one final erosion using a different shape
strelSize = strelSize + 1;
SE = strel('octagon', strelSize);
im = imerode(im, SE);
imshow(im)

% perform some dilations now to increase blob size
strelSize = 5;
SE = strel('disk', strelSize);
im = imdilate(im, SE);
strelSize = 10;
SE = strel('disk', strelSize);
im = imdilate(im, SE);

% Label image and get areas of blobs:
labeledImage = bwlabel(im, 8);
subplot(1,3,2), imshow(im, [])
subplot(1,3,3), imshow(labeledImage, [])
stats = regionprops(im, 'Area');
allBlobAreas = [stats.Area];
szBlobAreas = size(allBlobAreas);
numCoins = szBlobAreas(2);

sum = 0;
for i = 1:numCoins
    coinSize = allBlobAreas(i);
    if coinSize > 70000 % is a toonie
        sum = sum + 2;
    elseif coinSize > 50000 % is a loonie
        sum = sum + 1;
    elseif coinSize > 29000 % is a quarter
        sum = sum + 0.25;
    elseif coinSize > 9000 % is a nickel
        sum = sum + 0.05;
    elseif coinSize < 1000 % is a dime
        sum = sum + 0.1;
    else % is a penny
        sum = sum + 0.01;
    end
end

numCoins
sum