% Put the vectors grey and bw together: identification of homogeneous
% regions
clear all
img_sz_set = [32,64];%,128,256,512];
img_index_set = [1,8,9];
type_set = 1;%[0,1];
shape = 'square';
%--------------------------------------------------------------------------
for img_sz = img_sz_set
    if img_sz==32
        N_proj_set = [2,4,6,8,10,12,14,16];
    elseif img_sz==64
        N_proj_set = [2,4,8,12,16,20,24,28,32];
    elseif img_sz==128
        N_proj_set = [4,8,16,20,24,28,32,40,48,56,64];
    elseif img_sz==256
        N_proj_set = [8,16,32,40,48,56,64,72,80,88,96,104];
    elseif img_sz==512
        N_proj_set = [8,16,32,48,64,72,80,88,96,104,112,120,136,152,168,184,200];
    end
    
    for img_index = img_index_set;
        for type_code = type_set;
            for N_proj = N_proj_set;
                %--------------------------------------------------------------------------
                if type_code == 0
                    type = 'grid';
                elseif type_code == 1
                    type = 'strip';
                end
                %--------------------------------------------------------------------------
                img = num2str(img_index);
                sz = num2str(img_sz);
                proj = num2str(N_proj);
                %--------------------------------------------------------------------------
                address = strcat('/ufs/fortes/Desktop/PhD_m_files/tomography/consistency_analisys/flat/');
                filename = strcat(address,sz,'/bw/flat-Im',img,'-sz',sz,'-p',proj,'-',type,shape,'-bw');
                load(filename);
                filename = strcat(address,sz,'/grey/flat-Im',img,'-sz',sz,'-p',proj,'-',type,shape,'-grey');
                load(filename);
                %--------------------------------------------------------------------------
                index = find(vector_grey==0.5);
                vector = vector_grey;
                vector(index) = vector_bw(index);
                filename = strcat(address,sz,'/combined/flat-Im',img,'-sz',sz,'-p',proj,'-',type,shape);
                save(filename,'vector');
            end
        end
    end
end

%%
% identification of boundaries
clear all
img_sz_set = [32,64];%,128,256,512];
img_index_set = [1,8,9];
type_set = 1;%[0,1];
shape = 'half_square_h';
%--------------------------------------------------------------------------
for img_sz = img_sz_set
    if img_sz==32
        N_proj_set = [2,4,6,8,10,12,14,16];
    elseif img_sz==64
        N_proj_set = [2,4,8,12,16,20,24,28,32];
    elseif img_sz==128
        N_proj_set = [4,8,16,20,24,28,32,40,48,56,64];
    elseif img_sz==256
        N_proj_set = [8,16,32,40,48,56,64,72,80,88,96,104];
    elseif img_sz==512
        N_proj_set = [8,16,32,48,64,72,80,88,96,104,112,120,136,152,168,184,200];
    end
    
    for img_index = img_index_set;
        for type_code = type_set;
            for N_proj = N_proj_set;
                %--------------------------------------------------------------------------
                if type_code == 0
                    type = 'grid';
                elseif type_code == 1
                    type = 'strip';
                end
                %--------------------------------------------------------------------------
                dim_shape = 4*img_sz/32;
                vector = zeros(img_sz^2,1);
                
                for shape_value = [0:1]
                    for row = 1:img_sz-dim_shape+1
                        for column = 1:img_sz-dim_shape+1
                            img = num2str(img_index);
                            sz = num2str(img_sz);
                            proj = num2str(N_proj);
                            r = num2str(row);
                            c = num2str(column);
                            v = num2str(shape_value);
                            address = strcat('/ufs/fortes/Desktop/PhD_m_files/tomography/consistency_analisys/boundary/');
                            filename = strcat(address,sz,'/',type,'/Im',img,'/v',v,'/boundary-Im',img,'-sz',sz,'-p',proj,'-r',r,'-c',c,'-',type,'-v',v);
                            load(filename)
                            
                            answer2 = data.answer2;
                            answer3 = data.answer3;
                            %--------------------------------------------------------------------------
                            dim = img_sz;
                            piece = [];
                            if answer2 <=0 && answer3 <=0 % if "may be" then
                                for i = 0:dim_shape-1
                                    initial_pixel = dim*(column+i-1)+row;
                                    piece_aux = initial_pixel:initial_pixel+dim_shape-1;
                                    piece = union(piece,piece_aux);
                                    l_p = length(piece_aux);
                                    if shape_value == 0
                                        vector(1+piece_aux(l_p/2):piece_aux(l_p),1) = ones(dim_shape/2,1);
                                    elseif shape_value == 1
                                        vector(piece_aux(1):piece_aux(l_p/2),1) = ones(dim_shape/2,1);
                                    end
                                end
                            end
                            %--------------------------------------------------------------------------
                        end
                    end
                end
                address = strcat('/ufs/fortes/Desktop/PhD_m_files/tomography/consistency_analisys/boundary/');
                filename = strcat(address,sz,'/images/boundary-Im',img,'-sz',sz,'-p',proj,'-',type);
                
                save(filename,'vector');
                %--------------------------------------------------------------------------
            end
        end
    end
end