#!/bin/bash - 
#===============================================================================
#
#          FILE: drupal8.new.installation.sh
# 
#         USAGE: ./drupal8.new.installation.sh 
# 
#   DESCRIPTION: Installation CMS Drupal 8 with any modules, themes and create GIT repository
# 
#       OPTIONS: ---
#  REQUIREMENTS: composer, git, mysqladmin, sed, mysqldump
#          BUGS: ---
#         NOTES: For Windows 10 - rename this script with suffix *.ps1
#                instead of *.sh
#        AUTHOR: Václav Kacetl (Copyleft)
#  ORGANIZATION: OdulaNet
#       CREATED: 14.1.2020 10:46:11 CET
#      REVISION: 0.1.0
#===============================================================================
set -o nounset                   # Treat unset variables as an error
# Time of start run script
START_TIME=$(date +%H:%M:%S)
# Reset colors
CN='\033[0m'       # Text Reset
# Regular Colors
BLACK='\033[0;30m'        # Black
RED='\033[0;31m'          # Red
GREEN='\033[0;32m'        # Green
YELLOW='\033[0;33m'       # Yellow
BLUE='\033[0;34m'         # Blue
PURPLE='\033[0;35m'       # Purple
CYAN='\033[0;36m'         # Cyan
WHITE='\033[0;37m'        # White
# list of modules to install                         
MODULES=(
    "ctools" \
    "backup_migrate" \
    "devel" \
    "adminimal_admin_toolbar" \
    "adminimal_theme" \
    "ultimate_cron" \
    "twig_tweak" \
    "layout_builder_kit" \
    "ds" \
    "token" \
    "pathauto:^1.6" \
    "antibot" \
    "allowed_formats" \
    "anchor_link" \
    "entityqueue" \
    "auto_entityqueue" \
    "betterlogin" \
    "block_visibility_groups" \
    "captcha" \
    "recaptcha" \
    "coffee" \
    "colorbox" \
    "db_maintenance" \
    "eva" \
    "rabbit_hole" \
    "pathologic" \
    "linkit" \
    "imce" \
    "libraries" \
    "fontawesome" \
    "field_tools" \
    "file_mdm" \
    "image_url_formatter" \
    "imageapi_optimize" \
    "imageapi_optimize_resmushit" \
    "masquerade" \
    "menu_manipulator" \
    "module_filter" \
    "responsive_favicons" \
    "save_edit" \
    "security_review" \
    "site_alert" \
    "sitemap" \
    "spamspan" \
    "svg_image" \
    "svg_image_field" \
    "taxonomy_manager" \
    "transliterate_filenames" \
    "typed_data" \
    "views_conditional" \
    "zurb_foundation:^6.0" \
    "field_orbit:^1.0" \
    "foundation_layouts:^6.0" \
    "xy_grid_layouts:^2.0" \
    "twig_xdebug" \
    "file_permissions" \
    "paragraphs" \
    "webform:^5.6" \
)
printf "\n\n${BLUE} ==================================================\n"
printf "  ${CYAN}CMS Drupal 8 installation use Composer and Drush${BLUE}\n"
printf " ==================================================\n"
printf "                 version: 0.1.0        \n\n"
printf "                      ';               \n"
printf "                      oOx;             \n"
printf "                    .dOOo:,            \n"
printf "                .;okOO:   ..           \n"
printf "              ,xOOOOO;  oOOOOl         \n"
printf "             dOOOOOOO. .OOOOOO. 'l     \n"
printf "            oOOOOOOOOl  ;xOOx,  oOx    \n"
printf "           .OOOOOOd;.         'dOOOo   \n"
printf "           .OOOOx.   .''.    oOOOOOO   \n"
printf "            kOOk.  'xOOOOk:   dOOOOo   \n"
printf "            'OOl  .OOOOOOOO'  ,OOOk.   \n"
printf "             .ko   xOOOOOOk.  :OOd.    \n"
printf "               ;'   ;dkOxc.  .kd'      \n"
printf "                            .,.        \n"
printf "                                       ${CN}\n"
# Drupal 8 core installation
printf "${CYAN} This script will install DRUPAL 8's filesystem,\n"
printf " some modules, database, Zurb theme and create\n"
printf " GIT repository with checkout to new Devel branch.\n\n"
printf " New project will be installed in the CURRENT directory.\n"
printf " It's must be empty.${CN}\n\n"
printf " 1. >> New Drupal 8 core installation\n"
printf "${BLUE} 2. Installatin of more modules\n"
printf " 3. Setup Drupal 8 database and backup it\n"
printf " 4. Create GIT repository with new branch${CN}\n\n"

