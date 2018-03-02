function lesionmask = open_lesionmask(lm_fn, ps)
%OPEN_LESIONMASK Summary of this function goes here
%   Detailed explanation goes here
    tmp_lesionmask = load_untouch_nii(lm_fn);
    tmp_lesionmask = double(tmp_lesionmask.img);
    lesionmask = padarray(tmp_lesionmask, 4*[w4(1) + r4, w4(2) + r4, w4(3) + r4]);
end

