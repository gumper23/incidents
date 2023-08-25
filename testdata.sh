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
RANDOM=$(gdate +"%T.%N")
MAX_INCIDENTS_PER_DAY=3

DATE=$(gdate '+%Y-%m-%d')
for ((i=0; i<=TOTAL_DAYS; i++))
do
    NEXT_DATE=$(gdate +%Y-%m-%d -d "$DATE - $i day")
    NUM_INCIDENTS=$(shuf -i 0-${MAX_INCIDENTS_PER_DAY} -n1)
    echo "-- [${NEXT_DATE}] incidents [${NUM_INCIDENTS}]"
    for ((j=1; j<=NUM_INCIDENTS; j++))
    do
        RANDOM_HOUR=$(printf "%02d" "$(shuf -i 0-23 -n1)")
        RANDOM_MINUTE=$(printf "%02d" "$(shuf -i 0-59 -n1)")
        RANDOM_SECOND=$(printf "%02d" "$(shuf -i 0-59 -n1)")
        SEVERITY=$(shuf -i 1-3 -n1)
        echo "insert into incidents(incident_datetime, severity) values('${NEXT_DATE} ${RANDOM_HOUR}:${RANDOM_MINUTE}:${RANDOM_SECOND}', ${SEVERITY});"
    done
done
