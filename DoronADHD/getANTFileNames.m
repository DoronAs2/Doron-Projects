function [fileNames, pathName]=getANTFileNames
[fileNames,pathName] = uigetfile({'*.cnt'; '*.avr'},'Choose EEG Files','multiselect','on');
fileNames=fileNames';

 if ~iscell(fileNames)
     fileNames={fileNames};
 end