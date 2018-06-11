
%----------------------%
%-------- Main --------%
%----------------------%

[filename, pathname] = uigetfile({'*.bmp'}, 'Pick an image', 'Multiselect', 'off');
if  isequal(filename, 0)
    warndlg('Ups');
else
    fullPath = [pathname filename];
    header(fullPath);
    compress(imread(fullPath));
    imshow('Pic.bmp');
end

