#!/bin/bash

cd recipe-test

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
