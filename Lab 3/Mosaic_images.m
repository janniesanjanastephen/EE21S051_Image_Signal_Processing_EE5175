function canvas = Mosaic_images(image1,image2,image3)
    % Read images
    img1 = imread(image1);
    img2 = imread(image2);
    img3 = imread(image3);

    % Set the percentile of the inlier points to be in
    % consensus as 80% as given.
    min_consensus = 0.8;
    % epsilon- the distance between the actual 
    % to homography applied points to be atleast so much
    e = 5;
    % Maximum no. of iterations that can be run to get a
    % suitable homography
    max_iter = 10^3;
    % R here is |R| given, ie., the cardinality of the no.
    % of point correspondances used in the computation 
    % of the homography
    R = 4;
    
    % Apply SIFT and compute all corresponding points in 
    % images 1 and 3 wrt 2.
    [points1, points2] = sift_corresp(image1,image2);
    % Run RANSAC
    H21 = ransac(points2,points1,min_consensus,R,max_iter,e);
    [points3, points2] = sift_corresp(image3,image2);
    H23 = ransac(points2,points3,min_consensus,R,max_iter,e);
    
    % We add a margin one pixel wide across all images
    [x,y] = size(img1);
    image = zeros(x+2,y+2);
    image(2:x+1,2:y+1) = img1;
    img1 = image;
    [x,y] = size(img2);
    image = zeros(x+2,y+2);
    image(2:x+1,2:y+1) = img2;
    img2 = image;
    [x,y] = size(img3);
    image = zeros(x+2,y+2);
    image(2:x+1,2:y+1) = img3;
    img3 = image;
    clear image;

    % Get size of the images to be stitched
    [x1,y1]= size(img1);
    [x2,y2]= size(img2);
    [x3,y3]= size(img3);

    % Create a canvas of maximum dimensions
    NumCanvasRows = x1+x2+x3;
    NumCanvasColumns = y1+y2+y3;
    canvas = zeros(NumCanvasRows,NumCanvasColumns);

    % Offset as described
    OffsetRow = ceil(NumCanvasRows/3);
    OffsetColumn = ceil(NumCanvasColumns/3);

    for ii=1:NumCanvasRows
        i = ii-OffsetRow;
        for jj=1:NumCanvasColumns
            j = jj-OffsetColumn;
            % i,j are the target locations for image 2 in the canvas
            pointsincanvas = [i j 1];
            % get source locations from homography on image 1,3
            [xs1 ys1] = apply_homography(H21,pointsincanvas);
            [xs3 ys3] = apply_homography(H23,pointsincanvas);
            % Perform bilinear interpolation
            [val1, incanvas1] = Bilinear_interpolation(img1,xs1,ys1);
            [val2, incanvas2] = Bilinear_interpolation(img2,i,j);
            [val3, incanvas3] = Bilinear_interpolation(img3,xs3,ys3);
            % A point on the canvas can be present in none to all of 
            % the images stitched. We accordingly normalize the pixel
            % intensity.
            val = val1+val2+val3;
            numincanvas = incanvas1+incanvas2+incanvas3;
            if(numincanvas>0)
                val = val/numincanvas;
            end
            canvas(ii,jj)=val;
        end
    end
    
    canvas = uint8(canvas);
end