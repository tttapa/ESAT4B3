function [ RESULT_peaks, RESULT_locations ] = getPeaks( INPUT_data, INPUT_checkEdges, INPUT_checkHeight, INPUT_minPeakHeight, INPUT_checkDistance, INPUT_minPeakDistance )
% FIND_PEAKS returns a list of peaks and their respective locations from a signal
% TODO: cleanup
% @param INPUT_data - column vector of data
% @param INPUT_checkEdges - whether a peak at the edge of the data will
%                           be included
% @param INPUT_checkHeight - whether the algorithm will consider the
%                            minimum peak height
% @param INPUT_minPeakHeight - minimum height of a peak
% @param INPUT_checkDistance - whether the algorithm will consider th
%                              minimum distance between peaks
% @param INPUT_minPeakDistance - minimum distance between peaks


%%
% SETUP
%

% Based on the number of inputs we get, decide whether we will check the
% peak heights/distances to the inputs.
if nargin == 1
    checkEdges = true;
    checkHeight = false;
    checkDistance = false;
elseif nargin == 2
    checkEdges = INPUT_checkEdges;
    checkHeight = false;
    checkDistance = false;
elseif nargin <= 4
    checkEdges = INPUT_checkEdges;
    checkHeight = INPUT_checkHeight;
    checkDistance = false;
else
    checkEdges = INPUT_checkEdges;
    checkHeight = INPUT_checkHeight;
    checkDistance = INPUT_checkDistance;
end

% Keep track of which sample we are currently on. This will go from samplej
% 2 to sample length(INPUT_data) - 1
counter = 2;
totalCount = length(INPUT_data) - 1;

% Memory
mem_prev = 0;
mem_cur = INPUT_data(1, 1);
mem_next = INPUT_data(2, 1);

% Storing the peaks/locations
tempPeaks = [];
tempLocations = [];


%%
% EXECUTION
%

if checkEdges
    
    % SPECIAL CASE - sample 1 > sample 2. This should be considered a possible
    % peak.
    if mem_cur > mem_next

        % Verify that the height is greater than minPeakHeight
        if ~checkHeight || (checkHeight && mem_cur >= INPUT_minPeakHeight)
            tempPeaks(length(tempPeaks) + 1, 1) = mem_cur;
            tempLocations(length(tempLocations) + 1, 1) = 1;
        end
    end
    
end



% Go through the input data and save all the possible peaks
while counter <= totalCount
    
    % Shift our comparison
    mem_prev = mem_cur;
    mem_cur = mem_next;
    mem_next = INPUT_data(counter+1, 1);
    

    % If the current element is greater than or equal to its neighbors,
    % it could be our new highest value
    % > , >= so that we only get the first location if two adjacent peaks 
    % have the same height 
    if (mem_cur > mem_prev && mem_cur >= mem_next)
        
        % Verify that the height greater than the minPeakHeight
        if ~checkHeight || (checkHeight && mem_cur >= INPUT_minPeakHeight)
            tempPeaks(length(tempPeaks)+1, 1) = mem_cur;
            tempLocations(length(tempLocations)+1, 1) = counter;
        end
    end
    
    counter = counter + 1;


end


if checkEdges
    
    % SPECIAL CASE - last sample > second-to-last sample. This should be
    % considered a possible peak.
    if mem_next > mem_cur

        % Verify that the height is greater than minPeakHeight
        if ~checkHeight || (checkHeight && mem_next >= INPUT_minPeakHeight)
            tempPeaks(length(tempPeaks)+1, 1) = mem_next;
            tempLocations(length(tempLocations)+1, 1) = totalCount + 1;
        end
    end
    
end



% Initialize the result variables, so we don't have to resize them
% every time we find another peak.
RESULT_peaks = zeros(length(tempPeaks), 1);
RESULT_locations = zeros(length(tempLocations), 1);

% Now do the minimum peak distance
if checkDistance && length(tempPeaks) > 0
    
    % Counters to compare the location of the next possible peak (counter)
    % and the location of the last peak in the result (resultIndex).
    counter = 2;
    totalCount = length(tempPeaks);
    resultIndex = 1;
    
    % Initialize the first element of the result variables
    RESULT_peaks(1, 1) = tempPeaks(1, 1);
    RESULT_locations(1, 1) = tempLocations(1, 1);
    
    % Go through all the peaks
    while counter <= totalCount
        
        % Save the locations
        location1 = RESULT_locations(resultIndex, 1);
        location2 = tempLocations(counter, 1);
        
        % If the locations are too close to each other
        if location2 - location1 < INPUT_minPeakDistance
           
            % Save the peaks
            peak1 = RESULT_peaks(resultIndex, 1);
            peak2 = tempPeaks(counter, 1);
            
            % Store the larger peak
            if peak1 >= peak2
                RESULT_peaks(resultIndex, 1) = peak1;
                RESULT_locations(resultIndex, 1) = location1;
            else
                RESULT_peaks(resultIndex, 1) = peak2;
                RESULT_locations(resultIndex, 1) = location2;
            end
            
        else
            
            % The peaks are far enough apart, so save the peak in the next
            % spot in the result
            resultIndex = resultIndex + 1;
            RESULT_peaks(resultIndex, 1) = tempPeaks(counter, 1);
            RESULT_locations(resultIndex, 1) = tempLocations(counter, 1); 
            
        end
        
        counter = counter + 1;
        
    end
    
    RESULT_peaks = RESULT_peaks(1:resultIndex, 1);
    RESULT_locations = RESULT_locations(1:resultIndex, 1);
    
else
    
    RESULT_peaks = tempPeaks;
    RESULT_locations = tempLocations;
    
end







end

