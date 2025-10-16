function importStimuliVisuals(x,path) %%% x is the window that we operate in in the script of experiment (see Screen('Open', window etc.)
cd(path);
imgs=ls;
[row,column]=size(imgs);

for i=1:row
    matchornot=regexp(imgs(i,:),'jpg');                             %%% see if row of 'imgs' contain 'jpg'. If it contains, it means that it is a image file. 
                                                                    %%% i did this because 'ls'
                                                                    %%% function creates the first
                                                                    %%% two row as dots. I don't
                                                                    %%% know why. 
    if matchornot>0
        name=strrep(imgs(i,:),' ',[]);                              %%% name of the image, deleting ([]) spaces (' ') at the end of the names.
        Img_Version=imread(name,'jpg');                             %%% img format
        Textureversion=Screen('MakeTexture',x,Img_Version);         %%% texture format
        
        textending=regexp(name,'.jpg');                                %%% find in which column of char array there is "_" 
        textending(1)=textending(1)-1;
        texturename=[name(1:textending(1)) '_Texture'];              %%% only the first "_" is counted rest is deleted and we add "_texture at the end"
        assignin('base',texturename,Textureversion);                  %%% save texture version of the image as "imagename_texture"
    end
end