# Question for project directory:
while true; do
    printf "${GREEN} Are you in this directory:${CN}\n\n"
    printf "${YELLOW} $(pwd)\n\n"
    printf "${GREEN} Do you want to create the new Drupal 8 project here?${CN} [y|n]:\n"
    read -p " > " yn
    case $yn in
        [Yy]* )
            break ;;
        [Nn]* )
            printf "${RED}\n Please go to the new project directory and run this script again.${CN}\n\n";
            exit ;;
        * )
            printf "\n${RED} Please enter y|Y or n|N.${CN}" ;;
    esac
done
printf "${GREEN} Please, enter a project name: ${CN}\n"
read -p " > "  PROJECTNAME
printf "\n${YELLOW} Install project Drupal 8 to directory: ${CYAN}${PROJECTNAME}/${YELLOW}.${CN}\n"
printf "\n${BLUE} Download and install new Drupal 8 core...${CN}\n\n"
COMPOSER_MEMORY_LIMIT=-1 composer create-project drupal-composer/drupal-project:8.x-dev ${PROJECTNAME} &&
printf "\n\n${YELLOW} The project >>${CYAN} ${PROJECTNAME} ${YELLOW}<< has been installed.${CN}\n\n"
#cd ${PROJECTNAME}

# Question of modules installation
printf "\n${BLUE} 1. New Drupal 8 core installation\n"
printf "${WHITE} 2. >> Installatin of more modules${BLUE}\n"
printf " 3. Setup Drupal 8 database and backup it\n"
printf " 4. Create GIT repository with new branch${CN}\n\n"
printf "\n\n${GREEN}    Select the modules which you want to install:${CN}\n"
printf "    ---------------------------------------------\n"
for item in ${MODULES[*]}
do
    printf "${BLUE}${item}${CN}, "
done
printf "   %s\n"
printf "    ---------------------------------------------\n"
printf "\n"
while true; do
    printf "${GREEN} Do you want to install all modules at once or individually?\n"
    printf " ${WHITE}a${GREEN} - for all, ${WHITE}i${GREEN} - for individually modules installation${CN} [a|i]: "
    read -p " > " ai
    case $ai in
        [Aa]* ) 
        NUMBER=1
        for item in ${MODULES[*]}
        do
            printf "\n${YELLOW} --------------------------------------------------\n"
            printf " * [${WHITE} ${NUMBER}/${#MODULES[*]} ${YELLOW}] - ${BLUE} $item ${YELLOW}"
            printf "\n -------------------------------------------------- ${CN}\n"
            composer require drupal/${item} --update-with-all-dependencies &&
            ((NUMBER=NUMBER+1))
        done               
        break ;;
        [Ii]* ) 
        NUMBER=1
        for item in ${MODULES[*]}
        do
            while true; do
            printf "${GREEN} * [${WHITE}${NUMBER}/${#MODULES[*]}${GREEN}] >> Do you want install modul ${YELLOW}$item?${CN} [y|n]:\n "
            read -p " > ${NC}" yn
                case $yn in
                        [Yy]* ) composer require drupal/$item --update-with-all-dependencies &&
                            break ;;
                        [Nn]* ) 
                            break ;;
                        * ) 
                            printf "\n${RED} Please enter y|Y or n|N.${NC}\n\n" ;;
                esac                        
            done
            ((NUMBER=NUMBER+1))                     
        done
        break ;;
        * ) printf "${RED} Please enter a|A or i|I.${NC}\n\n" ;;
    esac
    sleep 2
done
sleep 2
printf "\n${GREEN} Create config/sync/ directories:\n"
mkdir -p config/sync &&
chmod -R 777 config &&
printf "\n"
printf "\n${GREEN} Set parameter: ${CN}[update_free_access] ${GREEN}in ${BLUE}settings.php ${GREEN}file to${CN} TRUE\n"
sed -i -e "s/access'] = FALSE/access'] = TRUE/g" web/sites/default/settings.php &&
printf "\n${BLUE} 1. New Drupal 8 core installation\n"
printf " 2. Installatin of more modules\n"
printf "${WHITE} 3. >> Setup Drupal 8 database and backup it${BLUE}\n"
printf " 4. Create GIT repository with new branch${CN}\n\n"
while true; do
    printf "${GREEN} Do you want create a new database for this project?${CN} [y|n]:\n"
    read -p " > " yn
    case $yn in
        [Yy]* )
            printf "\n${GREEN} Enter administrator ${YELLOW}USER NAME${GREEN} for your database server:${CN}\n"
            read -p " > " USER
            printf "${GREEN} Enter administrator ${YELLOW}PASSWORD${GREEN} for your database server:${CN}\n"
            read -s -p " > " PASSWORD
            printf "${GREEN}\n Enter ${YELLOW}IP ADDRESS${GREEN} of your database server [127.0.0.1]:${CN}\n"
            read -p " > " HOST_IP
            printf "${GREEN} Enter ${YELLOW}PORT NUMBER${GREEN} of your database server [3306]:${CN}\n"
            read -p " > " PORT
            printf "${GREEN} Enter ${YELLOW}NAME${GREEN} of new database:${CN}\n"
            read -p " > " DB_NAME
            mysqladmin --user=${USER} --host=${HOST_IP} --password=${PASSWORD} --port=${PORT} create ${DB_NAME} &&
            printf "\n${GREEN} New database ${BLUE}${DB_NAME} ${GREEN}was created.${CN}\n"
            printf "\n${GREEN} Installing Drupal tables to ${BLUE}${DB_NAME} ${GREEN}database.${CN}\n\n"
            printf "${GREEN} Enter ${YELLOW}ADMINISTRATOR NAME${GREEN} for this project:${CN}\n"
            read -p " > " ADMIN_NAME
            printf "${GREEN} Enter ${YELLOW}ADMINISTRATOR PASSWORD${GREEN} for this project:${CN}\n"
            read -s -p " > " ADMIN_PASSWORD
            printf "\n${GREEN} Enter ${YELLOW}SITE NAME${GREEN} for this project:${CN}\n"
            read -p " > " SITE_NAME
            drush si --locale=cs --site-name=${SITE_NAME} --account-name=${ADMIN_NAME} --account-pass=${ADMIN_PASSWORD} --db-url=mysql://${USER}:${PASSWORD}@${HOST_IP}:${PORT}/${DB_NAME} &&
            break ;;
        [Nn]* ) break ;;
        * ) printf "${RED}\n Please enter y|Y or n|N.${CN}\n\n" ;;
    esac
    sleep 2
