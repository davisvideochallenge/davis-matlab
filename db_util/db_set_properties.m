% ------------------------------------------------------------------------
% Jordi Pont-Tuset - http://jponttuset.cat/
% March 2017
% ------------------------------------------------------------------------
% This file is part of the DAVIS package presented in:
%   Federico Perazzi, Jordi Pont-Tuset, Brian McWilliams,
%   Luc Van Gool, Markus Gross, Alexander Sorkine-Hornung
%   A Benchmark Dataset and Evaluation Methodology for Video Object Segmentation
%   CVPR 2016
% Please consider citing the paper if you use this code.
% ------------------------------------------------------------------------
% This function sets the properties for the DAVIS dataset:
%
%  - single_or_multiple_objects: 0 - Single Objects
%                                1 - Multiple Objects [Default]
%    Whether the ground truth is considered as a single object (original
%    DAVIS) or as multiple objects (as of DAVIS challenge 2017)
%
%  - im_size: '480p' - Resolution of 480p [Default]
%             'Raw'  - Raw resolution of the images (4k, 1080p, etc.)
%    Resolution at which the images and annotations are used.
% ------------------------------------------------------------------------
function db_set_properties(single_or_multiple_objects, im_size)

    % Get default values
    if ~exist('single_or_multiple_objects','var')
        single_or_multiple_objects = 1;
    end
    if ~exist('im_size','var')
        im_size = '480p';
    end
    
    % Check values are correct
    if (single_or_multiple_objects~=0) && (single_or_multiple_objects~=1)
        error('single_or_multiple_objects must be ''0'' or ''1''')
    end
    if (~strcmp(im_size,'480p')) && (~strcmp(im_size,'Raw'))
        error('im_size must be ''480p'' or ''Raw''')
    end
    
    % Display the values used
    if single_or_multiple_objects
        text_smo = '''multiple'' objects per sequence';
    else
        text_smo = 'a ''single'' object per sequence';
    end
    fprintf('Setting the DAVIS dataset properties (db_set_properties) to image size ''%s'' and %s.\n',im_size,text_smo)

    % Set values
    substitute_file_text(...
        fullfile(db_matlab_root_dir,'db_util','private','db_sing_mult_obj.m'),...
        sprintf('%% Automatically-generated function, do not edit manually\nfunction sing_mult = db_sing_mult_obj()\n\tsing_mult = %d;\nend\n',single_or_multiple_objects))
    substitute_file_text(...
        fullfile(db_matlab_root_dir,'db_util','private','db_im_size.m'),...
        sprintf('%% Automatically-generated function, do not edit manually\nfunction im_size = db_im_size()\n\tim_size = ''%s'';\nend\n',im_size))
end
