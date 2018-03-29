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
%       (synth is also saved to a file whose name is equal to the name in
%       subject_struct.output_filename (ss.output_filename)
    
    % setup the data structure for the synthesized image
    subject_synthtrg = pad(zeros(dim), w, r);  % make target img correct size
    subject_synthtrg(fg) = test_Y;

    % put synthesized image in correct format
    synth = unpad(subject_synthtrg, w, r, dim);
    
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

