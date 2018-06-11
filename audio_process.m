clc; clear all; clear;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Audio Write                         
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Read the original data and process
% Get list of all wav files in this directory
% DIR returns as a structure array. You will need to use () and . to get the file names.
audiofiles = dir('*.mp3');      
wavbinarycol = logical([]);
orig_size_dim1 = 0;
for i = 1:length(audiofiles)
    audiofiles = dir('*.mp3');      
    wavbinarycol = logical([]);
    orig_size_dim1 = 0;
    audiofilename = audiofiles(i).name;
    [y,Fs] = audioread(audiofilename);
    % Read in wav format audio file data and sample rate
    [tempwavdata, fs] = audioread(audiofilename,'native');
    % disp(fs);
    file_size_dim1(i) = size(tempwavdata,1);
    orig_size_dim1 = orig_size_dim1 + file_size_dim1(i);
    orig_size_dim2 = size(tempwavdata,2);
    % Cast data to be 'uint8' type and convert it to binary
    tempwavdatacolumn = tempwavdata(:);
    tempwavnative = typecast(tempwavdata(:), 'uint16');
    compressrate = 256;
    binarylength = 16 - log2(compressrate);
    if compressrate == 1
         tempwavcompre = tempwavnative;
    else
        tempwavcompre = floor((tempwavnative-compressrate/2)/compressrate);
    end
    tempwavbinary = logical([]);
    numparts = 4;
    % numparts = 4 will always work, if numparts > 4, we may need to lose
    % some data since the number of each part must be integer
    % So, we need to add some other procedure  after for loop to make up
    for j = 1:numparts
         step = floor(length(tempwavcompre)/numparts);
         tempwavcompresub = tempwavcompre(1+(j-1)*step:j*step);
         tempwavbinarysub = logical(dec2bin(tempwavcompresub,binarylength) - '0');
        % whos tempwavcompresub 
         tempwavbinary = cat(1,tempwavbinary,tempwavbinarysub);
    end
     tempwavbinarycol = reshape(tempwavbinary', numel(tempwavbinary), 1);
    % whos tempwavbinarycol
     wavbinarycol = cat(1,wavbinarycol,tempwavbinarycol);

% Calculate the size to make the bitmap as square as possible
n = numel(wavbinarycol);
% sqn = ceil(sqrt(n));
% remainder = mod(sqn, 8);
% if remainder < 4
%     cols = sqn - remainder;
% else
%     cols = sqn + (8 - remainder);
% end 
% % Calculate the row number accordingly
% rows = ceil(n/cols);
cols = ceil(sqrt(n));
rows = ceil(sqrt(n));
% Calculate the padding 0s needed to make bitmap a square
% This value is needed when decoding the bitmap
pad = (rows*cols) - n;
disp(pad);
% Add 0s to end in order to fill the last column of the bitmap
wavbinarypad = logical(ones(pad,1));
wavbinarysquare = cat(1,wavbinarycol,wavbinarypad);


%% Write into bitmap file
% Reshape into bitmap
bitmap = reshape(wavbinarysquare, rows, cols);
bitsize = size(bitmap);
% Write encoded bitmap to file 
figure(i);
imshow(bitmap);
imwrite(bitmap,sprintf('audio %d.bmp',i))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Audio Write                         
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Read bmp file
bitmap = imread(sprintf('audio %d.bmp',i));
[rows, cols] = size(bitmap);

%% RESHAPE BINARY DATA
% Reshape into binary row vectors
recwavbinarysquare = reshape(bitmap, numel(bitmap), 1);
% Remove any extra 0s in the last row of the bitmap
recwavbinarycol = recwavbinarysquare(1:(numel(recwavbinarysquare)-pad));
% Reshape back into binary 8-column matrix
recwavbinary = reshape(recwavbinarycol, binarylength, numel(recwavbinarycol)/binarylength)';

%% CONVERT FORMAT
% Convert binary matrix into wav format audio data
data_class_to_use = class(tempwavdata);
orig_size = [orig_size_dim1,orig_size_dim2];

recwavdata = [];
count = 0;
multiplier = 4;
%  switch data_class_to_use
%     case 'uint16'
%         multiplier = 4;
%     case 'single'
%        multiplier = 8;
%  end
    count = count + file_size_dim1(i);
    recwavbinarypart = recwavbinary((count-file_size_dim1(i))*multiplier+1:((count*multiplier)/4),1:binarylength);
    recwavedatapartnative = [];
    for j = 1:numparts
        step = floor(size(recwavbinarypart,1)/numparts);
        recwavbinarypartsub = recwavbinarypart(1+(j-1)*step:j*step,1:binarylength);
        recwavedatapartsub = compressrate * uint16(bin2dec(char(recwavbinarypartsub+'0')));
        recwavedatapartnative = cat(1,recwavedatapartnative,recwavedatapartsub);
    end
    recwavedatapart = typecast(recwavedatapartnative,data_class_to_use); 
    [sz1,sz2] =  size(recwavedatapart);
    [a1,a2] = size(y);
        orig_size_dim2 = 1;
        file_size_dim1(i) = sz1;
    recwavdata = cat(1, recwavdata, reshape(recwavedatapart,[file_size_dim1(i),orig_size_dim2]));

%% WRITE OUTPUT
% Write decoded audio to file
filename = sprintf('mp4 %d.mp4', i);
audiowrite(filename, recwavdata, fs);
clear;
end