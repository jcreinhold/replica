function [outputArg1,outputArg2] = save_synth(inputArg1,inputArg2)
%SAVE_SYNTH Summary of this function goes here
%   Detailed explanation goes here
    subject_synthtrg = zeros(size(subject_t1w));
    subject_synthtrg(fg_idxs) = testY;
    dimcurr = size(subject_synthtrg);
    dimcurr_rem = (dimcurr / 2 - floor(dimcurr/2));
    delta = dimcurr_rem - dim0rem;
    
    subject_synthtrg = subject_synthtrg(4*(w4(1) + r4)+1:4*(w4(1) + r4)+dim_orig(1), ...
                                        4*(w4(2) + r4)+1:4*(w4(2) + r4)+dim_orig(2), ...
                                        4*(w4(3) + r4)+1:4*(w4(3) + r4)+dim_orig(3));
    
    tmp_subject_src.img = subject_synthtrg;
    output_filename = subject_struct.output_filename;
    tmp_subject_src.fileprefix = output_filename;
    save_untouch_nii(tmp_subject_src, output_filename);
end

