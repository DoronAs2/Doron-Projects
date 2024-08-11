function Doron_Rest_interpTreatment
 
load('C:\Users\doron\Desktop\EEGlab\DoronADHD\Chanlocs_WG64_POzground_IncludingCzref.mat');

[fileNames, pathName]=Z_getSetsFileNames;
for i=1: size(fileNames,1);
   
        if size(fileNames, 1)==1
            fileName=fileNames{i,1}';
        else
            fileName=fileNames{i,1};
            %% 
        end;
        EEG = pop_loadset( [pathName fileName]);
        
        %if ~isfield(EEG, 'recinfo') EEG.recinfo.history={}; end  
        
        %[~,ind]=setdiff({EEG.chanlocs.labels}, {ChanLocations.labels});
        
        %if ind; 
         %   [EEG, com]=pop_select(EEG, 'nochannel', ind);
         %  EEG.recinfo.history{end+1}=com;
         %end
            
        [EEG, com] = pop_interp(EEG, ChanLocations, 'spherical');
        EEG.recinfo.history{end+1}=com;
        
        %EEG.data(16, :, :) = 0;
        
        EEG.setname = [EEG.setname ' interp'];
        EEG.filename=[EEG.setname '.set'];
        EEG.datfile=[EEG.setname '.fdt'];
        EEG = eeg_checkset( EEG );  
        EEG = pop_saveset( EEG, [pathName EEG.filename]);
    
end;
clear;
