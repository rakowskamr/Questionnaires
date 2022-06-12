%% PSQI - Pittsburgh Sleep Quality Index
% used to measure sleep quality and quantity during the past month

% Clear the workspace and the screen
sca;
close all;
clearvars;
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% My settings
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
outputFolder = 'yourDirectory/Questionnaires/Results';

respMatrix=struct();

waitSecs        = 0.5;
waitSecsCross   = 0.4;

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
keyZero = KbName('0');
keyOne = KbName('1');
keyTwo = KbName('2');
keyThree = KbName('3');
keyFour = KbName('4');
keyFive = KbName('5');
keySix = KbName('6');
keySeven = KbName('7');
spaceKey = KbName('space');
escapeKey = KbName('ESCAPE');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                         INSTRUCTIONS for PSQI
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% write text - To add line spaces we use the special characters "\n"

line1 = '\n                     Pittsburgh Sleep Quality Index (PSQI)';
line2 = '\n\n\n        The following questions relate to your usual sleep habits';
line3 = '\n        during the PAST MONTH ONLY.';
line4 = '\n\n        Your answers should indicate the most accurate reply';
line5 = '\n        for the MAJORITY of days and nights in the past month.';
line6 = '\n\n        Please answer ALL questions!';
line7 = '\n\n        If the answer requires you to press a number, use the numeric pad.'; 
line8 = '\n        Otherwise, just type your answer using the main keyboard.';
line9 = '\n\n        Press space bar to continue'; 

% Draw all the text in one go
Screen('TextSize', window, 60 );
DrawFormattedText(window, [line1 line2 line3 line4 line5 line6 line7 line8 line9 ],'left', screenYpixels * 0.1, white);

% Flip to the screen
Screen('Flip', window); 

KbStrokeWait;

%%
%%%%%%%%%% Typed Qeustions 1-4 %%%%%%%%%%%%%%%%%%%

message1 = 'During the past month, what time have you usually gone to bed at night? ';
message2 = 'During the past month, how long (in minutes) has it usually taken you to fall asleep each night? ';
message3 = 'During the past month, what time have you usually gotten up in the morning? ';
message41 = 'During the past month, how many hours of actual sleep did you get at night? ';
% message42 = '\n (This may be different than the number of hours you spent in bed.)'; 
% I couldn't make it appear in the next line (it's part of Q4), it was going over the screen

counter=1;
for initial_questions1_4 = 1:4
    
    if initial_questions1_4==1
       replySubj1 = Ask(window, message1, white, black, 'GetChar',[300 225 1600 600]);
    elseif initial_questions1_4==2
       replySubj1 = Ask(window, message2, white, black, 'GetChar',[300 225 1600 600]);
    elseif initial_questions1_4==3
       replySubj1 = Ask(window, message3, white, black, 'GetChar',[300 225 1600 600]);
    elseif initial_questions1_4==4
       replySubj1 = Ask(window, message41, white, black, 'GetChar',[300 225 1600 600]);
    end
        
    respMatrix(counter).Question_ID=counter; 
    respMatrix(counter).Response=replySubj1;
    counter=counter+1;  
    
    WaitSecs(waitSecs);
      
end 

 %%       
 %%%%%%%%%% Multiple choice & typed Question 5 (a-j) %%%%%%%%%%%%%%%%%%%


line1forquestion1 = ' During the past month, how often have you had trouble'; 
line2forquestion1 = '\n sleeping because you...';
lineforallquestions1 = '\n\n\n\n Not during the past month = press 0';
lineforallquestions2 = '\n Less than once a week = press 1';
lineforallquestions3 = '\n Once or twice a week = press 2';
lineforallquestions4 = '\n Three or more times a week = press 3';

question{1} = '\n\n\n\n\n\n Cannot get to sleep within 30 minutes ';
question{2} = '\n\n\n\n\n\n Wake up in the middle of the night or early morning';   
question{3} = '\n\n\n\n\n\n Have to get up to use the bathroom';
question{4} = '\n\n\n\n\n\n Cannot breath comfortably';
question{5} = '\n\n\n\n\n\n Cough or snore loudly';
question{6} = '\n\n\n\n\n\n Feel too cold';
question{7} = '\n\n\n\n\n\n Feel too hot';
question{8} = '\n\n\n\n\n\n Have bad dreams';
question{9} = '\n\n\n\n\n\n Have pain';

