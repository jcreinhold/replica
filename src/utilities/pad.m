function out = pad(img, w, r)
%PAD pad image according to (some) specificiation
    pad = 4*[w(1) + r, w(2) + r, w(3) + r];
    out = padarray(img, pad);
end

