function [IsubjNorm, x] = wm_ref_normalize(Isubj, Iref, t1)
%WM_REF_NORMALIZE Isubj is the subject image, Iref is the reference image.

    Isubj_fg = Isubj((Isubj > 0));
    [f_subj, x_subj] = ksdensity(Isubj_fg, 'npoints', 1000);
    [~, imax] = max(f_subj);
    subj_wm_centroid = x_subj(imax);
    Iref_fg = Iref((Iref > 0));
    h = histc(Iref_fg, 0:max(Iref_fg));
    h = h(end:-1:1);
    ch = cumsum(h);
    th = 0.01 * ch(end);
    gr = find(ch > th);
    gr = length(ch) - gr(1);
    ref_robust_max_intensity = gr;
    [f_ref, x_ref] = ksdensity(Iref_fg, 'npoints', ref_robust_max_intensity*10);
    [~, imax] = max(f_ref);
    ref_wm_centroid = x_ref(imax);
    scale_subj_to_ref = ref_wm_centroid / subj_wm_centroid;
    IsubjNorm = scale_subj_to_ref * Isubj;
    
    if t1
        x = subj_wm_centroid;
    else
        x = scale_subj_to_ref;
    end
end

