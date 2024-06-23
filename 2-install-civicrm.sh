#!/bin/bash

# Source: https://docs.civicrm.org/installation/en/latest/drupal/

# include.sh reads project.txt, asks for confirmation, and resets project folder if needed. 
source include.sh

cd $folder

# Uninstall Drush.
echo '<--------- Uninstall Drush due to symfony comflicts with CiviCRM. Will reinstall later. ------->'
ddev composer remove drush/drush

# Require CiviCRM.
echo '<----------- Download CiviCRM (this may take awhile) -------------------------->'
ddev composer require civicrm/civicrm-{core,packages,drupal-8}
ddev composer require civicrm/cli-tools --with-all-dependencies

# Get parameters for CiviCRM installation.
echo ' '
echo '<----------- Check parameters for CiviCRM installation  -------------------------->'

echo 'This script assumes the following values:'
echo ' '
echo "  1. Your site URL is https://$folder.ddev.site" 
echo '  2. Values for host, port, database, username, and password on lines 10-16 of web/sites/default/settings.ddev.php:' 
echo ' '
echo "      10 \$host = \"db\";"
echo "      11 \$port = 3306;"
echo "      12 \$driver = \"mysql\";"
echo "      13  "
echo "      14 \$databases['default']['default']['database']" = '"db";'
echo "      15 \$databases['default']['default']['username']" = '"db";'
echo "      16 \$databases['default']['default']['password']" = '"db";'
echo ' '
echo "Do these values match your settings.ddev.php file?"

select yn in "Yes" "No"; do
    case $yn in
        Yes ) break;;
        No ) 
          echo 'Script cannot continue.'
          echo 'Copy and execute the following two commands after replacing [] values with your url and values from settings.ddev.php.' 
          echo 'ddev exec cv core:install --cms-base-url="[url]" --db="mysql://[username]:[password]@[host]:[port]/[database]'
          echo 'ddev composer require drush/drush'
          echo ''
          echo 'Example for recipe-test site with default database values:'
          echo 'ddev exec cv core:install --cms-base-url="https://recipe-test.ddev.site" --db="mysql://db:db@db:3306/db'
          exit;;
    esac
done

# Install CiviCRM.
echo '<----------- Install CiviCRM (be patient!) -------------------------->'
ddev exec cv core:install --cms-base-url="https://$folder.ddev.site" --db="mysql://db:db@db:3306/db"

# Install Drush.
echo '<----------- Install Drush and clear cache ------------------------------->'
ddev composer require drush/drush
ddev drush cr

# Create tmp folder, export database, ad copy composer files.
echo '<------------ Export database to tmp/civicrm-------->'
cd tmp
mkdir civicrm
cd ..
ddev export-db --file=tmp/civicrm/db.sql.gz

echo '<------------ Copy composer files to tmp/ ---------->'
cp composer.json tmp/civicrm/composer.json
cp composer.lock tmp/civicrm/composer.lock

echo ' '
echo '******************* SETUP IS COMPLETE **************************' 
echo ' CiviCRM installation is complete.'
echo ' Database and composer files are backed up to tmp/civicrm folder.' 
echo '-----------------------------------------------------------------'

