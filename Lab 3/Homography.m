function H = compute_homography(points1, points2)
    N = length(points1);
    A = zeros(2*N,9);
    for i=1:N
        [x,y]= points1(i,:);
        [u,v]= points2(i,:);
        A(2*i-1,:) = [-x -y -1 0 0 0 x*u y*u u];
        A(2*i,:)   = [0 0 0 -x -y -1 x*v y*v v];
        [~,~,V] = svd(A);
        h = V(:, end);
        H = reshape(h, 3, 3)';
    end
end