#!/usr/bin/env bash

##############################################################################
# Bash "Strict" Mode
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
##############################################################################
set -euo pipefail
IFS=$'\n\t'

##############################################################################
# Ensure gdate is available
##############################################################################
if ! command -v "gdate" &>/dev/null; then
    echo "gdate not installed. Please run 'brew install coreutils'"
    exit 1
fi

TOTAL_DAYS=50
MAX_INCIDENTS_PER_DAY=3
TODAY=$(gdate '+%Y-%m-%d')
for ((i=0; i<=TOTAL_DAYS; i++))
do
    DATE=$(gdate +%Y-%m-%d -d "$TODAY - $i day")
    NUM_INCIDENTS=$((RANDOM % (MAX_INCIDENTS_PER_DAY + 1)))
    echo "-- [${DATE}] incidents [${NUM_INCIDENTS}]"
    for ((j=1; j<=NUM_INCIDENTS; j++))
    do
        DATETIME=$(printf "${DATE} %02d:%02d:%02d" $((RANDOM % 24)) $((RANDOM % 60)) $((RANDOM % 60)))
        SEVERITY=$((RANDOM % 3 + 1))
        echo "insert into incidents(incident_datetime, severity) values('${DATETIME}', ${SEVERITY});"
    done
done
