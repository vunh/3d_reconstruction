function extractFrames ()

vidpath = '../Data/d1.mp4';
outputpath = '../Data/frame_d1';
metapath = '../Data/meta_d1.txt'

fileID = fopen(metapath, 'w');

step = 20;
vidObj = VideoReader(vidpath);
vidHeight = vidObj.Height;
vidWidth = vidObj.Width;
s = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),...
    'colormap',[]);

k = 1;
id = 1;
while hasFrame(vidObj)
%     img = zeros(vidHeight,vidWidth,3,'uint8');
    if (mod(k, step) == 0)
        img = readFrame(vidObj);
        imwrite(img, [outputpath '/' sprintf('%.5d.bmp', id)]);
        if (id ~= 1)
            fprintf(fileID, '\n');
        end
        fprintf(fileID, '%.5d.bmp', id);
        id = id + 1;
    end
    k = k+1;
end

fclose(fileID);

end
