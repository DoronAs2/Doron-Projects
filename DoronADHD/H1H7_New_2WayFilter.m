function [fileNames, pathName] = H1H7_New_2WayFilter(low, high, revfilter, fileNames, pathName)
%for lowpass filter set: low freq to zero, high to lowpass value, and revfilter to 0
%for highpass filter set: high freq to zero low to highpass value and revfilter to 0
%for bandpass filter set: bandpass values and revfilter to 0 
%for notch filter set: bandpass stop values and revfilter to 1  

profile on
filtorder=[];
usefft=0;
plotfreqz=0;
firtype='firls';
causal=0;

if nargin<2
    [fileNames, pathName]=Z_getSetsFileNames;
end
for i=1: size(fileNames,1) 
    if size(fileNames, 1)==1 & size(fileNames{1,1}, 1)>1
        fileName=fileNames{i,1}';
    else
        fileName=fileNames{i,1};
    end
    
    % EEG = pop_loadset( [pathName fileName]);
    EEG = pop_loadeep([pathName fileName] , 'triggerfile', 'on');
    EEG = pop_chanedit(EEG, 'lookup','standard-10-5-cap385.elp');
    
    if revfilter==1 %notch
         addname=[' nf' num2str(low) '_' num2str(high)];
    elseif revfilter==0 %bandpass 
        if low>0 && high == 0 %highpass 
            addname=[' hps' num2str(low)];
        elseif high>0 && low == 0 %lowpass
         addname=[' lps' num2str(high)];
        elseif low>0 && high>0 %bandpass 
            addname=[' bpf' num2str(low) '_' num2str(high)];
        end   
    end
    
    [EEG com] = pop_eegfiltnew(EEG, low, high,  filtorder, revfilter, usefft, plotfreqz);
    
    EEG = eeg_checkset( EEG );

    if ~isfield(EEG, 'recinfo') EEG.recinfo.history={}; end  
    
    EEG.recinfo.history{end+1}=com;
    
    EEG = Z_append(EEG, addname);
    

    EEG = pop_saveset( EEG, [EEG.filepath EEG.filename]); 
    fileNames{i,1}= EEG.filename;
end