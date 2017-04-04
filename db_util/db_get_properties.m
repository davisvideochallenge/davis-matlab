
function str_props = db_get_properties()
    if db_sing_mult_obj==0
        str1 = 'single';
    else
        str1 = 'multiple';
    end
    
    str_props = [num2str(db_year) '-' str1 '-' db_im_size];
end
