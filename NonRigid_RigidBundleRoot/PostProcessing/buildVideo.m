function buildVideo()

frame_dir = '/Volumes/HD-PZU3/User/SBU/CSE527-Vision/Project/MIT_1';
model_dir = '/Users/vunguyen/Documents/Study/CSE 527 - Introduction to Computer Vision/Project/Results/NonRigid_RigidBundleRoot/FigurePlot/landmark_MIT1_Step5';
video_path = '/Volumes/HD-PZU3/User/SBU/CSE527-Vision/Project/Videos/MIT1';

files = dir(fullfile(model_dir, '*.jpg'));
for k = 1:length(files)
    nameext = files(k).name;
    [path name ext] = fileparts(nameext);
    im1 = imread(fullfile(frame_dir, [name '.bmp']));
    im1 = imresize(im1, 2);
    im2 = imread(fullfile(model_dir, [name '.jpg']));
    w2 = size(im2, 2);
    h2 = size(im2, 1);
    im2 = im2(h2/10:9*h2/10, w2/5:4*w2/5,:);
    im2 = imresize(im2, 0.7);
    w2 = size(im2, 2);
    h2 = size(im2, 1);
    im1(1:h2,1:w2,:) = im2(:,:,:);
    imwrite(im1,fullfile(video_path, [name '.jpg']))
end

end