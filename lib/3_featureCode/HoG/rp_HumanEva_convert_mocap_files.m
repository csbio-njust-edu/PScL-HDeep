%function [] = rp_HumanEva_convert_mocap_files()
% Convect mocap data and save these in separate .mat files
%
% Written by: Ronald Poppe
% Revision:   1.0
% Date:       3/4/2007

CurrentDataset = dataset('HumanEvaI', 'Train'); 
print(CurrentDataset)

for SEQ = 1:length(CurrentDataset)
    % TODO: problems occur for sequence 25
    fprintf('Loading sequence ... \n')
    fprintf('    Subject: %s \n', char(get(CurrentDataset(SEQ), 'SubjectName')));
    fprintf('    Action: %s \n',  char(get(CurrentDataset(SEQ), 'ActionType')));    
    fprintf('    Trial: %s \n\n',  char(get(CurrentDataset(SEQ), 'Trial')));

    if (char(get(CurrentDataset(SEQ), 'Trial')) == '3')
    
        % Load the sequence
        [ImageStream, ImageStream_Enabled, MocapStream, MocapStream_Enabled] ...
                                = sync_stream(CurrentDataset(SEQ));

        Nframes = get(CurrentDataset(SEQ), 'FrameEnd');
        Nframes = [Nframes{:}]
        pose = zeros(Nframes, 81);

        tic
        for FRAME = 1:Nframes
             [MocapStream, groundTruthPose, ValidPose] = cur_frame(MocapStream, FRAME, 'body_pose');

            if (ValidPose)
                pose(FRAME, 1) = 1;
                index = 2;
                names = fieldnames(groundTruthPose);

                 for i=1:length(fieldnames(groundTruthPose))
                     eval(['param = groundTruthPose.' names{i} ';']);
                     param_size = length(param);
                     pose(FRAME, index:index+param_size-1) = param;
                     index = index + param_size;
                 end
    %         else
    %             warning('Mocap data is invalid');
            end

            if (mod(FRAME, 10) == 0)
                fprintf('%d %d \n', FRAME, toc);
                tic
            end
        end

        file_name = sprintf('F:\\test_sets\\image_descriptors\\HumanEva\\poses\\PO_V%d_%s_%s_%s.mat', 0, char(get(CurrentDataset(SEQ), 'SubjectName')), char(get(CurrentDataset(SEQ), 'ActionType')), char(get(CurrentDataset(SEQ), 'Trial')));
        save(file_name, 'pose');

        fprintf('Close all the video streams\n');
        for CAM = 1:length(ImageStream)
            if (ImageStream_Enabled(CAM))
                pause(0.2);
                close(ImageStream);
            end
        end
    end
end
