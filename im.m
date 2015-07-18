% image size
n = 512;
radius = 150;
thickness = 20;
cube = 50;
scale_factor = 255;


A = zeros(n,n);

for i=1:n
    for j=1:512
        % draw circle
        x = 0.5+i-n/2;
        y = 0.5+j-n/2;
        if (x^2+y^2) > radius^2 && (x^2+y^2)< (radius+thickness)^2;
            A(i,j) = 1;
        end
        
        % draw cube
        if norm([x;y],inf) < cube
            A(i,j) = 1;
        end
        
    end
end

% scale
A = scale_factor * A;

imshow(A,[]);