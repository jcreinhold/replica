function lesionmask = open_lesionmask(lm_fn, ps)
%OPEN_LESIONMASK open lesionmask and preprocess it
    tmp_lesionmask = load_untouch_nii(lm_fn);
    tmp_lesionmask = double(tmp_lesionmask.img);
    lesionmask = pad(tmp_lesionmask, ps.w4, ps.r4);
end

