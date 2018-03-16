function [ii, jj, kk] = patch_indices(i, j, k, patch_size)
%PATCH_INDICES Get the patch indices given a patch size and center
%
%   Args:
%       i: patch center in first component
%       j: patch center in second component
%       k: patch center in third component
%       patch_size: 3-dim vector with size of each component
%
%   Output:
%       ii: indices of patch for first component
%       jj: indices of patch for second component
%       kk: indices of patch for third component

    ii = i-((patch_size(1) - 1) / 2):i+((patch_size(1) - 1) / 2);
    jj = j-((patch_size(2) - 1) / 2):j+((patch_size(2) - 1) / 2);
    kk = k-((patch_size(3) - 1) / 2):k+((patch_size(3) - 1) / 2);
end

