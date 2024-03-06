#!/bin/bash
##### This script is useful for generating a project with  necessary terraform files #####
#### NOTE: Execute this script from directory where you want to create a new terraform project#####

# provide your project name
TF_PROJECT_NAME=my-terraform-project

mkdir $TF_PROJECT_NAME

tffiles=('main' 'variables' 'providers' 'versions' 'outputs'); for file in "${tffiles[@]}" ; do touch "$TF_PROJECT_NAME/$file".tf; done