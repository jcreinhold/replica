function [atlas, dim] = open_atlas(fn, w, r, t1)
%OPEN_ATLAS open an atlas image and preprocess it
%
%   Args:
%       fn: filename, full path to nifti file (uncompressed!) to open
%       w: see [1] in context features
%       r: see [1] in context features
%       t1: boolean flag, use T1w wm peak normalization or use alternative
%           wm peak normalization routine
%
%   Output:
%       atlas: opened, normalized, and padded atlas
%       dim: dimension of the original image (used later for synthesis)
%
%   References:
%   [1] A. Jog, et al., ``Random forest regression for magnetic resonance
%       image synthesis'', Medical Image Analysis, 35:475-488, 2017.

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

