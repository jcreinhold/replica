function [patches, fg] = predict_patches_multires(src, ps, res, rs_src)
%MULTIRES_PREDICT_PATCHES extract patches to do regression on w/ RF
% specific to synthesizing target images from T1w, T2w, PDw, FLAIR images
%
%   Args:
%       src: subject image of interest (source)
%       ps: A struct containing the parameters for synthesis.
%       res: resolution number (1=low,2=med,3=high)
%       rs_src: resampled src (to get everything in the right dimension)
%
%   Output:
%       test_patches: patches on which to do regression (from ss)
%       dim: dimension of synthesized image (for saving result image)
%       fg: foreground indices (for saving result image)

    [I, J, K, orig, n, fg] = get_params_multires(src, ps);
    
    N = ps.N{res};
    L = prod(N);
    patches_num = L;
    if res > 1
        N2 = ps.N2{res};
        L2 = prod(N2);
        patches_num = patches_num + L2;
    end
    r1 = ps.r1{res};
    r2 = ps.r2{res};
    r3 = ps.r3{res};
    r4 = ps.r4{res};

    w1 = ps.w1{res};
    w2 = ps.w2{res};
    w3 = ps.w3{res};
    w4 = ps.w4{res};
    
    patches = zeros(patches_num+32, n);
    
    for viter=1:n
        i = I(viter);
        j = J(viter);
        k = K(viter);
    
        [ii, jj, kk] = patch_indices(i, j, k, N);
        patch1 = reshape(src(ii,jj,kk), [L 1]);
        ctx_patch = extract_context_patch(src, i, j, k, ...
                                  r1, r2, r3, r4, ...
                                  w1, w2, w3, w4, orig);
        if res > 1
            [ii2, jj2, kk2] = patch_indices(i, j, k, N2);
            patch2 = reshape(rs_src(ii2, jj2, kk2), [L2, 1]);
            p = [patch1; patch2; ctx_patch];
        else
            p = [patch1; ctx_patch];
        end
        
        patches(:,viter) = p;
    end

end

