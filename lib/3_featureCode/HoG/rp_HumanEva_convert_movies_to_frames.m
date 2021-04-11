%function [] = rp_HumanEva_convert_movies_to_frames()
% Converts all HumanEva-I movies to frames and saves these in separate
% directories for each sequence
%
% Written by: Leonid Sigal, Ronald Poppe
% Revision:   1.0
% Date:       14/04/2007

clear all
close all

% Add paths to the toolboxes
addpath('./TOOLBOX_calib/');
addpath('./TOOLBOX_common/');
addpath('./TOOLBOX_dxAvi/');
addpath('./TOOLBOX_readc3d/'); 

frame_dir = 'F:\\test_sets\\image_descriptors\\HumanEva_I\\frames\\test\\';

% Load HumanEva dataset 
CurrentDataset = dataset('HumanEvaI', 'Test'); 

% Perform background subtraction
for SEQ = 1:length(CurrentDataset)
    fprintf('Loading sequence ... \n')
    fprintf('    Subject: %s \n', char(get(CurrentDataset(SEQ), 'SubjectName')));
    fprintf('    Action: %s \n',  char(get(CurrentDataset(SEQ), 'ActionType')));    
    fprintf('    Trial: %s \n\n',  char(get(CurrentDataset(SEQ), 'Trial')));
    
    % Load the sequence
    [ImageStream, ImageStream_Enabled, MocapStream, MocapStream_Enabled] ...
                            = sync_stream(CurrentDataset(SEQ));
      
    Nframes = min([n_frames(ImageStream), n_frames(MocapStream)]);    
    for CAM = 1:length(ImageStream)
        tic
        if (ImageStream_Enabled(CAM))
            dir_name = sprintf('V0_%s_%s_%s_(c%d)', char(get(CurrentDataset(SEQ), 'SubjectName')), char(get(CurrentDataset(SEQ), 'ActionType')), char(get(CurrentDataset(SEQ), 'Trial')), CAM);
            mkdir(frame_dir, dir_name);
        
            for FRAME = 1:Nframes
                % Load image from the video stream
                [ImageStream(CAM), fname, image, map] = cur_image(ImageStream(CAM), FRAME);
                
                % save image
                imwrite(image, sprintf('%s\\%s\\%04d.png', frame_dir, dir_name, FRAME), 'PNG');

                if (mod(FRAME, 10) == 0)
                    fprintf('frame: %d    time: %d\n', FRAME, toc);
                    tic
                end
            end
        end
    end    
    
    % Close all video streams
    for I = 1:length(ImageStream)
        if (ImageStream_Enabled)
            close(ImageStream);
        end
        pause(0.2);
    end
end
%end