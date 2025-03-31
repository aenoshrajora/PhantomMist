SHELL := /bin/bash # Use bash syntax

.SILENT:



CRYSTAL_VERSION := $(shell crystal --version 2>/dev/null)
SHARDS_VERSION  := $(shell shards  --version 2>/dev/null)

CRYSTAL_PROJECT_LIBS := ./lib


$(CRYSTAL_PROJECT_LIBS): | shard.yml
	echo -e "\033[0;33mFetching dependancy shards...\033[0m"
	shards install
	echo -e "\033[0;32mShards Installed\033[0m"


all: phantommist pmdb 
	echo -e "\033[0;32mAll Projects Built!:)\033[0m"


phantommist: $(shell find ./src -name '*.cr') | $(CRYSTAL_PROJECT_LIBS)
	echo -e "\033[0;33mBuilding phantommist...\033[0m"
	if [ -f ./phantommist ]; then rm ./phantommist; fi 
	crystal build -p src/phantommist.cr 
	echo -e "\033[0;32mDone!\033[0m"

pmdb: $(shell find ./src -name '*.cr') | $(CRYSTAL_PROJECT_LIBS)
	echo -e "\033[0;33mBuilding pmdb...\033[0m"
	if [ -f ./pmdb ]; then rm ./pmdb; fi 
	crystal build -p src/pmdb.cr
	echo -e "\033[0;32mDone!\033[0m"

debug: 
	crystal build -p src/phantommist.cr --debug
	crystal build -p src/pmdb.cr --debug 



install: all 
	echo "Installing Tools"
	help2man ./phantommist  > phantommist.1
	gzip phantommist.1
	mv ./phantommist /usr/bin/phantommist
	mv ./pmdb /usr/bin/pmdb
	echo "Installing man files"
	mv ./phantommist.1.gz /usr/share/man/man1/
	echo "Tools Installed"
	echo "If you use the fish shell( the best shell ;) ) you should run fish_update_completions to add phantommist autocomplete now"


uninstall: 
	echo "Uninstalling tools..."
	rm /usr/bin/phantommist
	rm /usr/bin/pmdb 
	rm /usr/share/man/man1/phantommist.1.gz
	echo "phantommist and pmdb uninstalled!"


clean: 
	rm -rf lib/
	if [ -f pmdb ]; then rm pmdb; fi 
	if [ -f pmdb2 ]; then rm pmdb2; fi 
	if [ -f spray.db ]; then rm spray.db; fi 
	if [ -f phantommist ]; then rm phantommist; fi 
	if [ -f phantommist.1 ]; then rm phantommist.1; fi 
	if [ -f phantommist.1.gz ]; then rm phantommist.1.gz; fi 
	if [ -f shard.lock ]; then rm shard.lock; fi 
	if [ -f exported_pmdb_passwords.csv ]; then rm exported_pmdb_passwords.csv; fi
	if [ -f exported_pmdb_usernames.csv ]; then rm exported_pmdb_usernames.csv; fi
	if [ -f exported_pmdb_valid.csv ]; then rm exported_pmdb_valid.csv; fi
	if [ -f exported_pmdb_sprayed.csv ]; then rm exported_pmdb_sprayed.csv; fi
