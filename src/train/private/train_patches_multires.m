function [patches, y] = train_patches_multires(src, trg, ps, res, rs_trg, ...
                                                src0, trg0, g)
%TRAIN_PATCHES_MULTIRES get patches for training REPLICA random forest
% for target images using all images provided by user
%
%   Args:
%       as: atlas struct
%       ps: A struct containing the parameters for training.
%       i: iteration number
%
%   Output:
%       patches: array of the actual patches
%       y: array of the value of the target image at those patches

    if res == 3
        % below is a hack to make there be 9000 no_quantile_voxels 
        % (replicates old code behavior)
        ps.n_training_samples_per_brain = 9000 * 100;
        src_fg = src0(src0 > ps.threshold);
        src0 = interp3(src0, g{1}, g{2}, g{3});
        trg0 = interp3(trg0, g{1}, g{2}, g{3});
        [I, J, K, orig, n] = get_train_params(src0, trg0, ps, 'SourceForeground', src_fg);
    else
        [I, J, K, orig, n, ~] = get_params_multires(src, ps);
    end
    
    N = ps.N{res};
    L = prod(N);
    patches_num = L;
    % define N2, L2 to enable parfor (raises error otherwise)
    N2 = false;
    L2 = false;
    if res > 1
        N2 = ps.N2{res-1};
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
    y = zeros(1,n);
    
    parfor viter=1:n
        i = I(viter);
        j = J(viter);
        k = K(viter);
    
        [ii, jj, kk] = patch_indices(i, j, k, N);
        patch1 = reshape(src(ii,jj,kk), [L 1]);
        ctx_patch = extract_context_patch(src, i, j, k, ...
                                  r1, r2, r3, r4, ...
                                  w1, w2, w3, w4, orig);
        if N2
            [ii2, jj2, kk2] = patch_indices(i, j, k, N2);
            patch2 = reshape(rs_trg(ii2, jj2, kk2), [L2, 1]);
            p = [patch1; patch2; ctx_patch];
        else
            p = [patch1; ctx_patch];
        end
        
        patches(:,viter) = p;
        y(viter) = trg(i,j,k);
    end
end

