% verify that padding and unpadding is done correctly

ps = default_param_struct_multires();
test_file = 'tests/test_data/test.nii';
test = load_untouch_nii(test_file);
test_img = double(test.img);
test_size = size(test_img);

padded = pad(test_img, ps.w4{3}, ps.r4{3});
unpadded = unpad(padded, ps.w4{3}, ps.r4{3}, test_size);

assert(all(size(unpadded) == test_size), 'input size and output (unpadded) size do not match');
assert(all(unpadded(:) == test_img(:)), 'input and output (unpadded) do not match in value');