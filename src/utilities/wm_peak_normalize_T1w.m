function [IsubjNorm, scale_subj_to_ref] = wm_peak_normalize_T1w(Isubj, threshold, Iref)
% Isubj is the subject image, Iref is the reference image.
% If Iref is not given, then the white matter histogram peak of Isubj is
% scaled to 1000, else it is scaled to the white matter peak of Iref.
% This is a peak finding function, this can go totally bad if the image
% somehow has outlier peaks. For more robust WM based normalization for T1w 
% images, see fcm_wmPeakNormalize.m

if nargin == 3
    [IsubjNorm, scale_subj_to_ref] = wm_ref_normalize(Isubj, Iref);
elseif nargin == 2
    Isubj_fg = Isubj(Isubj > threshold);
    [f_subj, x_subj] = ksdensity(Isubj_fg, 'NumPoints', 1000);
    diff = f_subj(2:end) - f_subj(1:end-1);
    delta = mean(abs(diff));
    [maxt, ~] = peakdet(f_subj, delta);
    imax = max(maxt(:, 1));
    subj_wm_centroid = x_subj(imax);
    ref_wm_centroid = 1000;
    scale_subj_to_ref = ref_wm_centroid / subj_wm_centroid;
    IsubjNorm = scale_subj_to_ref * Isubj;
end
