# Johnson_Scheduling_Implementation

## Introduction

The Johnson Scheduling Algorithm is a classic optimization technique used to solve the scheduling problem for two machines with the goal of minimizing the total completion time. This problem is commonly encountered in manufacturing and production environments where tasks must be processed in sequence on two machines.

## Project Overview

This project implements the Johnson Scheduling Algorithm to solve the two-machine scheduling problem. The algorithm is designed to find the optimal sequence for a set of tasks, each with specified processing times on two machines, to minimize the total completion time.

## The project includes:
- Database Design and Implementation:
We created tables in Microsoft SQL Server (SSMS 2023) to store information about the cut tubes and the job assignments to the machines. These tables include attributes such as:
   - id: Unique identifier for each tube.
   - batch_id: Identifier for the batch of tubes.
   - processing_time_on_welding: Time required for welding.
   - processing_time_on_oven: Time required for oven processing.

## Methodology

The project follows these steps:

1. **Data Retrieval**:
   - Connect to a local SQL server to fetch task data.
   - The data includes task names and processing times on two machines.

2. **Algorithm Implementation**:
   - **Partitioning**: Divide tasks into two groups based on their processing times on the two machines.
   - **Sequencing**: Order tasks in the first group by increasing processing times on the first machine and tasks in the second group by decreasing processing times on the second machine.
   - **Execution**: Implement the Johnson Scheduling Algorithm in MATLAB to compute the optimal task sequence.

3. **Results Comparison**:
   - Compare the output of the Johnson algorithm with other scheduling methods.
  
## Tools Used

- **MATLAB**: For implementing the scheduling algorithm and interacting with the SQL database.
- **Database Toolbox in MATLAB**: To connect to and interact with the SQL Server database.
- **Microsoft SQL Server (SSMS 2023)**: To create a local database instance where the required tables are stored.
- **SQL Scripts**: Provided to create the necessary tables and insert data.

## Project Setup

### Prerequisites

- **MATLAB**: Ensure MATLAB is installed along with the Database Toolbox.
- **SQL Server Instance**: Create a local SQL Server database using SSMS 2023.

### Steps to Set Up

1. **Modify Paths**: Update the paths in the provided MATLAB scripts to match your local environment.

2. **Create a Database Instance**:
   - Create a local SQL Server database instance using SSMS.
   - Set the database name, username, and any relevant paths.

3. **Update Connection Script**:
   - Edit the `connectdatabase.m` script with the correct database name, username, and paths.

4. **Run the SQL Scripts**:
   - Execute the provided SQL scripts to create the necessary tables and load the initial data.

5. **Test the Setup**:
   - First, run the `addData_tables.m` script to populate the database.
   - After that, run the `mainScript` MATLAB code to perform the job scheduling and other operations.

## Known Issues

- **CreateGanttChart Script**: The `CreateGanttChart.m` script has a known issue where the data sorting is incorrect, leading to an inaccurate Gantt chart. The job assignments are not displayed in the correct order.

## Authors

- [Martin Martuccio](https://github.com/Martin-Martuccio) - Project Author
- [Samuele Pellegrini](https://github.com/PSamK) - Project Author
- [Daniel Brendo Flores Mendoza](https://github.com/FMDani) - Project Author

![Build Status](https://img.shields.io/badge/build-passing-brightgreen)
![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
