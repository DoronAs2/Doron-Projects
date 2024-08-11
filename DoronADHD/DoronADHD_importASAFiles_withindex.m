%% Import ASA files and save them as eeglab sets
function [fileNames, pathName]=DoronADHD_importASAFiles_withindex(subjectInd, experimentInd, sessionInd)

[fileNames, pathName]=getANTFileNames;


for i=1: size(fileNames,1)
     if size(fileNames, 1)==1 
        fileName=fileNames{i,1}';
    else
        fileName=fileNames{i,1};
     end
    EEG = pop_loadeep([pathName fileName] , 'triggerfile', 'on');
    EEG = pop_chanedit(EEG, 'lookup','standard-10-5-cap385.elp');
    
   
    EEG=pop_select(EEG, 'nochannel', {'HEOG', 'VEOG', 'EOG1', 'EOG2', 'Cz'});
  
    
   
    experiment=fileName(experimentInd);
    subject=['S' fileName(subjectInd)];
    session=fileName(sessionInd);
%    
    
     EEG.setname=[experiment ' ' subject ' ' session];
     EEG.filename=[experiment ' ' subject ' ' session];
     EEG.filepath=pathName;
     EEG.subject=subject;
     EEG.session=session;
     EEG = eeg_checkset( EEG );

     EEG.recinfo.filename=fileName;
     EEG.recinfo.history{1}=['Import ASA file : ' fileName];
   
     EEG = pop_saveset( EEG, [EEG.filepath EEG.filename]); 
     fileNames{i,1}= EEG.filename;
end;
