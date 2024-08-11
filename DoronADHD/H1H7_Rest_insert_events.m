function [fileNames, pathName]=H1H7_Rest_insert_events(Step, fileNames, pathName) 
%%
if nargin<2
    [fileNames, pathName]=Z_getSetsFileNames;
end;
for i=1: size(fileNames,1) 
    if size(fileNames, 1)==1 & size(fileNames{1,1}, 1)>1
        fileName=fileNames{i,1}';
    else
        fileName=fileNames{i,1};
    end;
    
    % EEG = pop_loadset( [pathName fileName]);
    EEG = pop_loadeep([pathName fileName] , 'triggerfile', 'on');
    EEG = pop_chanedit(EEG, 'lookup','standard-10-5-cap385.elp');
    EEG.event=[];
    
    Time=1;
    event=0;
    while Time+Step*EEG.srate<EEG.pnts
        Time=Time+Step*EEG.srate;
        event=event+1;
        EEG.event(1+2*(event-1)).type='Smark';
        EEG.event(1+2*(event-1)).latency=Time;
        
        EEG.event(2+2*(event-1)).type=num2str(event);
        EEG.event(2+2*(event-1)).latency=Time+100;
    end
    EEG = eeg_checkset( EEG );
    
    if ~isfield(EEG, 'recinfo') EEG.recinfo.history={}; end     
    stack=dbstack;
    EEG.recinfo.history{end+1}=[stack.name ' : every ' num2str(Step) ' seconds'];
    
    EEG=Z_append(EEG, 'marked');
    EEG = pop_saveset( EEG, [EEG.filepath EEG.filename]); 
    fileNames{i,1}= EEG.filename;
end
