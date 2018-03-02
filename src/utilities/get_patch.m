function patches = get_patch(atlases, i, j, k, orig, L, ps)
%GET_PATCH get a specified patch
%
%   Args:
%       atlases: array of atlases to extract patches from
%       i: patch center in first component
%       j: patch center in second component
%       k: patch center in third component
%       orig:
%       ps: param_struct
%
%   Output:
%       patch: 
    
    patches = [];
    
    for a=1:length(atlases)
        atlas = atlases{a};
        [ii, jj, kk] = patch_indices(i, j, k, ps.patch_size);
        patches = [patches; reshape(atlas(ii, jj, kk), [L, 1])];
    end
    
    if ps.use_context_patch == 1
        % T1w image will always be the first element of the atlases array
        ctx_patch = extract_context_patch(atlases{1}, i, j, k, ...
                                  ps.r1, ps.r2, ps.r3, ps.r4, ...
                                  ps.w1, ps.w2, ps.w3, ps.w4, orig);
        patches = [patches; ctx_patch];
    end
end


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
