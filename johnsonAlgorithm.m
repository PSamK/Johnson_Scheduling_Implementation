function schedule = johnsonAlgorithm(process_times)
    % Function to implement Johnson's algorithm

% General concept
% n/m/A/B
% n: numeber of jobs
% m number of machines
% A workflow
% B performance index (E.g. # jobs that are late)
% (optional) F flow-shop policy
% G general job-shop

% Johnson algorithm
% n/2/F/F_max
% Performance index : minimizes the flow time throught the 2 machines
% 
% 1) K=1; l = n;
% 2) Unscheduled jobs = {J_1, J_2, ..., J_n}
% 3) Find the minimum between a_i and b_i
%  a_i      b_i
% (M1) --> (M2) 
% a_i = it is the working time needed for the job a_i
% 4) If the minimum was a_i corresponding to J_i
%   - Put J_i in position k of the scheduled jobs
%   - Delete J_i from the unscheduled jobs
%   - k = k + 1
%   - Go to 6)
% 5) If the minimun was b_i corresponding to J_i
%   - Put J_i in position i of the scheduled jobs (end of queue)
%   - Delete J_i from the unscheduled jobs
%   - Go to 6)
% 6) If the list of unscheduled jobs is not empty go to 3; 
%    otherwise the list of scheduled jobs is optimal according to F_max
 
% How it works
% The key points of finding the minimum processing time, 
% assigning jobs to the start or end of the schedule based on the machine, 
% and updating the pointers and job lists are correctly implemented. 
% The algorithm follows the intended logic to minimize the total flow time 
% through the two machines

%   1) Initialize start and end pointers
    k = 1; % Pointer for the start of the schedule
    l = size(process_times, 1); % Pointer for the end of the schedule
    process_times_sorted = process_times;

%   2) List of unscheduled jobs
    unscheduled_jobs = 1:l;

%   Initialize the schedule array
    schedule = zeros(l, 2); % First column for job ID, second for machine assignment

%   3) Continue scheduling until all jobs are scheduled
    while ~isempty(unscheduled_jobs)
        % Find the minimum processing time among all unscheduled jobs
        [min_val, min_idx] = min(process_times_sorted(unscheduled_jobs, :), [], 'all', 'linear');
        [row, col] = ind2sub(size(process_times_sorted(unscheduled_jobs, :)), min_idx);
        job_idx = unscheduled_jobs(row); % Get the job index

%       4) If the minimum processing time is for the first machine (M1)
        if col == 1
%           Assign job to the current start position
            schedule(k, :) = [job_idx, 1]; % Assign to machine 1
            k = k + 1; % Move the start pointer forward
        else
%           5) If the minimum processing time is for the second machine (M2)
%           Assign job to the current end position
            schedule(l, :) = [job_idx, 2]; % Assign to machine 2
            l = l - 1; % Move the end pointer backward
        end

%       Remove the job from the list of unscheduled jobs
        unscheduled_jobs(row) = [];
    end
end
