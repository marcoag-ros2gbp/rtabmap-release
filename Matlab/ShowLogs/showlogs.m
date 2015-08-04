function [LogF LogI] = showlogs(PathPrefix, GT_file)
% [LogF LogI] = showlogs(PathPrefix, GT_file)
% SHOWLOGS  Plot a RTAB-Map results (LogI.txt, LogF.txt). Just put this 
%           file in the same directory as LogF.txt and LogI.txt files 
%           generated by RTAB-Map (RTAB-Map's working directory). The files
%           must have the same number of lines.
% 
% SHOWLOGS(PathPrefix, GT_file)
%     PathPrefix (optional) is a path prefix to put before the loaded
%     files (LogI.txt and LogF.txt).
%     GT_file (optional) is the Ground Truth file. The Ground Truth is a 
%     squared bmp file (size must match the log files length) where 
%     white dots mean loop closures. Grey dots mean 'loop closures to 
%     ignore', this happens when the rehearsal doesn't match consecutive 
%     images together.
% 
%     Dependency : importfile.m

%--------------------
% Parameters
%--------------------
set(0,'defaultAxesFontName', 'Times')
set(0,'defaultTextFontName', 'Times')

if nargin < 2, GT_file = ''; end
if nargin < 1, PathPrefix = '.'; end

%---------------------------------------------------------

display(' ');
display('Loading log files...');
LogF = importfile([PathPrefix '/' 'LogF.txt']);
% COLUMN HEADERS : 
% 1 totalTime
% 2 timeMemoryUpdate,
% 3 timeReactivations,
% 4 timeLikelihoodCalculation,
% 5 timePosteriorCalculation,
% 6 timeHypothesesCreation,
% 7 timeHypothesesValidation,
% 8 timeRealTimeLimitReachedProcess,
% 9 timeStatsCreation
% 10 highestHypothesisValue
% 11 vpLikelihood
% 12 maxLikelihood
% 13 sumLikelihoods
% 14 mean likelihood
% 15 stddev likelihood
% 16 vp hypothesis
% 17 timeJoiningTrash
% 18 rehearsalValue
% 19 timeEmptyingTrash
% 20 timeRetrievalDbAccess

LogI = importfile([PathPrefix '/' 'LogI.txt']);
% COLUMN HEADERS : 
% 1 lcHypothesisId,
% 2 highestHypothesisId,
% 3 signaturesRemoved,
% 4 hessianThr,
% 5 wordsNewSign,
% 6 dictionarySize,
% 7 this->getWorkingMem().size(),
% 8 rejectedHypothesis?,
% 9 processMemoryUsed,
% 10 databaseMemoryUsed
% 11 signaturesReactivated
% 12 lcHypothesisReactivated
% 13 refUniqueWordsCount
% 14 _reactivateId
% 15 nonNulls.size()
% 16 rehearsalMaxId
% 17 rehearsalNbMerged

if isempty(LogI) || isempty(LogF)
    error('Log files are empty')
end

if size(LogI, 1) ~= size(LogF, 1)
    error('Log files are not the same size')
end

% figure
% subplot(211)
% H1 = plot(LogF(:,1)*1000);
% hold on
% % H2 = plot(1:length(LogF(:,1)), ones(length(LogF(:,1)),1).*mean(LogF(:,1))*1000, 'r-')
% %title('Total process time / Location')
% ylabel('Time (ms)')
% xlabel('Location indexes')
% meanTime = mean(LogF(:,1))*1000
% %plot([1 length(LogF(:,1))], [800 800], 'r')
% %plot([1 length(LogF(:,1))], [1000 1000], 'k')
% subplot(212)
% plot(sum(LogF(:,2:7),2)*1000);
% ylabel('Time (ms)')
% xlabel('Location indexes')

figure
plot(LogF(:,1), 'g'); % to verify that we have all timings below
hold on
if size(LogF, 2) == 21
    plot((sum(LogF(:,2:7),2)+LogF(:,17)+LogF(:,21)));
else
    plot((sum(LogF(:,2:7),2)+LogF(:,17)+sum(LogF(:,21:26),2)));
end
ylabel('Time (s)')
xlabel('Node indexes')
meanTime = mean(LogF(:,1))*1000
plot([1 length(LogF(:,1))], [0.7 0.7], 'r')
plot([1 length(LogF(:,1))], [1 1], 'k')
%plot([1 length(LogF(:,1))], [350 350], 'r')
%legend('Processing time', 'Time limit')%, 'Acquisition rate (1 Hz)')
%title('Processing time')

