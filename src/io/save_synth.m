function synth = save_synth(test_Y, ps, dim, fg)
%SAVE_SYNTH save newly synthesized image
%
%   Args:
%       test_Y: regression results
%       ps: A struct containing the parameters for synthesis.
%       dim: dimesion of synthesized image
%       fg: foreground indices of synthesized image
%
%   Output:
%       synth: synthesized image
    
    % setup the data structure for the synthesized image
    subject_synthtrg = zeros(dim);
    subject_synthtrg(fg) = test_Y;
    i = 4*(ps.w4(1) + ps.r4)+1:4*(ps.w4(1) + ps.r4)+dim(1);
    j = 4*(ps.w4(2) + ps.r4)+1:4*(ps.w4(2) + ps.r4)+dim(2);
    k = 4*(ps.w4(3) + ps.r4)+1:4*(ps.w4(3) + ps.r4)+dim(3);
    
    % put synthesized image in correct format
    synth = subject_synthtrg(i, j, k);
    
    % save the synthesized image
    tmp_subject_src.img = synth;
    output_filename = subject_struct.output_filename;
    tmp_subject_src.fileprefix = output_filename;
    save_untouch_nii(tmp_subject_src, output_filename);
end

