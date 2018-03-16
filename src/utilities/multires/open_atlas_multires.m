function [img, dim] = open_atlas_multires(fn, w, r)
    nii_tmp = load_untouch_nii(fn);
    img_tmp = double(nii_tmp.img);
    dim = size(img_tmp);
    img = pad(img_tmp, w, r);
end