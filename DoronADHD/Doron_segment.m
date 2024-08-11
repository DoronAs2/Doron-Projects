function [fileNames, pathName]=Doron_segment(events, T1, T2, baseline, fileNames, pathName)
 if nargin<5
    [fileNames, pathName]=Z_getSetsFileNames;
end;
for i=1: size(fileNames,1);
    for j=1: size(events,2);
        event=events{1,j};
        if size(fileNames, 1)==1 & size(fileNames{1,1}, 1)>1
            fileName=fileNames{i,1}';
        else
            fileName=fileNames{i,1};
        end;
        EEG = pop_loadset( [pathName fileName]);
        [EEG, ~, epochcom] = pop_epoch( EEG, {event}, [T1 T2], 'newname', [EEG.setname ' ' event], 'epochinfo', 'yes');
        % if exist('baseline', 'var')
        %     if isempty(baseline)
        %         [EEG, basecom] = pop_rmbase( EEG, [T1*1000  0]);
        %     else
        %         [EEG, basecom] = pop_rmbase( EEG, baseline*1000);
        %     end;
        % end
        
        if ~isfield(EEG, 'recinfo') EEG.recinfo.history={}; end 
        stack=dbstack;
        
        EEG.recinfo.history{end+1}=epochcom;
        
        % if exist('baseline', 'var')
        %     EEG.recinfo.history{end+1}=basecom;
        % end
        
    
        EEG.condition=event;
        % EEG.filename=[EEG.setname '.set'];
        % EEG.datfile=[EEG.setname '.fdt'];
        EEG = eeg_checkset( EEG );  
        EEG = pop_saveset( EEG, [pathName EEG.filename]);
        fileNames{i,1}=EEG.filename;
    end;
end;