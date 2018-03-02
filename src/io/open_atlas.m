function atlas = open_atlas(fn, ps)
%OPEN_ATLAS Summary of this function goes here
%   Detailed explanation goes here
    tmp_atlas = load_untouch_nii(fn);
    tmp_atlas = double(tmp_atlas.img);
    threshold = 0.001 * median(tmp_atlas(:));
    tmp_atlas = wm_peak_normalize_T2w(tmp_atlas, threshold);
    pad = 4*[ps.w4(1) + ps.r4, ps.w4(2) + ps.r4, ps.w4(3) + ps.r4];
    atlas = padarray(tmp_atlas, pad);
end

