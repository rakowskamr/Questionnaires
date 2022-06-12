%% EHI - Edinburgh Handedness Inventory (Short Version)
% a measurement scale used to assess the dominance of a person's hand
% in everyday activities, sometimes referred to as laterality.

% Clear the workspace and the screen
sca;
close all;
clearvars;
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% My settings and prompts
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
outputFolder = 'yourDirectory/Questionnaires/Results';

respMatrix      = nan(4,1);
waitSecs        = 0.5;
waitSecsCross   = 0.6;

prompt          = 'Participant code: ';
numParticipant  = input(prompt);
prompt          = 'Session (only 1!): ';
numSession      = input(prompt);

if numParticipant < 1
        error('Number of participant should be > 0')
end

if numSession < 1 || numSession > 1
        error('Session number should be 1')
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
% FIXATION CROSS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Here we set the size of the arms of our fixation cross
fixCrossDimPix = 40;

% Now we set the coordinates (these are all relative to zero we will let
% the drawing routine center the cross in the center of our monitor for us)
xCoords = [-fixCrossDimPix fixCrossDimPix 0 0];
yCoords = [0 0 -fixCrossDimPix fixCrossDimPix];
allCoords = [xCoords; yCoords];

% Set the line width for our fixation cross
lineWidthPix = 4;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% KEYBOARD INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

keyOne = KbName('1');
keyTwo = KbName('2');
keyThree = KbName('3');
keyFour = KbName('4');
keyFive = KbName('5');
spaceKey = KbName('space');
escapeKey = KbName('ESCAPE');

%% 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                Questions asked
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
wordActivity = {'WRITING','THROWING', ...
            'USING A TOOTHBRUSH','USING A SPOON'};
        
line1 = 'Edinburgh Handedness Questionnaire';
line2 = 'Please indicate your preference in the use of hands in';
line3 = 'the following activities, by pressing a number on';
line4 = 'the keypad that corresponds to the following scale: ';
line6 = '1                 2             	            3                         4                    5'; 
line7 = 'Always left      Usually left        No preference      Usually right     Always right';

for kk = 1:numel(wordActivity)
    
    textPrint = sprintf('\n%s\n\n%s\n%s\n%s\n\n\n%s\n\n\n%s\n\n%s\n',...
                line1,line2,line3,line4,wordActivity{kk},line6,line7);
    
    Screen('TextSize', window, 50 );
    DrawFormattedText(window, textPrint,'center', screenYpixels * 0.1, white);
    
    % Flip to the screen
    Screen('Flip', window); 
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                 Collecting responses
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    respToBeMade = true;
    
    while respToBeMade
        % Check the keyboard. The person should press the
        [keyIsDown, secs, keyCode] = KbCheck;
     
        if keyCode(escapeKey)
            sca;
            disp('*** Experiment terminated ***');
            return
       elseif keyCode(keyOne)
            respMade        = true;
            respToBeMade	= false;
            result          = 1;
        elseif keyCode(keyTwo)
            respMade        = true;
            respToBeMade    = false;
            result          = 2;
        elseif keyCode(keyThree)
            respMade        = true;
            respToBeMade    = false;
            result          = 3;
        elseif keyCode(keyFour)
            respMade        = true;
            respToBeMade    = false;
            result          = 4;
        elseif keyCode(keyFive)
            respMade        = true;
            respToBeMade    = false;
            result          = 5;
        end        
    end

     WaitSecs(waitSecs);
     respMatrix(kk,1) = result;
  
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                           fixation cross
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    Screen('DrawLines', window, allCoords,...
        lineWidthPix, white, [xCenter yCenter], 2);
        Screen('Flip', window);
        WaitSecs(waitSecsCross);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            SAVE RESULTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

filesave = sprintf('EHI_short_%i_s%i.mat',numParticipant,numSession);
filesave = fullfile(outputFolder,filesave);
save(filesave,'respMatrix')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           THANK YOU SCREEN
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% write text - To add line spaces we use the special characters "\n"
line20 = '\n\n\n\n Thank you!';

% Draw all the text in one go
Screen('TextSize', window, 60 );
DrawFormattedText(window, [line20],... 
    'center', screenYpixels * 0.25, white);

% Flip to the screen
Screen('Flip', window);

WaitSecs(waitSecs);

% Clear the screen
sca;
return   