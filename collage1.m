clc; clf; clear all; close all;

% Get list of all JPG files in this directory
% DIR returns as a structure array. You will need to use () and . to get the file names.
imagefiles = dir('*.jpg');      
nfiles = length(imagefiles);    % Number of files found
len=nfiles/6;
for p = 1:len
    collage = [];
    for m = 1:3
        verticalpart = [];
        for n = 1+2*(m-1)+6*(p-1):2+2*(m-1)+6*(p-1)
            currentfilename = imagefiles(n).name;
            % read images and convert RGB images to grayscale
            currentimage = imread(currentfilename);
            if ndims(currentimage) == 3
                currentimage = rgb2gray(currentimage);
            end
            % change the size of images
            modifiedimage = imresize(currentimage,[2880/2 2880/3]);
            verticalpart = cat(1,verticalpart,modifiedimage);
        end
        collage = cat(2,collage,verticalpart);
    end
    figure(p);
    imshow(collage);
    print(sprintf('collage%d.bmp',p),'-dbmp','-r300');
end
