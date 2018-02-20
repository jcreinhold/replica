function [IsubjNorm, subj_wm_centroid] = wm_peak_normalize_T1w(Isubj, threshold, Iref)
% Isubj is the subject image, Iref is the reference image.
% If Iref is not given, then the white matter histogram peak of Isubj is
% scaled to 1000, else it is scaled to the white matter peak of Iref.
% This is a peak finding function, this can go totally bad if the image
% somehow has outlier peaks. For more robust WM based normalization for T1w images, see
% fcm_wmPeakNormalize.m

if nargin == 3
    
    Isubj_fg = Isubj((Isubj > 0));
    h = histc(Isubj_fg, 0:max(Isubj_fg));
    h = h(end:-1:1);
    ch = cumsum(h);
    th = 0.01 * ch(end);
    gr = find(ch > th);
    gr = length(ch) - gr(1);
    subj_robust_max_intensity = gr;
    
    [f_subj, x_subj] = ksdensity(Isubj_fg, 'npoints', 1000);
    [cmax, imax] = max(f_subj);
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
    [cmax, imax] = max(f_ref);
    ref_wm_centroid = x_ref(imax);
    scale_subj_to_ref = ref_wm_centroid / subj_wm_centroid;
    IsubjNorm = scale_subj_to_ref * Isubj;
    
elseif nargin == 2
    
    Isubj_fg = Isubj((Isubj > threshold));
    h = histc(Isubj_fg, 0:max(Isubj_fg));
    h = h(end:-1:1);
    ch = cumsum(h);
    th = 0.01 * ch(end);
    gr = find(ch > th);
    gr = length(ch) - gr(1);
    subj_robust_max_intensity = gr;
    [f_subj, x_subj] = ksdensity(Isubj_fg, 'npoints', 1000);
    diff = f_subj(2:end) - f_subj(1:end-1);
    delta = mean(abs(diff));
    [maxt, mint] = peakdet(f_subj, delta);
    imax = max(maxt(:, 1));
    
    subj_wm_centroid = x_subj(imax);
    ref_wm_centroid = 1000;
    scale_subj_to_ref = ref_wm_centroid / subj_wm_centroid;
    IsubjNorm = scale_subj_to_ref * Isubj;
end
