#!/bin/bash

# Define the number of cores to use
CORES=8

# Function to process a single item
process_item() {
    # Replace this command with your actual processing command
    ./data_prepare_one.sh "$1"
}

# Export the function to make it available to parallel
export -f process_item

# Read the input file and process each item in parallel
parallel --verbose -j $CORES -k process_item :::: lists/masif_site_only.txt
