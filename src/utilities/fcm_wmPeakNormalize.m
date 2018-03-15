function [IsubjNorm, scale_subj_to_ref] = fcm_wmPeakNormalize(Isubj, Iref)
%% Isubj is the subject image, Iref is the reference image.
% If Iref is not given, then the white matter histogram peak of Isubj is
% scaled to 1000, else it is scaled to the white matter peak of Iref.
% This functions finds the WM centroid using FCM and sets that value to the
% reference.
if nargin == 2
    Isubj_fg = Isubj((Isubj>0));
    
    % get a good starting point for FCM
    h = histc(Isubj_fg, 0:max(Isubj_fg));
    h = h(end:-1:1);
    ch = cumsum(h);
    th = 0.001*ch(end);
    gr = find(ch > th);
    gr = length(ch) - gr(1);
    subj_robust_max_intensity = gr
    
    % starting point for fcm
    subj_c_init = [subj_robust_max_intensity/5, subj_robust_max_intensity/2, subj_robust_max_intensity];
    
    [subj_mem_fg subj_hard_seg, subj_c_final]=fuzzy_kmeans(Isubj_fg,3, subj_c_init,2,40);
    
    
    % FCM on ref
    Iref_fg = Iref((Iref>0));
    
    % get a good starting point for FCM
    h = histc(Iref_fg, 0:max(Iref_fg));
    h = h(end:-1:1);
    ch = cumsum(h);
    th = 0.001*ch(end);
    gr = find(ch > th);
    gr = length(ch) - gr(1);
    ref_robust_max_intensity = gr
    
    % starting point for fcm
    ref_c_init = [ref_robust_max_intensity/5, ref_robust_max_intensity/2, ref_robust_max_intensity];
    
    [ref_mem_fg ref_hard_seg, ref_c_final]=fuzzy_kmeans(Iref_fg,3, ref_c_init,2,40);
    
    %
    subj_wm_centroid = subj_c_final(3)
    ref_wm_centroid = ref_c_final(3)
    
    subj_gm_centroid = subj_c_final(2);
    ref_gm_centroid = ref_c_final(2);
    
    subj_csf_centroid = subj_c_final(1);
    ref_csf_centroid = ref_c_final(1);
    scale_subj_to_ref = ref_wm_centroid/subj_wm_centroid;
    
    IsubjNorm = scale_subj_to_ref*Isubj;
    
elseif nargin==1
    threshold = max(Isubj(:))/10;
    threshold = 0;
    Isubj_fg = Isubj((Isubj>threshold));
    
    % get a good starting point for FCM
    h = histc(Isubj_fg, 0:max(Isubj_fg));
    h = h(end:-1:1);
    ch = cumsum(h);
    th = 0.05*ch(end);
    gr = find(ch > th);
    gr = length(ch) - gr(1);
    subj_robust_max_intensity = gr;
    
    % starting point for fcm
    subj_c_init = [subj_robust_max_intensity/6, subj_robust_max_intensity/2, 3*subj_robust_max_intensity/4]
    
    [subj_mem_fg subj_hard_seg, subj_c_final]=fuzzy_kmeans(Isubj_fg,3, subj_c_init,2,40);
    
    wm_peak = subj_c_final(3)
    scale_subj_to_1000 = 1000/wm_peak;
    
    IsubjNorm = scale_subj_to_1000*Isubj;
    scale_subj_to_ref = scale_subj_to_1000;
    
    
end
%  figure;
%  hist(IsubjNorm(IsubjNorm>0),500)

% end