#!/usr/bin/env bash

##############################################################################
# Bash "Strict" Mode
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
##############################################################################
set -euo pipefail
IFS=$'\n\t'

##############################################################################
# USAGE: ./testdata.sh | (mysql|psql -q) test
##############################################################################
echo "-- USAGE: "
echo "-- ./testdata.sh | mysql test"
echo "-- OR "
echo "-- ./testdata.sh | psql -q test"

##############################################################################
# Ensure gdate is available
##############################################################################
if ! command -v "gdate" &>/dev/null; then
    echo "gdate not installed. Please run 'brew install coreutils'"
    exit 1
fi

##############################################################################
# Create the table
##############################################################################
set +e # -- READ returns 1 due to no EOF in heredocs
IFS='' read -rd '' INCIDENTS <<-'EOF'
create table if not exists incidents (
    id serial not null primary key
    , incident_ts timestamp not null
    , severity smallint not null check(severity > 0 and severity <= 5)
);
EOF
set -e
echo "${INCIDENTS}"

##############################################################################
# Generate the inserts
##############################################################################
TOTAL_DAYS=50
MAX_INCIDENTS_PER_DAY=3
TODAY=$(gdate '+%Y-%m-%d')
INSERTS=0
for ((i=0; i<=TOTAL_DAYS; i++))
do
    DATE=$(gdate +%Y-%m-%d -d "$TODAY - $i day")
    NUM_INCIDENTS=$((RANDOM % (MAX_INCIDENTS_PER_DAY + 1)))
    echo "-- [${DATE}] incidents [${NUM_INCIDENTS}]"
    for ((j=1; j<=NUM_INCIDENTS; j++))
    do
        DATETIME=$(printf "${DATE} %02d:%02d:%02d" $((RANDOM % 24)) $((RANDOM % 60)) $((RANDOM % 60)))
        SEVERITY=$((RANDOM % 3 + 1))
        echo "insert into incidents(incident_ts, severity) values('${DATETIME}', ${SEVERITY});"
        ((INSERTS++))
    done
done
echo "-- Total inserts: [${INSERTS}]"
