function H = ransac(points1, points2, min_consensus, R, max_iter, e)
    no_points = length(points1);
    d = ceil(min_consensus*no_points);
    i=0;
    c = 0;
    while i<max_iter
        % Take random points to create homography
        sample_indices = randperm(no_points, R);
        sample_points1 = points1(sample_indices,:);
        sample_points2 = points2(sample_indices,:);
        other_indices = setdiff(1:no_points,sample_indices);
        other_points1 = points1(other_indices,:);
        other_points2 = points2(other_indices,:);
        % Get homography
        H = compute_homography(sample_points1, sample_points2);
        c = 0;
        for j=1:length(other_points1)
            X1 = [other_points1(j,:) 1];
            [xx, yy] = apply_homography(H,X1);
            x = other_points2(j,1);
            y = other_points2(j,2);
            if (sqrt(((xx-x).^2)+((yy-y).^2))<e)
                c = c+1;
            end
        end
        if(c>=d)
            return;
        end
        i=i+1;
    end
end