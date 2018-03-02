function lesionmask = open_lesionmask(lm_fn, ps)
%OPEN_LESIONMASK open lesionmask and preprocess it
    tmp_lesionmask = load_untouch_nii(lm_fn);
    tmp_lesionmask = double(tmp_lesionmask.img);
    pad = 4*[ps.w4(1) + ps.r4, ps.w4(2) + ps.r4, ps.w4(3) + ps.r4];
    lesionmask = padarray(tmp_lesionmask, pad);
end

