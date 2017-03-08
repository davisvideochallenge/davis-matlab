

function eval = eval_frame(mask, measures, mask_gt, num_objects, mask_prev)

    % Compute measures
    if ismember('J',measures), eval.J = jaccard_region(mask, mask_gt, num_objects); end
    if ismember('F',measures), eval.F = f_boundary(mask, mask_gt, num_objects);     end
    if ismember('T',measures), eval.T = t_stability(mask_prev, mask, num_objects);  end
    