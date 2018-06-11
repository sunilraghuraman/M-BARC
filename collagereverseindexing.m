clc; close all; workspace;
imagefiles = dir('*.bmp');
nfiles = length(imagefiles);
for p = 1:nfiles
    currentfilename = imagefiles(p).name;
    Image = imread(currentfilename);
    [rows, columns, numberOfColorBands] = size(Image)
    % Figure out the size of each block. 
    wholeBlockRows = 2;
    wholeBlockCols = 3;
    blockSizeR = (rows / wholeBlockRows);
    blockSizeC = (columns / wholeBlockCols);
    sliceNumber = 1;
    for row = 1 : blockSizeR : rows
        for col = 1 : blockSizeC : columns
            row1 = row;
            row2 = row1 + blockSizeR - 1;
            col1 = col;
            col2 = col1 + blockSizeC - 1;
            oneBlock = Image(row1:row2, col1:col2);
            subplot(2, 3, sliceNumber);
            imshow(oneBlock);
            caption = sprintf('Block %d of 6', sliceNumber);
            title(caption);
        	drawnow;
            figure(p);
        	sliceNumber = sliceNumber + 1;
        end
    end
 end