function synth = save_synth(test_Y, ss, w, r, dim, fg)
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
    subject_synthtrg = pad(zeros(dim), w, r);  % make target img correct size
    subject_synthtrg(fg) = test_Y;
    i = 4*(w(1) + r)+1:4*(w(1) + r)+dim(1);
    j = 4*(w(2) + r)+1:4*(w(2) + r)+dim(2);
    k = 4*(w(3) + r)+1:4*(w(3) + r)+dim(3);
    
    % put synthesized image in correct format
    synth = subject_synthtrg(i, j, k);
    
    % save the synthesized image
    if isfield(ss, 't1w')
        tmp_subject_src = load_untouch_nii(ss.t1w); % hack for nii, hdr info
    elseif isfield(ss, 'source')
        tmp_subject_src = load_untouch_nii(ss.source);
    else
        error('subject_struct (ss) needs a t1w or source field');
    end
    tmp_subject_src.img = synth;
    output_filename = ss.output_filename;
    tmp_subject_src.fileprefix = output_filename;
    save_untouch_nii(tmp_subject_src, output_filename);
end

