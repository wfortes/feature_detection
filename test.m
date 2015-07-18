function piece = shape_scan(m,i_row,dim,shape)

if strcmp(shape,'square')
    for i_pieces_columns = 1:m
        for i_pieces_rows = 1:m
            for i_row = 0:dim-1
                piece_aux = i_row*dim*m+1+(i_pieces_rows-1)*dim+dim^2*m*(i_pieces_columns-1):i_row*dim*m+dim+(i_pieces_rows-1)*dim+dim^2*m*(i_pieces_columns-1);
                piece = union(piece,piece_aux); %global coordinates
            end
        end
    end
end