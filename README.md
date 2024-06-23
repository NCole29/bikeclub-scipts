# Bike Club Scripts

The two scripts in this repo will install Drupal and CiviCRM in a Docker/DDEV environment on your local computer.

See the **[Drupal documention](https://www.drupal.org/docs/develop/local-server-setup/windows-development-environment/installing-drupal-with-ddev-in-wsl2-on-windows)** for installing Docker and DDEV in Windows.

## How to Run the Scripts

Download the scripts and copy them to the **sites** folder in your local development environment.
Open a terminal window (e.g., the terminal in VS Code), navigate to the sites folder, and issue the following commands:
 
	./1-install-drupal.sh
	./2-install-civicrm.sh

Note: "./" must precede the file name to indicate that the script is in the current folder.	

## Description of 1-install-drupal.sh 

The script ... 
 1. **Prompts you for a folder name** and creates the folder. This will be the name of your site, for example, a folder named "test" results in a local site URL of https://test.ddev.site. 
 1. Configures the project folder and starts Docker containers.
 1. Downloads Drupal.
 1. Downloads and installs Drush.
 1. Configures Drupal for recipes.
 1. Sets the location for storing recipes (web/recipes/contrib).
 1. Uses Drush to:
		-  Install Drupal with the Minimal profile, **prompting you for an email and password for the admin account**.
		- Enable the toolbar module.
		- Enable the Olivero front-end theme and Claro admin theme.[^1]
 1. Creates the tmp/minimal folder and exports the database to tmp/minimal/db.sql.gz. This allows you to "start over" from an empty Drupal site, without reinstalling Drupal, by simply importing this database with the command "ddev import-db --file=tmp/minimal/db.sql.gz".
 
[^1]: The themes are installed with Drush because installing themes within a recipe results in duplicate blocks. 

## Description of 2-install-civicrm.sh 

The script ... 
 1. **Prompts you for the name of the folder** where you installed Drupal.
 1. Uninstalls Drush (due to conflicts during CiviCRM installation).
 1. Downloads CiviCRM. This may take awhile.
 1. **Prompts you to confirm default parameters for CiviCRM installation** by reviewing  web/sites/default/settings.ddev.php.
 1. Installs CiviCRM.
 1. Reinstalls Drush.
 1. Creates the tmp/civicrm folder and exports the database to tmp/civicrm/db.sql.gz. This allows you to "start over" from an empty Drupal-CiviCRM site by importing this database with the command "ddev import-db --file=tmp/civicrm/db.sql.gz".
 