done
sleep 2
printf "\n${BLUE} Enable ${CYAN}ctools${BLUE} and ${CYAN}webprofiler${BLUE} modules:${CN}\n\n"
cd web/ &&
drush en ctools &&
drush en webprofiler --no-interaction &&
printf "\n${BLUE} Enable other important modules:${CN}\n\n"
drush en module_filter &&
sleep 2
drush en backup_migrate &&
sleep 2
drush en libraries &&
sleep 2
drush en coffee &&
sleep 2
drush en admin_toolbar &&
sleep 2
drush en admin_toolbar_tools &&
sleep 2
drush en adminimal_admin_toolbar &&
sleep 2
drush en webform &&
sleep 2
printf "\n${BLUE} Enable adminimal theme:${CN}\n\n"
drush then adminimal_theme &&
printf "\n${BLUE} Enable zurb_foundation theme:${CN}\n\n"
drush then zurb_foundation &&
printf "\n${GREEN} Set permissins for ${BLUE}settings.php${GREEN} file.${CN}\n"
chmod 664 sites/default/settings.php &&
printf "\n${GREEN} composer update${CN}\n"
chmod 755 sites/default/ &&
composer update &&
printf "\n${GREEN} Dump ${DB_NAME} database\n"
mysqldump -u ${USER} -p${PASSWORD} --port ${PORT} -h ${HOST_IP} ${DB_NAME} > ../../$(date +%e-%m-%Y-%H:%M:%S)_${DB_NAME}_backup.sql &&
cd ../
printf "\n${BLUE} 1. New Drupal 8 core installation\n"
printf " 2. Installatin of more modules\n"
printf " 3. Setup Drupal 8 database and backup it\n"
printf "${WHITE} 4. >> Create GIT repository with new branch${BLUE}\n\n"
printf "\n\n    creates a \"Devel\" branch and checkout into it${CN}\n"
printf "    ---------------------------------------------\n\n"
while true; do
    printf "${GREEN} Do you want initialize your new GIT repository?${CN} [y|n]:\n"
    read -p " > " yn
    case $yn in
        [Yy]* ) 
            git init &&
            git add -A &&
            git commit . -m 'Drupal8 project initialize commit' &&
            git branch Devel &&
            git checkout Devel &&
            break ;;
        [Nn]* ) break ;;
        * ) printf "${RED} Please enter y|Y or n|N.${CN}\n\n" ;;
    esac
    sleep 2
done
sleep 2
printf "\n${BLUE}================================================================\n"
printf "Installation of project >>${CN} $PROJECTNAME ${BLUE}<< CMS Drupal 8 is done.\n"
printf "================================================================\n"
printf " If you want install any other modules, go to directory${CN} $PROJECTNAME ${BLUE}with command:\n"
printf " cd ${CN}$PROJECTNAME\n"
printf "${BLUE} And run command:\n"
printf "${WHITE}composer require drupal/${YELLOW}[module name]${WHITE} --update-with-all-dependencies${CN}\n\n"
printf "${GREEN} List of${CN} $PROJECTNAME/ ${GREEN}directory:\n"
printf "${PURPLE}-------------------------------------${YELLOW}\n"
ls -lha &&
printf "${PURPLE}-------------------------------------${CN}\n"
printf "${BLUE}\n Script started in :${CN} ${START_TIME}\n"
printf "${BLUE} Script finished in:${CN} $(date +%H:%M:%S)\n\n"
printf "${YELLOW} -- End of Drupal 8 installation. Bye. --\n\n\n${CN}"
exit 0



