function importInstructionVisuals(x,path) %%% x is the window that we operate in
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
        name=strrep(imgs(i,:),' ',[]);                              %%% name of the image, deleting spaces at the end of the names.
        Img_Version=imread(name,'jpg');                             %%% img format
        Textureversion=Screen('MakeTexture',x,Img_Version);         %%% texture format
        
        textending=regexp(name,'_');                                %%% find in which colum of char array there is "_" 
        texturename=[name(1:textending(1)) 'Texture'];              %%% only the first "_" is counted rest is deleted and we add "_texture at the end"
        
        assignin('base',texturename,Textureversion);                  %%% save texture version of the image as "imagename_texture"
    end
end
