#!/bin/bash


# include.sh reads project.txt, asks for confirmation, and resets project folder if needed. 
source include.sh
cd $folder

echo 'Databases available for import are identified by subfoders under tmp/'
read -p 'Enter database (minimal, civicrm, or other): ' db

# Import database from temp/minimal.
echo "<----------- Import database from temp/$db -------------->"
ddev import-db --file=tmp/$db/db.sql.gz

# Clear cache.
echo '<----------- Clear cache -------------->'
ddev drush cr
echo '<----------- Job complete -------------->'