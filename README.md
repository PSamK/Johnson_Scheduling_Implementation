# Johnson_Scheduling_Implementation

## Introduction

The Johnson Scheduling Algorithm is a classic optimization technique used to solve the scheduling problem for two machines with the goal of minimizing the total completion time. This problem is commonly encountered in manufacturing and production environments where tasks must be processed in sequence on two machines.

## Project Overview

This project implements the Johnson Scheduling Algorithm to solve the two-machine scheduling problem. The algorithm is designed to find the optimal sequence for a set of tasks, each with specified processing times on two machines, to minimize the total completion time.

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

## Repository Structure

- **README.md**: This file, providing an overview and instructions for the project.

## Authors

- [Martin Martuccio](https://github.com/Martin-Martuccio) - Project Author
- [Samuele Pellegrini](https://github.com/PSamK) - Project Author

![Build Status](https://img.shields.io/badge/build-passing-brightgreen)
![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
