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
    [centers, U, ~] = fcm(Iref_fg, 3, [2.0,100,1e-5,0]);
    [~, cidxs] = sort(centers);
    I_tmp = zeros(size(Isubj));
    I_tmp(fg) = U(cidxs(end),:);
    wm_mask = I_tmp > 0.90;  % want 90% ~confidence for WM
    subj_wm = Isubj(wm_mask);
    mean_subj_wm = mean(subj_wm(:));
    scale_subj_to_ref = 1000/mean_subj_wm;
    IsubjNorm = scale_subj_to_ref*Isubj;
elseif nargin==2
    Isubj_fg = Isubj(Isubj>threshold);
    [centers,~,~] = fcm(Isubj_fg, 3, [2.0,100,1e-5,0]);
    centers = sort(centers);
    wm_peak = centers(3);
    scale_subj_to_1000 = 1000/wm_peak;
    IsubjNorm = scale_subj_to_1000*Isubj;
    scale_subj_to_ref = scale_subj_to_1000;
end
end