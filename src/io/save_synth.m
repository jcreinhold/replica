function synth = save_synth(test_Y, ss, w, r, dim, fg, dim_orig, pad_val)
%SAVE_SYNTH save newly synthesized image
%
%   Args:
%       test_Y: regression results
%       ps: A struct containing the parameters for synthesis.
%       dim: dimesion of synthesized image      
%       fg: foreground indices of synthesized image
%       dim_orig: dimension of the image to resize to original
%
%   Output:
%       synth: synthesized image
%       (synth is also saved to a file whose name is equal to the name in
%       subject_struct.output_filename (ss.output_filename)
    
    if nargin < 7
        dim_orig = dim;
    end
    
    % setup the data structure for the synthesized image
    if size(test_Y,2) == 1
        subject_synthtrg = pad(zeros(dim), w, r);  % make target img correct size
        subject_synthtrg(fg) = test_Y;
    else
        subject_synthtrg = test_Y;
    end

    % put synthesized image in correct format
    synth = unpad(subject_synthtrg, w, r, dim);
    
    % resize image to original image size
    if all(dim ~= dim_orig)
        if nargin == 8
            % need to account for padding before resizing
            dim_real_orig = dim_orig;
            dim_orig = dim_orig + (2 * pad_val);
        end
        if exist('imresize3')
            synth = imresize3(synth, dim_orig);
        else
            synth = resize3d(synth, dim_orig);
        end
        if nargin == 8
            % now get rid of extra zero padding used to preserve geometry
            synth = synth(pad_val(1)+1:end-pad_val(1),...
                          pad_val(2)+1:end-pad_val(2),...
                          pad_val(3)+1:end-pad_val(3));
            if sum(abs(diff(unique(size(synth) ./ dim_real_orig)))) > 1e-3
                error(['something went wrong with removing padding, ' ...
                       'synth size: (%d x %d x %d), pad: (%d x %d x %d),' ...
                       'orignal dim: (%d x %d x %d)'], ...
                       size(synth), pad_val, dim_real_orig);
            end
        end
    end
    
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

