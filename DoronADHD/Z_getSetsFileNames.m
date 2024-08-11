function [fileNames, pathName]=Z_getSetsFileNames;
[fileNames,pathName] = uigetfile({'*.set'},'Choose Sets Files','multiselect','on');
fileNames=fileNames';

 if ~iscell(fileNames)
     fileNames={fileNames};
 end