# Dynamic Channel Tracking with Approximate Message Passing (AMP)

This repo implements a low-complexity, sparse signal recovery framework for tracking dynamic & time-varying wireless channels. By integrating Side-Information (SI) into an Approximate Message Passing (AMP) algorithm, this project significantly improves sequential channel estimation accuracy.

## Technical Stack
* **Language:** MATLAB
* **Toolboxes:** Statistics and Machine Learning Toolbox, Signal Processing Toolbox

## Repository Structure

* `main.m`: The primary execution script. Defines system parameters, orchestrates the simulation & plots the Mean Square Error (MSE) performance.
* `generate_dynamic_channel.m`: Simulates the ground-truth environment. It handles the mathematical evolution of the channel taps over time.
* `amp_dynamic_tracker.m`: The core message-passing algorithmic loop. 
* `adaptive_denoiser.m`: Contains the advanced mathematical logic for the denoiser. Integrates the side-information weights to dynamically adjust the soft-thresholding penalties.

## Results and Visualization
Running the simulation generates two primary evaluations:
1. **Normalized MSE over Time:** Demonstrates the impact of the side-information. While the initial time slot exhibits higher error, subsequent slots show a sharp, stable drop in NMSE as the prior knowledge is recursively fed back into the denoiser.
2. **Channel Snapshot:** A 2D stem plot visually validating the AMP estimate against the true sparse channel paths at a specific time slot, proving the algorithm's capability to reconstruct underdetermined signals.