maxTime = max(sum(LogF(:,2:7),2)+LogF(:,17))
maxDict = max(LogI(:, 6))
maxWM = max(LogI(:,7))
%%

% -------------------------
% Time details
figure
subplot(8,1,1)
plot(LogF(:,2)*1000)
title('timeMemoryUpdate (ms)')

subplot(8,1,2)
plot(LogF(:,3)*1000)
title('timeReactivations (ms)')

subplot(8,1,3)
plot(LogF(:,4)*1000)
title('timeLikelihoodCalculation (ms)')

subplot(8,1,4)
plot(LogF(:,5)*1000)
title('timePosteriorCalculation (ms)')

subplot(8,1,5)
plot(LogF(:,6)*1000)
title('timeHypothesesCreation (ms)')

subplot(8,1,6)
plot(LogF(:,7)*1000)
title('timeHypothesesValidation (ms)')

subplot(8,1,7)
plot(LogF(:,8)*1000)
title('timeStatsCreation (ms)')

if size(LogF, 2) > 16
 subplot(8,1,8)
 plot(LogF(:,17)*1000)
 title('timeJoiningTrash (ms)')
end
xlabel('Location indexes')

%% -------------------------
figure
plot([LogF(:,2) sum(LogF(:,2:3),2) sum(LogF(:,2:4),2) sum(LogF(:,2:5),2) sum(LogF(:,2:6),2) sum(LogF(:,2:7),2) sum(LogF(:,2:8),2), sum(LogF(:,2:8),2)+LogF(:,17)]);
legend('timeMemoryUpdate', 'timeReactivations', 'timeLikelihoodCalculation', 'timePosteriorCalculation', 'timeHypothesesCreation', 'timeHypothesesValidation', 'timeRealTimeLimitReachedProcess', 'timeJoiningTrash')
title('Process time details')
ylabel('s')
xlabel('Location indexes')

figure
subplot(211)
plot(LogF(:,3));
title('Reactivation time (s)')
ylabel('s')
subplot(212)
plot(LogI(:,11),'.')
ylabel('Locations reactivated')
xlabel('Location indexes')

%% -------------------------
figure
subplot(211)
plot(LogI(:, 6));
title('dictionary size')
ylabel('words')

subplot(212)
plot([LogI(:, 9) LogI(:, 10)]);
title('Memory usage (in MB)')
legend('Process', 'Database')
ylabel('MB')
xlabel('Location indexes')
% -------------------------

if size(LogI, 2) >= 18
    LTMsize = zeros(1,length(LogI(:,16)));
    for i=1:length(LogI(:,16))
        LTMsize(i) = sum(LogI(1:i,16) == 0);
    end
    LTM = LTMsize(end)

    figure
    % subplot(211)
    H2 = plot(LTMsize, 'r'); % global graph
     hold on
    H1 = plot(LogI(:,7)); % WM
    H3 = plot(LogI(:,17), 'g'); % Local graph
    % H2 = plot(1:length(LogI(:,7)), ones(length(LogI(:,7)),1).*mean(LogI(:,7)), 'r--')
    %title('Graph size')
    legend('Global graph', 'WM', 'Local graph')
    ylabel('Nodes')
    xlabel('Node indexes')
    %set(H1,'color',[0.3 0.3 0.3])
    %set(H2,'color',[0 0 0])
    %set(H3,'color',[0 0 0])
    % subplot(212)
    % plot(LogI(:,6));
    meanWM = mean(LogI(:,7))
    meanDict = mean(LogI(:,6))
    % ylabel('Dictionary size')
    % xlabel('Location indexes')