for question5 = 1:numel(question)
    Screen('TextSize', window, 60 );
    DrawFormattedText(window, [line1forquestion1 line2forquestion1 lineforallquestions1 lineforallquestions2 lineforallquestions3...
    lineforallquestions4], 'center', screenYpixels * 0.25, white);
    
    EachQuestion = question{question5}; 
    Screen('TextSize', window, 60);
    DrawFormattedText(window, EachQuestion, 'center', screenYpixels * 0.1, white);
    Screen('Flip', window); 

    respToBeMade = true;

    while respToBeMade
        % Check the keyboard. The person should press the
        [keyIsDown, secs, keyCode] = KbCheck;
        if keyCode(escapeKey)
            sca;
            disp('*** Experiment terminated ***');
            return
        elseif keyCode(keyZero)
            respMade = true;
            respToBeMade = false;
            result=0;
            nameresult = 'Not during the past month';
        elseif keyCode(keyOne)
            respMade = true;
            respToBeMade = false;
            result=1;
            nameresult = 'Less than once a week';
        elseif keyCode(keyTwo)
            respMade = true;
            respToBeMade = false;
            result=2;
            nameresult = 'Once or twice a week';
        elseif keyCode(keyThree)
            respMade = true;
            respToBeMade = false;
            result=3;
            nameresult = 'Three or more times a week';
        end
    
    end
    
    Screen('DrawLines', window, allCoords,...
    lineWidthPix, white, [xCenter yCenter], 2);
    Screen('Flip', window);
    WaitSecs(waitSecsCross);
    
    respMatrix(counter).Question_ID=counter; 
    respMatrix(counter).Response=nameresult;
    counter=counter+1;
    
    WaitSecs(waitSecs);
end

question5j = 'Other reason(s) why you have had trouble sleeping during the past month, please describe: ';
replySubj = Ask(window, question5j, white, black, 'GetChar',[300 225 1600 600]);
WaitSecs(waitSecs);

respMatrix(counter).Question_ID=counter; 
respMatrix(counter).Response=replySubj;
counter=counter+1;   

[keyIsDown, secs, keyCode] = KbCheck;
        if keyCode(escapeKey)
            sca;
            disp('*** Experiment terminated ***');
            return
        end
 %% 
 %%%%%%%%%% Questions 6-7 %%%%%%%%%%
lineforallquestions1 = '\n\n\n\n Not during the past month = press 0';
lineforallquestions2 = '\n Less than once a week = press 1';
lineforallquestions3 = '\n Once or twice a week = press 2';
lineforallquestions4 = '\n Three or more times a week = press 3';

question61 = 'During the past month, how often have you taken'; 
question62=  '\n medicine to help you sleep (prescribed or “over the counter”)?';
question71 = 'During the past month, how often have you had trouble staying awake'; 
question72= '\n while driving, eating meals, or engaging in social activity?';

for questions6_7 = 1:2
    if questions6_7==1
        Screen('TextSize', window, 50);
        DrawFormattedText(window, [question61,question62,lineforallquestions1,lineforallquestions2,lineforallquestions3...
        lineforallquestions4], 'center', screenYpixels * 0.25, white);
        Screen('Flip', window);
    elseif questions6_7==2
        Screen('TextSize', window, 50);
        DrawFormattedText(window, [question71,question72,lineforallquestions1 lineforallquestions2 lineforallquestions3...
            lineforallquestions4], 'center', screenYpixels * 0.25, white);
        Screen('Flip', window);
    end
    respToBeMade = true;

    while respToBeMade
        % Check the keyboard. The person should press the
        [keyIsDown, secs, keyCode] = KbCheck;
        if keyCode(escapeKey)
            sca;
            disp('*** Experiment terminated ***');
            return
        elseif keyCode(keyZero)
            respMade = true;
            respToBeMade = false;
            result=0;
            nameresult = 'Not during the past month';
        elseif keyCode(keyOne)
            respMade = true;
            respToBeMade = false;
            result=1;
            nameresult = 'Less than once a week';
        elseif keyCode(keyTwo)
            respMade = true;
            respToBeMade = false;
            result=2;
            nameresult = 'Once or twice a week';
        elseif keyCode(keyThree)
            respMade = true;
            respToBeMade = false;
            result=3;
            nameresult = 'Three or more times a week';
        end

    end

    Screen('DrawLines', window, allCoords,...
    lineWidthPix, white, [xCenter yCenter], 2);
    Screen('Flip', window);
    WaitSecs(waitSecsCross);
    
