#!/bin/bash

read -p "Enter project folder name: " folder
mkdir $folder
cd $folder

# Configure project folder, start containers, and install Drupal and Drush
echo '<----------- Configure project folder ------------------------------->'
ddev config --project-type=drupal10 --docroot=web

echo '<----------- Starting containers ------------------------------->'
ddev start
ddev composer create drupal/recommended-project

# All 3 drupal/core- requires can be on the same line. Broken up here to create composer.json and set min stability before requiring drupal-core-recommended.
echo '<----------- Download Drupal 10.3 ------------------------------->'
ddev composer require drupal/core-project-message:10.3.0-rc1@RC
ddev composer config minimum-stability dev
ddev composer require drupal/core-recommended:10.3.0-rc1@RC drupal/core-composer-scaffold:10.3.0-rc1@RC --update-with-all-dependencies

# Configure Drupal to Apply Recipes.
# Source: https://git.drupalcode.org/project/distributions_recipes/-/blob/1.0.x/docs/getting_started.md.

# Configure Composer Patches.
echo '<----------- Configure composer patches ------------------------------------>'
ddev composer config allow-plugins.cweagans/composer-patches true
ddev composer require cweagans/composer-patches

# Drupal core patch is not needed for Drupal 10.3.

# Configure the location for storing recipes.
echo '<----------- Configure the location for storing recipes -------------------->'
ddev composer config allow-plugins.oomphinc/composer-installers-extender true
ddev composer config extra.installer-types --merge --json '["drupal-recipe"]'
ddev composer config extra.installer-paths --merge --json '{"web/recipes/contrib/{$name}": ["type:drupal-recipe"]}'
ddev composer require oomphinc/composer-installers-extender

# Require Drupal Recipe Unpack.
echo '<----------- Require Drupal Recipe Unpack ------------------------------>'
ddev composer config allow-plugins.ewcomposer/unpack true
ddev composer config repo.recipe-unpack vcs https://gitlab.ewdev.ca/yonas.legesse/drupal-recipe-unpack.git 
ddev composer require ewcomposer/unpack:dev-master

# Install Drush.
echo '<----------- Install Drush ------------------------------->'
ddev composer require drush/drush

# Successfully installing a recipe requires the site be installed.  
# For minimal configuration collisions it may be optimal to use the minimal install profile.

# Install Drupal with Minimal profile.
echo '<----------- Install Drupal with Minimal profile ------------------------------->'
echo 'Provide administrator login credentials'
read -p "Site name: " sitename
read -p "Admin email: " email
read -p "Admin password: " pswd

ddev drush si minimal --site-name=$sitename --account-name=admin --account-mail=$email --account-pass=$pswd -y

echo '<----------- Clearing cache ------------------------------------>'
ddev drush cr

# Enable the toolbar.
echo '<------------- Enable Toolbar -------------->'
ddev drush en toolbar, breakpoint -y

# Enable Claro and Olivero themes. Doing this in a recipe results in duplicate blocks.
echo '<------------- Enable Claro and Olivero themes -------------->'
ddev drush theme-enable claro, olivero
ddev drush config-set system.theme default olivero -y
ddev drush config-set system.theme admin claro -y

# Create tmp folder, export database, ad copy composer files.
echo '<------------ Export database to tmp/minimal-------->'
mkdir tmp
cd tmp
mkdir minimal
cd ..
ddev export-db --file=tmp/minimal/db.sql.gz

echo '<------------ Copy composer files to tmp/ ---------->'
cp composer.json tmp/minimal/composer.json
cp composer.lock tmp/minimal/composer.lock

echo ' '
echo '******************* SETUP IS COMPLETE **********************************' 
echo ' Drupal 10.3 is installed with Minimal profile.'
echo ' Database and composer files are backed up to tmp/minimal folder.' 
echo " Login to administrator account with username: admin, password: $pswd"
echo '------------------------------------------------------------------------'
