#!/bin/bash

DB=$1

if [[ $DB == "" ]];
then
    DB="id178kua"
elif [[ $DB == "s" ]]
then
    DB="did2014small"
else
    DB="did2014"
fi

psql -h dbserver.scienze.univr.it -U id178kua $DB
