#!/bin/bash

# Silencing the GNU Parallel citation notice
parallel --citation < /dev/null

# Directory containing your projects
PROJECTS_DIR=$(pwd)

# Find all projects with a molecule directory and run them in parallel
#find "$PROJECTS_DIR" -type d -name molecule | parallel -j 4 'cd {//} && molecule test'
find "$PROJECTS_DIR" -type d -name molecule | parallel -j 4 --progress --verbose 'cd {//} && molecule test'
