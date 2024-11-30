function [fy,MSE,PSNR] = filter_audio(oy,f,show,mode)
%FILTER_AUDIO Summary of this function goes here
%   Detailed explanation goes here
if mode==1
    [fy]=wavelet_filter(oy,show);
elseif mode==2
    [fy]=FIR_filter(oy,f,show);
elseif mode==3
    [fy]=IIR_filter(oy,f,show);
end
global orignaly
test=0;
orignaly=oy;
% Convert to mono if stereo
if size(oy, 2) == 2
	orignaly = mean(oy, 2);
end
if size(fy, 2) == 2
    filteredy = mean(fy, 2);
else
    filteredy=fy; 
end
%-----------------------Experiment parameters(SNR, PSNR, MSE)--------------------------------------
global file
global path
if test==1
    filestr=char(file);
    splitStr = strsplit(filestr, '.');
    filename = splitStr{1};
    fileex = splitStr{2};

    filename=string(filename);
    fileex="."+string(fileex);
    % Find the position of '-noised'
    noisedPosition = strfind(filename, 'noised');

        % If '-noised' is found, remove it
    if ~isempty(noisedPosition)
        % Remove the '-noised' part
        dfilename = [filestr(1:noisedPosition-1), fileex];
        dfilename=dfilename(1)+dfilename(2);
    else
        % If '-noised' is not found, return the original string
        dfilename = filestr;
    end
    dmp=strcat(char(path),dfilename);
    % Step 1: Read the MP3 file
    [orignaly, osampleRate] = audioread(dmp);
    % Convert to mono if stereo
    if size(orignaly, 2) == 2
        orignaly = mean(orignaly, 2);
    end
end

%SNR:
% Calculate the power of the clean signal
cleanPower = mean(orignaly.^2);

% Calculate the power of the residual noise
noiseSignal = orignaly - filteredy;
noisePower = mean(noiseSignal.^2);

% Calculate the SNR in decibels
SNR = 10 * log10(cleanPower / noisePower);

% Calculate MSE (Mean Squared Error)
error=orignaly-filteredy;
MSE=mean(error.^2,'all');

% Calculate PSNR (Peak Signal-to-Noise Ratio)
maxAmplitude = max(abs(orignaly));
PSNR = 10 * log10((maxAmplitude.^2) / MSE);

% Display the results
fprintf('MSE: %f\n', MSE);
fprintf('PSNR: %f dB\n', PSNR);


end




