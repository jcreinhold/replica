function atlas = open_atlas(fn, ps, t1)
%OPEN_ATLAS open an atlas image and preprocess it
    tmp_atlas = load_untouch_nii(fn);
    tmp_atlas = double(tmp_atlas.img);
    threshold = 0.001 * median(tmp_atlas(:));
    if t1
        tmp_atlas = wm_peak_normalize_T1w(tmp_atlas, threshold);
    else
        tmp_atlas = wm_peak_normalize_T2w(tmp_atlas, threshold);
    end
    pad = 4*[ps.w4(1) + ps.r4, ps.w4(2) + ps.r4, ps.w4(3) + ps.r4];
    atlas = padarray(tmp_atlas, pad);
end

