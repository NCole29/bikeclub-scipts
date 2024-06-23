#!/bin/bash
  
# If file does not exist, prompt for folder name.
if ! test -f project.txt; then
  read -p "Enter project folder name: " folder

  # Save folder name to file.
  printf "%s" "$folder" > "project.txt"
else

  # If file exists, read folder name from file and confirm with user.
  folder="$(cat project.txt)"
  # Prompt user. 
  echo -n "Project is $folder. Is this correct? [y/n]: "
  read -r ans

  # If not correct, prompt for folder name.
  if test $ans = n; then
    read -p "Enter project folder name: " folder

    # Save project folder name to file.
    printf "%s" "$folder" > "project.txt"
  fi  
fi
	
