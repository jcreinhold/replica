function [atlas, dim] = open_atlas(fn, w, r, t1)
%OPEN_ATLAS open an atlas image and preprocess it
    tmp_atlas = load_untouch_nii(fn);
    tmp_atlas = double(tmp_atlas.img);
    threshold = 0.001 * median(tmp_atlas(:));
    if t1
        tmp_atlas = wm_peak_normalize_T1w(tmp_atlas, threshold);
    else
        tmp_atlas = wm_peak_normalize_T2w(tmp_atlas, threshold);
    end
    dim = size(tmp_atlas); % get original dimension for future processing
    atlas = pad(tmp_atlas, w, r);
end