else
    figure
    % subplot(211)
    H1 = plot(LogI(:,7));
    % hold on
    % H2 = plot(1:length(LogI(:,7)), ones(length(LogI(:,7)),1).*mean(LogI(:,7)), 'r--')
    title('Working memory size')
    meanWM = mean(LogI(:,7))
    ylabel('WM size (locations)')
    xlabel('Location indexes')
    % set(H1,'color',[0.3 0.3 0.3])
    % set(H2,'color',[0 0 0])
    % subplot(212)
    % plot(LogI(:,6));
    meanDict = mean(LogI(:,6))
    % ylabel('Dictionary size')
    % xlabel('Location indexes')
end

meanWordsPerSign = mean(LogI(:,5))
%% -------------------------

if size(LogF, 2) > 19
    figure
    subplot(211)
    plot(LogF(:,20) + LogF(:,17)); %17 join or 19 empty trash
    ylabel('Time (s)')
    xlabel('Location indexes')
    subplot(212)
    plot(LogI(:,7));
    ylabel('WM size (locations)')
    xlabel('Location indexes')
end

%% -------------------------
% Detected/Accepted/Rejected loop closures

figure;
subplot(311)
plot(LogF(:,10), '.')
title('Highest posterior, green=accepted, red=rejected, blue=under T_{Loop}')
hold on
ylabel('p')
%rejected (by T_loop) hypotheses
y = LogF(:,10);
x = 1:length(y);
y(LogI(:, 1) == 0 & LogI(:, 8) ~= 0) = [];
x(LogI(:, 1) == 0 & LogI(:, 8) ~= 0) = [];
plot(x,y, 'b.')
%rejected (by ratio) hypotheses
y = LogF(:,10);
x = 1:length(y);
y(LogI(:, 8) == 0 | LogI(:, 1) > 0) = [];
x(LogI(:, 8) == 0 | LogI(:, 1) > 0) = [];
plot(x,y, 'r.')
%Accepted hypotheses
y = LogF(:,10);
x = 1:length(y);
y(LogI(:, 1) == 0) = [];
x(LogI(:, 1) == 0) = [];
plot(x,y, 'g.')
subplot(312)
plot(LogI(:,2), '.')
title('Id corresponding to highest posterior + lc accepted and rejected')
hold on
ylabel('Matched location index')
%rejected hypotheses
y = LogI(:,2);
x = 1:length(y);
y(LogI(:, 1) == 0 & LogI(:, 8) ~= 0) = [];
x(LogI(:, 1) == 0 & LogI(:, 8) ~= 0) = [];
plot(x,y, 'b.')
%rejected (by ratio) hypotheses
y = LogI(:,2);
x = 1:length(y);
y(LogI(:, 8) == 0 | LogI(:, 1) > 0) = [];
x(LogI(:, 8) == 0 | LogI(:, 1) > 0) = [];
plot(x,y, 'r.')
%Accepted hypotheses
y = LogI(:,2);
x = 1:length(y);
y(LogI(:, 1) == 0) = [];
x(LogI(:, 1) == 0) = [];
plot(x,y, 'g.')
subplot(313)
plot(LogI(:,5),'.')
title('wordsNewSign')
hold on
ylabel('words')
xlabel('Location indexes')
%rejected hypotheses
y = LogI(:,5);
x = 1:length(y);
y(LogI(:, 1) == 0 & LogI(:, 8) ~= 0) = [];
x(LogI(:, 1) == 0 & LogI(:, 8) ~= 0) = [];
plot(x,y, 'b.')
%rejected (by ratio) hypotheses
y = LogI(:,5);
x = 1:length(y);
y(LogI(:, 8) == 0 | LogI(:, 1) > 0) = [];
x(LogI(:, 8) == 0 | LogI(:, 1) > 0) = [];
plot(x,y, 'r.')
%Accepted hypotheses
y = LogI(:,5);
x = 1:length(y);
y(LogI(:, 1) == 0) = [];
x(LogI(:, 1) == 0) = [];
plot(x,y, 'g.')

