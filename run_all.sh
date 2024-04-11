#!/bin/bash

# This file should be ran inside the optimum-benchmark folder and we need to be careful with the config directory and file pattern in order for it to properly run. 

# Forcing the script to take 3 arguments
if [ $# -ne 3 ]; then
  echo "Usage: $0 <config-dir> <config-name-pattern> <results-base-dir>"
  exit 1
fi

# The directory containing the config files
CONFIG_DIR="$1"

# The pattern to filter config files
CONFIG_NAME_PATTERN="$2"

# The directory in which the results will be stored
RESULTS_BASE_DIR="$3"

echo "Looking for config files in $CONFIG_DIR with pattern $CONFIG_NAME_PATTERN"

# Find and loop through all matching config files in dir
find "$CONFIG_DIR" -name "*$CONFIG_NAME_PATTERN*.yaml" -print0 | while IFS= read -r -d $'\0' CONFIG_FILE; do
    CONFIG_NAME=$(basename "$CONFIG_FILE" .yaml)

    echo "Running experiment for config: $CONFIG_NAME"

    # Run the command for the current config file (we can modify the config file by adding arguments to this cmd)
    optimum-benchmark --config-dir "$CONFIG_DIR" --config-name "$CONFIG_NAME"

    echo "Experiment for $CONFIG_NAME completed."
done

echo "All experiments completed."

echo "Making the plots."

# Calling the python pipeline to create the plots
python3 plot_pipeline.py "$RESULTS_BASE_DIR"

echo "Plots created and saved in /plots/"

