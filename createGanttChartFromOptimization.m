function createGanttChartFromOptimization(processing_times, optimalJobSequence)
    % Transpose the processing times matrix for compatibility
    p = processing_times';
    
    % Define the number of jobs and machines
    [numMachines, numJobs] = size(p);

    % Initialize arrays for end times
    M1_end = zeros(numJobs, 1);
    M2_end = zeros(numJobs, 1);

    % Calculate end times for jobs on M1 and M2 based on the optimal sequence
    for i = 1:numJobs
        job_idx = optimalJobSequence(i);
        
        % Ensure job_idx is a valid index
        if job_idx < 1 || job_idx > numJobs
            error('Invalid job index: %d', job_idx);
        end
        
        % Get processing times
        processing_time_on_welding = p(1, job_idx);
        processing_time_on_oven = p(2, job_idx);
        
        if i == 1
            % First job
            M1_end(i) = processing_time_on_welding;
            M2_end(i) = M1_end(i) + processing_time_on_oven;
        else
            % Subsequent jobs
            M1_end(i) = M1_end(i-1) + processing_time_on_welding;
            M2_end(i) = max(M1_end(i), M2_end(i-1)) + processing_time_on_oven;
        end
    end

    % Create the Gantt chart
    figure;
    hold on;
    max_time = max(M2_end); % Find the maximum time for scaling the grid
    for i = 1:numJobs
        job_idx = optimalJobSequence(i);
        
        % Get processing times
        processing_time_on_welding = p(1, job_idx);
        processing_time_on_oven = p(2, job_idx);
        
        % Plot welding (machine 1) as yellow squares
        for t = 0:(processing_time_on_welding-1)
            rectangle('Position', [M1_end(i) - processing_time_on_welding + t, numJobs - i + 0.5, 1, 1], ...
                'FaceColor', 'yellow', 'EdgeColor', 'k');
        end
        
        % Plot oven (machine 2) as blue squares
        for t = 0:(processing_time_on_oven-1)
            rectangle('Position', [M2_end(i) - processing_time_on_oven + t, numJobs - i + 0.5, 1, 1], ...
                'FaceColor', 'cyan', 'EdgeColor', 'k');
        end
    end
    xlabel('Time');
    ylabel('Job');
    title('Gantt Chart from Optimization');
    set(gca, 'YTick', 1:numJobs, 'YTickLabel', flip(optimalJobSequence));
    xlim([0 max_time]);
    ylim([0 numJobs+1]);
    grid on;
    hold on;
end