set(datacursormode,'UpdateFcn',@(Y,X){sprintf('X: %0.2f',X.Position(1)),sprintf('Y: %0.2f',X.Position(2))})
% %matched sign words
% y = LogI(:,2);
% x = 1:length(y);
% mask = zeros(1,length(y));
% y(LogI(:, 8) ~= 11) = [];
% for i=1:length(y)
%     mask(y(i)) = 1;
% end
% y = LogI(:,5);
% y(~mask) = [];
% x(~mask) = [];
% plot(x,y, 'c.')
% %matched sign words for rejected
% y = LogI(:,2);
% x = 1:length(y);
% mask = zeros(1,length(y));
% y(LogI(:, 8) < 12) = [];
% for i=1:length(y)
%     mask(y(i)) = 1;
% end
% y = LogI(:,5);
% y(~mask) = [];
% x(~mask) = [];
% plot(x,y, 'm.')

lcAccepted = sum(LogI(:, 1) > 0)
lcReactivated = sum(LogI(:, 12) == 1)
lcIgnored = sum(LogI(:, 1) == 0 & LogI(:, 8) == 0)
lcRejected = sum(LogI(:, 8) == 1)

%figure;
%plot([1.0 * (LogI(:, 8) == 10) ... 
%      1.01 * (LogI(:, 8) == 11) ...
%      1.02 * (LogI(:, 8) == 14) ...
%      1.03 * (LogI(:, 8) == 15)], '.');
%title('Reject loop reason')
%legend('UNDEFINED', 'ACCEPTED', 'NOT ENOUGH MATCHING PAIRS', 'EPIPOLAR CONSTRAINT FAILED')

% -----------------
% Squared matrix



%%
%Precision-Recall graph
GroundTruthFile = [GT_file];
if ~isempty(GT_file) && exist(GroundTruthFile, 'file')
    PR = getPrecisionRecall(LogI, LogF, GroundTruthFile, 0.07);  
    
    Precision = PR(:,1);
    Recall = PR(:,2);
    PrecisionVerified = PR(:,3);
    RecallVerified = PR(:,4);
    
    %plot the Precision-Recall
    figure
    plot(Recall*100, Precision*100)
    %plot([Recall RecallVerified], [Precision PrecisionVerified])
    %legend('Without verification', 'With verification')
    %title('Precision-Recall curve')
    xlabel('Recall (%)')
    ylabel('Precision (%)')
else
    display('Precision-recall curve is not computed...');
end

%%
% count = 0;
% for i=2:length(LogF(:,10))
%     if(LogF(i,10) >= 0.03723 && LogF(i,10) < LogF(i-1,10)*0.90)
%         display(['i=' num2str(i) ' with=' num2str(LogI(i,2)) ' ratio=' num2str(LogF(i,10)/LogF(i-1,10))])
%         count = count +1;
%     end
% end
% count

%%
% figure
% hold on
% K=100;
% %plot(1./(K*LogF(:,15)), 'r')
% %plot(log10(1./(LogF(:,15))), 'c')
% scale=1;
% %plot(log10(1./(LogF(:,15))).^2 ./ ((LogF(:,12)-LogF(:,15))./LogF(:,14)), 'k')
% %plot(log10(1./(LogF(:,15))), 'm')
% plot((LogF(:,12)-LogF(:,15))./LogF(:,14), 'g')
% plot([0, length(LogF(:,15))], [1 1], 'k:')
% plot(LogF(:,11), 'b')
% %legend(['K=' num2str(K)], 'ln', 'ln scaled', 'log10', 'max sim', '1', 'Vp likelihood')

