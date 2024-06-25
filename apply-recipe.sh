#!/bin/bash

# This script should be stored and run from the sites folder with the command:
# ./apply-recipe.sh

# include.sh reads project.txt, asks for confirmation, and resets project folder if needed. 
source include.sh
cd $folder

read -p "Enter recipe name: bikeclub-" recipe

# Add bikeclub recipe repository to composer.json.
echo '<----------- Add recipe repository to composer.json -------------->'
ddev composer config repo.bikeclub-$recipe git "https://github.com/NCole29/bikeclub-$recipe"

# Composer require (download) bikeclub recipe repository.
echo '<----------- Download recipe repository to recipes/contrib -------------->'
ddev composer require bikeclub/bikeclub-$recipe:"^1.0"
ddev drush cr

# Apply the bikeclub recipe to Drupal website.
echo '<----------- Apply the bikeclub recipe -------------->'
ddev exec --dir /var/www/html/web php core/scripts/drupal recipe recipes/contrib/bikeclub-$recipe 
ddev drush cr

echo '<----------- Job completed -------------->'
echo ' Refresh your browser. If the site returns an error:'
echo '  - Go to the project folder in your terminal window and clear the cache: ddev drush cr'

