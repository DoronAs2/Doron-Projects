function [fileNames, pathName] = DoronSelect(fileNames, pathName)

if nargin<2
    [fileNames, pathName]=Z_getSetsFileNames;
end;
for i=1: size(fileNames,1) 
    if size(fileNames, 1)==1 & size(fileNames{1,1}, 1)>1
        fileName=fileNames{i,1}';
    else
        fileName=fileNames{i,1};
    end;
    
    EEG = pop_loadset( [pathName fileName]);
   

    ind=find(strcmp({EEG.chanlocs.labels}, {'Cz'}) | strcmp({EEG.chanlocs.labels},{'ECG'}))
    [EEG,com] = pop_select(EEG,'nochannel',ind)

    if ~isfield(EEG, 'recinfo') EEG.recinfo.history={}; end     
    
    EEG.recinfo.history{end+1}=[com];
    
    EEG=Z_append(EEG, 'RemChan');
    EEG = pop_saveset( EEG, [pathName EEG.filename]);
    fileNames{i,1}=EEG.filename;
end

