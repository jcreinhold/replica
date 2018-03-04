function out = pad(img, ps)
%PAD pad image according to (some) specificiation
    pad = 4*[ps.w4(1) + ps.r4, ps.w4(2) + ps.r4, ps.w4(3) + ps.r4];
    out = padarray(img, pad);
end

