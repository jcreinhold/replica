function rbi = robust_max_intensity(Isubj_fg, threshold)
    if nargin == 1
        threshold = 0.01;
    end
    % get a good starting point for FCM
    h = histc(Isubj_fg, 0:max(Isubj_fg));
    h = h(end:-1:1);
    ch = cumsum(h);
    th = threshold*ch(end);
    gr = find(ch > th);
    gr = length(ch) - gr(1);
    rbi = gr;
end