respMatrix(counter).Question_ID=counter; 
respMatrix(counter).Response=nameresult;
counter=counter+1;  

   WaitSecs(waitSecs); 
end

%% 
%%%%%%%%%% Question 8 %%%%%%%%%       

lineforallquestions1 = '\n\n\n\n No problem at all = press 0';
lineforallquestions2 = '\n Only a very slight problem = press 1';
lineforallquestions3 = '\n Somewhat of a problem = press 2';
lineforallquestions4 = '\n A very big problem = press 3';

question81 = 'During the past month, how much of a problem has it been for you';
question82 = '\n to keep up enough enthusiasm to get things done?'; 

Screen('TextSize', window, 50);
    DrawFormattedText(window, [question81, question82, lineforallquestions1, lineforallquestions2, lineforallquestions3...
    lineforallquestions4], 'center', screenYpixels * 0.25, white);
    Screen('Flip', window); 

    respToBeMade = true;

    while respToBeMade
        % Check the keyboard. The person should press the
        [keyIsDown, secs, keyCode] = KbCheck;
        if keyCode(escapeKey)
            sca;
            disp('*** Experiment terminated ***');
            return
        elseif keyCode(keyZero)
            respMade = true;
            respToBeMade = false;
            result=0;
            nameresult = 'No problem at all';
        elseif keyCode(keyOne)
            respMade = true;
            respToBeMade = false;
            result=1;
            nameresult = 'Only a very slight problem';
        elseif keyCode(keyTwo)
            respMade = true;
            respToBeMade = false;
            result=2;
            nameresult = 'Somewhat of a problem ';
        elseif keyCode(keyThree)
            respMade = true;
            respToBeMade = false;
            result=3;
            nameresult = 'A very big problem';
        end
   

    end

    Screen('DrawLines', window, allCoords,...
    lineWidthPix, white, [xCenter yCenter], 2);
    Screen('Flip', window);
    WaitSecs(waitSecsCross);
    
        respMatrix(counter).Question_ID=counter; 
        respMatrix(counter).Response=nameresult;
        counter=counter+1;  

        WaitSecs(waitSecs);
  

   %%
%%%%%%%%%% Question 9 %%%%%%%%%
lineforallquestions1 = '\n\n\n\n Very good = press 0';
lineforallquestions2 = '\n Fairly good = press 1';
lineforallquestions3 = '\n Fairly bad = press 2';
lineforallquestions4 = '\n Very bad = press 3';

question9 = 'During the past month, how would you rate your sleep quality overall?'; 

Screen('TextSize', window, 50 );
    DrawFormattedText(window, [question9 lineforallquestions1 lineforallquestions2 lineforallquestions3...
    lineforallquestions4], 'center', screenYpixels * 0.25, white);
    Screen('Flip', window); 

    respToBeMade = true;

    while respToBeMade
        % Check the keyboard. The person should press the
        [keyIsDown, secs, keyCode] = KbCheck;
        if keyCode(escapeKey)
            sca;
            disp('*** Experiment terminated ***');
            return
        elseif keyCode(keyZero)
            respMade = true;
            respToBeMade = false;
            result=0;
            nameresult = 'Very good';
        elseif keyCode(keyOne)
            respMade = true;
            respToBeMade = false;
            result=1;
            nameresult = 'Fairly good';
        elseif keyCode(keyTwo)
            respMade = true;
            respToBeMade = false;
            result=2;
            nameresult = 'Fairly bad';
        elseif keyCode(keyThree)
            respMade = true;
            respToBeMade = false;
            result=3;
            nameresult = 'Very bad';
        end

        
    end

    Screen('DrawLines', window, allCoords,...
    lineWidthPix, white, [xCenter yCenter], 2);
    Screen('Flip', window);
    WaitSecs(waitSecsCross);
    
        respMatrix(counter).Question_ID=counter; 
        respMatrix(counter).Response=nameresult;
        counter=counter+1;  


%%
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                         SAVE RESULTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

filesave = sprintf('PSQI_%i_s%i.mat',numParticipant,numSession);
filesave = fullfile(outputFolder,filesave);
save(filesave,'respMatrix')

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           THANK YOU SCREEN
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
finalline = '\n\n Thank you!'; 

Screen('TextSize', window, 80 );
    DrawFormattedText(window, finalline, 'center', screenYpixels * 0.25, white);
    Screen('Flip', window); 
    
WaitSecs(waitSecs);  

% Clear the screen
sca;
return   