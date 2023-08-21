function [x2, y2] = apply_homography(H,X1)
    X2 = H*transpose(X1);
    x2 = 0;
    y2 = 0;
    if(X2(end)~=0)
        x2 = X2(1)/X2(end);
        y2 = X2(2)/X2(end);
    end
end