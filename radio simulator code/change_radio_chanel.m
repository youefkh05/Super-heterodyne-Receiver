function [mc_new,ynew,fnew,old_pos,AM_Modulated_Signal_RF_Filter, IF_Channel_Filtered, Bass_Band_Channel, RF_BPF, IF_BPF, Bass_Band_Filter] =...
    change_radio_chanel(old_m,AM_Modulated_Signal,ch_freq,Fs, rf)

    pause(old_m);
    old_pos=old_m.CurrentSample;    %save the current position
    % Correctly capture multiple outputs from the radio function
    [AM_Modulated_Signal_RF_Filter, IF_Channel_Filtered, Bass_Band_Channel, RF_BPF, IF_BPF, Bass_Band_Filter] = ...
        radio(AM_Modulated_Signal, ch_freq, Fs, rf);

    [ynew,fnew]=audioread( "Channels\Bass_Band\Bass_Band_Channel_1.wav");
    mc_new=audioplayer(ynew,fnew);
    play(mc_new,old_pos);
    pause(0.05);
    pause(mc_new);
   
    end