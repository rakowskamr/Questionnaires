%% SSS - Stanford Sleepiness Scale 
% used to measure subjective level of sleepiness

% Clear the workspace and the screen
close all;
clearvars;
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% My settings and prompts
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
outputFolder = 'ourDirectory/Questionnaires/Results';

respMatrix      = nan(1,1);
waitSecs = 1;

prompt = 'Participant code: ';
numParticipant = input(prompt);
prompt = 'Session: \n 1: before sleep \n 2: after sleep \n 3: 24h later \n 4: 10d follow up \n 5: 6-8w follow up \n ';
numSession	= input(prompt);

if numParticipant < 1
        error('Number of participant should be > 0')
end

if numSession < 1 || numSession > 5
        error('Session number should be 1, 2, 3, 4 or 5')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Psychtoolbox settings
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);

% Get the screen numbers
screens = Screen('Screens');

% Draw to the external screen if avaliable
screenNumber = max(screens);

% Define black and white
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
grey = white / 2;
inc = white - grey;
red = [1 0 0];
blue = [0 0 1];
green = [0 1 0];
% Open an on screen window
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, black);

% Get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Query the frame duration
ifi = Screen('GetFlipInterval', window);

% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);

% Set up alpha-blending for smooth (anti-aliased) lines
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% KEYBOARD INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Keybpard setup

keyOne = KbName('1');
keyTwo = KbName('2');
keyThree = KbName('3');
keyFour = KbName('4');
keyFive = KbName('5');
keySix = KbName('6');
keySeven = KbName('7');
spaceKey = KbName('space');
escapeKey = KbName('ESCAPE');
% RestrictKeysForKbCheck([keyOne keyTwo keyThree keyFour keyFive keySix ...
% keySeven escapeKey spaceKey]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   SSS instructions and question
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

line1 = '                                           Stanford Sleepiness Scale';
line2 = '\n\n\n              Which one of the statements below describes your current state?';
line3 = '\n              Please press the corresponding number on the keypad';
line5 = '\n       ';
line6 = '\n              1. Feeling active and vital, alert, wide awake.'; 
line7 = '\n              2. Functioning at a high level, but not at peak. Able to concentrate. ';
line8 = '\n              3. Relaxed, awake, not at full alertness, responsive.';
line9 = '\n              4. A little foggy, not at peak, let down.'; 
line10 = '\n              5. Fogginess, beginning to lose interest in remaining awake, slowed down.';
line11 = '\n              6. Sleepiness, prefer to be lying down, fighting sleep, woozy.';
line12 = '\n              7. Almost in reverie, sleep onset soon, lost struggle to remain awake.'; 
line4 = '\n\n\n              To exit, press escape';
% Draw all the text in one go
Screen('TextSize', window, 50 );
DrawFormattedText(window, [line1 line2 line3 line5 line6 line7 line8...
    line9 line10 line11 line12 line4],'left', screenYpixels * 0.1, white);

% Flip to the screen
Screen('Flip', window); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   Collecting responses
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This is the cue which determines whether we exit the demo
    respToBeMade = true;

    while respToBeMade
        % Check the keyboard. The person should press the
        [keyIsDown, secs, keyCode] = KbCheck;
        if keyCode(escapeKey)
            sca;
            disp('*** Experiment terminated ***');
            return
        elseif keyCode(keyOne)
            respMade = true;
            respToBeMade = false;
            result=1;
        elseif keyCode(keyTwo)
            respMade = true;
            respToBeMade = false;
            result=2;
        elseif keyCode(keyThree)
            respMade = true;
            respToBeMade = false;
            result=3;
        elseif keyCode(keyFour)
            respMade = true;
            respToBeMade = false;
            result=4;
        elseif keyCode(keyFive)
            respMade = true;
            respToBeMade = false; 
            result=5;
        elseif keyCode(keySix)
            respMade = true;
            respToBeMade = false;
            result=6;
         elseif keyCode(keySeven)
            respMade = true;
            respToBeMade = false;   
            result=7;
        end

    end
    
    respMatrix(numParticipant,1) = result;
  
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            SAVE RESULTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if numSession == 1
    numSession_correct = '1evening';
elseif numSession == 2
    numSession_correct = '1morning';
elseif numSession == 3
    numSession_correct = 2;
elseif numSession == 4
    numSession_correct = 3;
elseif numSession == 5
    numSession_correct = 4;
end

filesave = sprintf('SSS_%i_s%i.mat',numParticipant,numSession_correct);
filesave = fullfile(outputFolder,filesave);
save(filesave,'respMatrix')
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           THANK YOU SCREEN
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% write text - To add line spaces we use the special characters "\n"
line13 = '\n\n\n\n Thank you!';
line14 = sprintf('\nYour answer was: %.0f%',result);

% Draw all the text in one go
Screen('TextSize', window, 60 );
DrawFormattedText(window, [line13 line14],...
    'center', screenYpixels * 0.25, white);

% Flip to the screen
Screen('Flip', window);

WaitSecs(waitSecs);

% Clear the screen
sca;
return   