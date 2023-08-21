function [val, incanvas] = Bilinear_interpolation(image,x,y)
    [dim_x, dim_y] = size(image);
    % input image has zeros along the margin
    % to get the shape of the original image, we subtract 2
    dim_x = dim_x - 2; 
    dim_y = dim_y - 2;
    % change scale by 1 on x,y to account for margin
    x = x+1;
    y = y+1;
    xx = floor(x);
    yy = floor(y);
    a = x-xx;
    b = y-yy;
    if (xx >= 1 && xx <= dim_x+1 && yy >= 1 && yy <= dim_y+1)
        val = (1-a)*(1-b)*image(xx, yy)+ (1-a)*b*image(xx, yy) ...
              + a*(1-b)*image(xx+1, yy)+ a*b*image(xx+1, yy+1);
        incanvas = 1;
    else
        val = 0;
        incanvas = 0;
    end
end
    