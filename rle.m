
%------------------------------%
%-------- Applying RLE --------%
%------------------------------%
%
% This function applies RLE to a vector of values.
%
function [symbols, occur] = rle(v)
    if size(v,1) > size(v,2)
        v = v';
    end
    len = length(v);
    s1 = v(1 : len - 1) ~= v(2 : len);    % verify if v(i) == v(i + 1) for 1 < i < len.
    s2 = [find(s1) len];                  % return indices of nonzero values.
    symbols = v(s2);                      % get the symbols.
    occur = diff([0 s2]);                 % get their numbers of repetitions.
end