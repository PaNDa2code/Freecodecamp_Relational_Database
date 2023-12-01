#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
    echo "Please provide an element as an argument."
else
    if [[ $1 =~ ^[0-9]+$ ]]
    then
      # atomic_number
      FIND_E=$($PSQL "SELECT * FROM elements WHERE atomic_number = $1;")
    else
      if [[ $1 =~ ^[A-Za-z]$ ]]
      then
        # symbol
        FIND_E=$($PSQL "SELECT * FROM elements WHERE symbol = '$1';")
      else
        # name
        FIND_E=$($PSQL "SELECT * FROM elements WHERE name = '$1';")
      fi
    fi
    IFS='|' read -r ATOMIC_NUMBER SYMBOL NAME <<< "$FIND_E"
    if [[ ! -z $ATOMIC_NUMBER ]]
    then
        FIND_D=$($PSQL "SELECT type_id, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER;");
        IFS='|' read -r TYPE_ID ATOMIC_MASS MELTING_POINT BOILING_POINT <<< "$FIND_D"

        TYPE=$($PSQL "SELECT type FROM types WHERE type_id = $TYPE_ID")

        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    else
        echo "I could not find that element in the database."
    fi
fi
