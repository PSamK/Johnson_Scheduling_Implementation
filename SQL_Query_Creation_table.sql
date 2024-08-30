USE LocalHost_IA

CREATE TABLE CuttedTubes (
    id INT PRIMARY KEY,
    batch_id INT,
    processing_time_on_welding INT,
    processing_time_on_oven INT
);

CREATE TABLE JobAssignments (
    job_id INT PRIMARY KEY,
    tube_id INT,
    machine VARCHAR(10),
    FOREIGN KEY (tube_id) REFERENCES CuttedTubes(id)
);