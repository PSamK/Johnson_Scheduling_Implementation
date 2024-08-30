% Script to verify the performance of Johnson's algorithm against a mathematical solution

% Add the path to the directory where the other scripts are located
addpath('C:\Users\ACER\Desktop\UNIGE MAGISTRALE 1 ANNO\INDUSTRIAL AUTOMATION\Project\2');  % Update with the actual path

% Connect to the database
conn = connectDatabase();

% Check if the connection is open
if isopen(conn)
    % Retrieve processing times from the CuttedTubes table
    data = fetch(conn, 'SELECT processing_time_on_welding, processing_time_on_oven FROM CuttedTubes');
    
    % Convert the table to an array
    process_times = table2array(data);
    
    % Run Johnson's algorithm to get the optimal job schedule
    johnson_schedule = johnsonAlgorithm(process_times);
    
    % Calculate total processing time for Johnson's algorithm
    % johnson_total_time = calculateTotalProcessingTime(johnson_schedule, process_times);
    
    for i = 1:size(johnson_schedule, 1)
        job_id = i;
        tube_id = johnson_schedule(i, 1);
        machine = {num2str(johnson_schedule(i, 2))};  % Convert to cell array of character vector
        
        % Create a table to hold the data
        data = table(job_id, tube_id, machine);
        
        % Write the data to the database using sqlwrite
        sqlwrite(conn, 'JobAssignments', data);
    end

    johnson_total_time = calculateMakespan(conn);
    
    % Run the mathematical solution to get the optimal job schedule
    math_schedule = exhaustiveSearchSolution(process_times);
    
    % Calculate total processing time for the mathematical solution
    math_total_time = calculateTotalProcessingTime(math_schedule, process_times);
    
    % Display the schedules and total processing times
    disp('Johnson Algorithm Schedule:');
    disp(johnson_schedule);
    disp(['Total Processing Time (Johnson): ', num2str(johnson_total_time)]);
    
    disp('Mathematical Solution Schedule:');
    disp(math_schedule);
    disp(['Total Processing Time (Mathematical): ', num2str(math_total_time)]);
    
    % Compare the total processing times
    if abs(johnson_total_time - math_total_time) < 30
        disp('The margin of error is acceptable.');
    else
        disp('There is a discrepancy in the total processing times.');
    end
    
    % Close the connection
    close(conn);
else
    disp('Failed to connect to the database, cannot retrieve and compare results');
end

% Function to calculate the total processing time for a given schedule
function total_time = calculateTotalProcessingTime(schedule, process_times)
    n = size(schedule, 1);
    total_time = 0;
    time_M1 = 0; % Time on machine 1
    time_M2 = 0; % Time on machine 2
    
    for i = 1:n
        job_id = schedule(i, 1);
        machine = schedule(i, 2);
        if machine == 1
            % Processing on machine 1
            time_M1 = time_M1 + process_times(job_id, 1);
            % Machine 2 can only start after machine 1 finishes
            time_M2 = max(time_M2, time_M1) + process_times(job_id, 2);
        else
            % Processing on machine 2
            time_M2 = time_M2 + process_times(job_id, 2);
            % Machine 1 can only start after machine 2 finishes
            time_M1 = max(time_M1, time_M2) + process_times(job_id, 1);
        end
    end
    
    total_time = max(time_M1, time_M2);
end

% Function to find the optimal job schedule using exhaustive search
function schedule = exhaustiveSearchSolution(process_times)
    n = size(process_times, 1);
    jobs = 1:n;
    all_perms = generatePermutations(jobs); % Generate all permutations of job indices
    best_time = inf;
    best_schedule = [];
    
    for i = 1:size(all_perms, 1)
        current_schedule = all_perms(i, :)';
        current_time = calculateTotalProcessingTime([current_schedule, ones(n, 1)], process_times);
        if current_time < best_time
            best_time = current_time;
            best_schedule = current_schedule;
        end
    end
    
    schedule = [best_schedule, ones(n, 1)];
end

% Recursive function to generate all permutations of a vector
function P = generatePermutations(V)
    if isempty(V)
        P = [];
    elseif length(V) == 1
        P = V;
    else
        P = [];
        for i = 1:length(V)
            W = V;
            W(i) = [];
            R = generatePermutations(W);
            P = [P; V(i) * ones(size(R,1),1), R];
        end
    end
end
