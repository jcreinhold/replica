function [IsubjNorm, scale_subj_to_ref] = wm_peak_normalize_fcm(Isubj, threshold, Iref)
% Isubj is the subject image, Iref is the reference image.
% If Iref is not given, then the white matter histogram peak of Isubj is
% scaled to 1000, else it is scaled to the white matter peak of Iref.
% This functions finds the WM centroid using FCM and sets that value to the
% reference.

if nargin == 3

    % FCM on ref
    fg = Iref > threshold;
    Iref_fg = Iref(fg);
    ref_robust_max_intensity = robust_max_intensity(Iref_fg);
    
    % starting point for fcm
    ref_c_init = [ref_robust_max_intensity/5, ...
                  ref_robust_max_intensity/2, ...
                  ref_robust_max_intensity];
    
    [ref_m, ~, ref_c_final]=fuzzy_kmeans(Iref_fg, 3, ref_c_init, 2, 50);

    ref_wm_centroid = ref_c_final(3);  % pick brightest, so ref must be T1w
    
    I_tmp = zeros(size(Isubj));
    I_tmp(fg) = ref_m(:,3);
    wm_mask = I_tmp > 0.8;  % want 80% ~confidence for WM
    subj_wm = Isubj(wm_mask);
    mean_subj_wm = mean(subj_wm(:));
    
    scale_subj_to_ref = ref_wm_centroid/mean_subj_wm;
    
    IsubjNorm = scale_subj_to_ref*Isubj;
    
elseif nargin==2
    Isubj_fg = Isubj(Isubj>threshold);
    
    subj_robust_max_intensity = robust_max_intensity(Isubj_fg);
    
    % starting point for fcm
    subj_c_init = [subj_robust_max_intensity/5, ...
                   subj_robust_max_intensity/2, ...
                   subj_robust_max_intensity];
    
    [~, ~, subj_c_final]=fuzzy_kmeans(Isubj_fg, 3, subj_c_init, 2, 50);
    
    wm_peak = subj_c_final(3);
    scale_subj_to_1000 = 1000/wm_peak;
    
    IsubjNorm = scale_subj_to_1000*Isubj;
    scale_subj_to_ref = scale_subj_to_1000; 
end
end

function [membership, hardseg, centroids] = fuzzy_kmeans(v1, K, c_init, q, max_iter)
% modified code for 4 classes.
% Heran 2017/12/11
% CSF = 1, GM = 2, WM = 3, skull = 4.
% c_init is the initial centroids.
% q is the fuzziness factor (usually 2).
% max_iter = max number of iterations.

% Input:
% v1 = 1xn array of foreground voxel values
% K = no of clusters (3 in our case mostly)
% c_init = 1x3 array with initial centroid values
% q = fuzzification factor (2 mostly)
% max_iter: 50 works. mostly

    d_from_centroids = zeros(length(v1(:)), K);
    membership = zeros(size(d_from_centroids));
    centroids = c_init;
    for iter=1:max_iter
        % calc dist from centroids  to rest of points
        for i=1:K
            d_from_centroids(:,i) = abs(v1(:)-centroids(i));
        end

        dq_from_centroids = d_from_centroids.^(-2/(q-1));
        dq_from_centroids(isnan(dq_from_centroids)) = inf;
        
        for i=1:K
            membership(:,i) = dq_from_centroids(:,i)./sum(dq_from_centroids,2);
            nanmemidx = isinf(dq_from_centroids(:,i));
            membership(nanmemidx,i) = 1;
        end

        for i=1:K
            num_centroid = (membership(:,i).^q).*v1(:);
            num_centroid = sum(num_centroid);
            den_centroid = (membership(:,i).^q);
            den_centroid = sum(den_centroid);
            centroids(i) = num_centroid/den_centroid;
        end
    end

    % get the hard segmentation
    maxmems = max(membership,[],2);
    diffmax = membership - repmat(maxmems,[1,K]);
    idx1 = diffmax(:,1)==0;
    idx2 = diffmax(:,2)==0;
    idx3 = diffmax(:,3)==0;

    hardseg = zeros(size(membership,1),1);
    hardseg(idx1) = 1;
    hardseg(idx2) = 2;
    hardseg(idx3) = 3;
end

function rbi = robust_max_intensity(Isubj_fg)
    th_factor = 0.05;  % why this value, idk
    % get a good starting point for FCM
    h = histc(Isubj_fg, 0:max(Isubj_fg));
    h = h(end:-1:1);
    ch = cumsum(h);
    th = th_factor*ch(end);
    gr = find(ch > th);
    gr = length(ch) - gr(1);
    rbi = gr;
end