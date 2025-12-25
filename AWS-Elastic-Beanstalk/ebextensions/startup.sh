# define colors
GREEN='\033[0;32m'
NC='\033[0m'

# Print current date and time for reference
printf "${RED}Current date and time:$(date)${NC}\n"

# restart nginx
printf "${GREEN}Restarting nginx...${NC}\n"
service nginx restart

# install supervisor
printf "${GREEN}Installing supervisor...${NC}\n"

# change directory
cd /var/app/current/

# clear config cache and run migrations
printf "${GREEN}Clearing config cache...${NC}\n"
php artisan config:cache

printf "${GREEN}Running migrations...${NC}\n"
php artisan base:migrate --force --seed
php artisan tenant:migrate --force --seed

# Restart queue
printf "${GREEN}Restarting queue...${NC}\n"
php artisan queue:restart

# update supervisor
printf "${GREEN}Updating supervisor...${NC}\n"
supervisorctl update

# register worker
printf "${GREEN}Registering worker...${NC}\n"
supervisorctl start worker-sokrio-staging

# restart supervisor - ironically start/stop work better than simple restart
printf "${GREEN}Restarting supervisor...${NC}\n"
service supervisor stop
service supervisor start

printf "${GREEN}Deployment complete!${NC}\n"
