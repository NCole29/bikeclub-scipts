#!/bin/bash

# include.sh reads project.txt, asks for confirmation, and resets project folder if needed. 
source include.sh
cd $folder

read -p 'Name the export. What was the last recipe applied? ' dbdir

# Create tmp folder and export the database.
echo "<------------ Export database to tmp/$dbdir -------->"
cd tmp
mkdir $dbdir
cd ..
ddev export-db --file=tmp/$dbdir/db.sql.gz

echo ' '
echo '******** EXPORT IS COMPLETE ***************' 
echo " Database is backed up to tmp/$dbdir folder."
echo '--------------------------------------------'
