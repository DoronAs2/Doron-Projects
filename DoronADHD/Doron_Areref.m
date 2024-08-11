function Doron_Areref(refLabel)

[fileNames, pathName]=Z_getSetsFileNames;
for i=1: size(fileNames,1);
   
        if size(fileNames, 1)==1
            fileName=fileNames{i,1}';
        else
            fileName=fileNames{i,1};
        end;
        
        EEG = pop_loadset( [pathName fileName]);
        
        refInd=strcmp({EEG.chanlocs.labels}, refLabel);
        
        EEG.data(refInd,:,:)=0;
        
        avEEG=mean(EEG.data(~refInd,:,:), 1);
        
        avEEG=repmat(avEEG,[size(EEG.data, 1), 1, 1]);
        
        EEG.data=EEG.data-avEEG;
        
        if ~isfield(EEG, 'recinfo') EEG.recinfo.history={}; end     
        stack=dbstack;
        EEG.recinfo.history{end+1}=[stack.name '(''' refLabel ''')'];
        
        EEG=Z_append(EEG, 'AvReref');
        
        EEG = eeg_checkset( EEG ); 
        
        EEG = pop_saveset( EEG, [pathName EEG.filename]);
end;