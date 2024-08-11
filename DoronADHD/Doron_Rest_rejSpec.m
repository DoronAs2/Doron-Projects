function [fileNames, pathName]=Doron_Rest_rejSpec(fileNames, pathName)

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



   

   % remove bad channels and bad portions of data
   % [tempEEG,com] = pop_clean_rawdata(EEG, 'FlatlineCriterion',2,'ChannelCriterion',0.8,'LineNoiseCriterion',4,'Highpass','off','BurstCriterion',20,'WindowCriterion',0.25, ...
   %            'BurstRejection','on','Distance','Euclidian','WindowCriterionTolerances',[-Inf 5] );

   [tempEEG, com] = pop_clean_rawdata(EEG, 'FlatlineCriterion',5,'ChannelCriterion',0.6,'LineNoiseCriterion',5,'Highpass','off','BurstCriterion',10,'WindowCriterion',0.4, ...
               'BurstRejection','off','Distance','Euclidian','WindowCriterionTolerances',[-Inf 10] );

   RemoveCh = setdiff({EEG.chanlocs.labels}, {tempEEG.chanlocs.labels});

   vis_artifacts(tempEEG,EEG)
   disp(RemoveCh)
   
   EEG = tempEEG;

%    if ~strcmp(EEG.setname(1, end-1:end), 'automated')
%         EEG=Z_append(EEG, 'automated');
%    end
% 
%    if ~isfield(EEG, 'recinfo') EEG.recinfo.history={}; end     
% 
%     EEG.recinfo.history{end+1}=[com];
%     EEG = eeg_checkset( EEG );  
%     EEG = pop_saveset( EEG, [pathName EEG.filename]);
%     fileNames{i,1}=EEG.filename;
% end

    if ~isfield(EEG, 'recinfo') EEG.recinfo.history={}; end     
    
    EEG.recinfo.history{end+1}=[com];
    
    EEG=Z_append(EEG, 'automated');
    EEG = pop_saveset( EEG, [pathName EEG.filename]);
    fileNames{i,1}=EEG.filename;
end

   
    
    
    
    

