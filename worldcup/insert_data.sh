#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
# PSQL="psql -X --username=freecodecamp --dbname=worldcup --no-align --tuples-only -c"

while IFS=, read -r YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
    if [[ $WINNER != winner ]]
    then
      # echo $YEAR $ROUND $WINNER $OPPONENT $WINNER_GOALS $OPPONENT_GOALS
      W_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
      O_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")

      if [[ -z $W_ID ]]
      then
        echo "$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")"
      fi

      if [[ -z $O_ID ]]
      then
        echo "$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")"
      fi
    fi


done < games.csv

while IFS=, read -r YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
    if [[ $WINNER != winner ]]
    then
      # echo $YEAR $ROUND $WINNER $OPPONENT $WINNER_GOALS $OPPONENT_GOALS
      W_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
      O_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")

      echo "$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($YEAR, '$ROUND', '$W_ID', '$O_ID', $WINNER_GOALS, $OPPONENT_GOALS)")"
      
    fi


done < games.csv

