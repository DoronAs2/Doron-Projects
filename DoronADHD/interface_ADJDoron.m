function [EEG aic] = interface_ADJDoron (EEG,report)
   
% Check that number of ICs = number of channels
if size(EEG.icaweights,1)<size(EEG.icaweights,2)
    disp(' ');
    warning('Number of ICs < number of channels.')
    disp(' ');
    disp('If ICA was not run on all channels, remove the excluded channels before running ADJUST.');
    disp('They can be reintroduced by interpolating them from neighbour channels after artifact removal.');
    disp('If some ICs were removed, please go back one step and run ADJUST on all ICs.')
    disp('The reduced IC statistics could lead to erroneous results.');
    return;
end;

if size(EEG.data,3)==1 % epochs must be extracted
    
        lag=5; %epoch duration (in seconds)
        disp(['Continuous dataset epoched in ' num2str(lag) ' sec long epochs to compute feature statistics over time']);
        % check whether '5sec' events are present
        si=0; 
        for i=1:length(EEG.event) 
            if(strcmp(EEG.event(1,i).type, '5sec')==1) 
                si=1; 
            end
        end
        if si==0 %add events
            ntrials=floor((EEG.xmax-EEG.xmin)/lag);
            nevents=length(EEG.event);
            for index=1:ntrials
                EEG.event(index+nevents).type='5sec';
                EEG.event(index+nevents).latency=1+(index-1)*lag*EEG.srate; %EEG.srate is the sampling frequency
                latency(index)=1+(index-1)*lag*EEG.srate;
            end;
        
            EEG=eeg_checkset(EEG,'eventconsistency');
        end
        
        EEGep = pop_epoch( EEG, {  '5sec'  }, [0 lag], 'newname', [EEG.setname '_ep5'] , 'epochinfo', 'yes');
        % removing baseline
        EEGep = pop_rmbase( EEGep, [0  0]);
        EEGep = eeg_checkset(EEGep);
        
    % collects ICA data from EEG
    if isempty(EEGep.icaact)
        disp('Warning: EEG.icaact missing! Recomputed from EEG.icaweights, EEG.icasphere and EEG.data');
        % Next instruction: see eeg_checkset
        EEGep.icaact = reshape(EEGep.icaweights*EEGep.icasphere*reshape(EEGep.data(1:size(EEGep.icaweights,1),:,:),[size(EEGep.icaweights,1) size(EEGep.data,2)*size(EEGep.data,3)]),[size(EEGep.icaweights,1) size(EEGep.data,2) size(EEGep.data,3)]);
    end;

   % Now that dataset is epoched, run ADJUST
   [art, horiz, vert, blink, disc,...
        soglia_DV, diff_var, soglia_K, med2_K, meanK, soglia_SED, med2_SED, SED, soglia_SAD, med2_SAD, SAD, ...
        soglia_GDSF, med2_GDSF, GDSF, soglia_V, med2_V, maxvar, soglia_D, maxdin]=ADJUST (EEGep,report);
    
    %% Saving artifacted ICs for further analysis

    nome=['List_' EEG.setname '.mat'];

    save (nome, 'blink', 'horiz', 'vert');

    disp(' ')
    disp(['Artifact ICs list saved in ' nome]);

    % IC show & remove
    % show all ICs; detected ICs are highlighted in red color. Based on
    % pop_selectcomps.
    
    if isempty(EEG.icaact)
       
        EEG.icaact = EEG.icaweights*EEG.icasphere*EEG.data;
        
    end;
    
    aic=unique([blink horiz vert]);

     % EEG = pop_selectcomps_ADJ( EEG, 1:size(EEG.icaweights,1), art, horiz, vert, blink, disc,...
     %    soglia_DV, diff_var, soglia_K, med2_K, meanK, soglia_SED, med2_SED, SED, soglia_SAD, med2_SAD, SAD, ...
     %    soglia_GDSF, med2_GDSF, GDSF, soglia_V, med2_V, maxvar, soglia_D, maxdin );
    
%%
% else % data are epoched... let's work on the existing epochs
% 
%     % collects ICA data from EEG
%     if isempty(EEG.icaact)
%         disp('Warning: EEG.icaact missing! Recomputed from EEG.icaweights, EEG.icasphere and EEG.data');
%         % Next instruction: see eeg_checkset
%         EEG.icaact = reshape(EEG.icaweights*EEG.icasphere*reshape(EEG.data(1:size(EEG.icaweights,1),:,:),[size(EEG.icaweights,1) size(EEG.data,2)*size(EEG.data,3)]),[size(EEG.icaweights,1) size(EEG.data,2) size(EEG.data,3)]);
%     end;
% 
%    % run ADJUST
%    [art, horiz, vert, blink, disc,...
%         soglia_DV, diff_var, soglia_K, med2_K, meanK, soglia_SED, med2_SED, SED, soglia_SAD, med2_SAD, SAD, ...
%         soglia_GDSF, med2_GDSF, GDSF, soglia_V, med2_V, maxvar, soglia_D, maxdin]=ADJUST (EEG,report);
% 
%     %% Saving artifacted ICs for further analysis
% 
%     nome = ['List_' EEG.setname '.mat'];
% 
%     eb=blink;
%     hem=horiz;
%     vem=vert;
%     gd=disc;
%     aic=unique([blink disc horiz vert]);
%     % RemIC = unique([blink horiz vert]);
% 
%     save (nome, 'eb', 'hem', 'vem', 'aic');
% 
%     disp(['Artifact ICs list saved in ' nome]);
%     disp(' ')
% 
% 
%     % IC show & remove
%     % show all ICs; detected ICs are highlighted in red color. Based on
%     % pop_selectcomps.
%     if isempty(EEG.icaact)
%         disp('Warning: EEG.icaact missing! Recomputed from EEG.icaweights, EEG.icasphere and EEG.data');
%         % Next instruction: see eeg_checkset
%         EEG.icaact = reshape(EEG.icaweights*EEG.icasphere*reshape(EEG.data(1:size(EEG.icaweights,1),:,:),[size(EEG.icaweights,1) size(EEG.data,2)*size(EEG.data,3)]),[size(EEG.icaweights,1) size(EEG.data,2) size(EEG.data,3)]);
%     end;
% 
%     [EEG]=pop_selectcomps_ADJ( EEG, 1:size(EEG.icaweights,1), art, horiz, vert, blink, disc,...
%         soglia_DV, diff_var, soglia_K, med2_K, meanK, soglia_SED, med2_SED, SED, soglia_SAD, med2_SAD, SAD, ...
%         soglia_GDSF, med2_GDSF, GDSF, soglia_V, med2_V, maxvar, soglia_D, maxdin );

    
end

return 
