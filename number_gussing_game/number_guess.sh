#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guessing_game -t --no-align -c"

echo "Enter your username:";

read USER_NAME

USER_DATA=$($PSQL "SELECT * FROM users WHERE user_name = '$USER_NAME'")

RAND=$(($(($RANDOM % 1001))+1))

TRIES=0

if [[ -z $USER_DATA ]]
then
    INSERT_RESULT=$($PSQL "INSERT INTO users(user_name) VALUES('$USER_NAME')")
    USER_ID=$($PSQL "SELECT user_id FROM users WHERE user_name = '$USER_NAME'")

    echo "Welcome, $USER_NAME! It looks like this is your first time here."
    NEW_USER=1
else    
    IFS='|' read USER_ID USER_NAME BEST_GAME_GUESSES GAMES_NUMBER <<< "$USER_DATA"

    echo -e "\nWelcome back, $USER_NAME! You have played $GAMES_NUMBER games, and your best game took $BEST_GAME_GUESSES guesses."
fi

echo "Guess the secret number between 1 and 1000:"
echo $RAND
while [ true ]; do
    read USER_INPUT
    TRIES=$(($TRIES+1))
    
    if [[ $USER_INPUT =~ ^[0-9]+$ ]]; then
        if [[ $USER_INPUT -lt $RAND ]]; then
            echo "It's higher than that, guess again:"
        elif [[ $USER_INPUT -gt $RAND ]]; then
            echo "It's lower than that, guess again:"
        elif [[ $USER_INPUT -eq $RAND ]]; then
            break
        fi
    else
        echo "That is not an integer, guess again:"
    fi
done



if [[ $NEW_USER -eq 1 ]]
then
    GAMES_NUMBER=1
    BEST_GAME_GUESSES=$TRIES
else
    if [[ $TRIES -lt $BEST_GAME_GUESSES ]]
    then
        BEST_GAME_GUESSES=$TRIES
    fi
    GAMES_NUMBER=$(($GAMES_NUMBER+1))
fi
UPDATE_RESULT=$($PSQL "UPDATE users SET games_number = $GAMES_NUMBER, best_game_guesses = $BEST_GAME_GUESSES WHERE user_id = $USER_ID")

if [[ $UPDATE_RESULT == "UPDATE 1" ]]
then
    echo "You guessed it in $TRIES tries. The secret number was $RAND. Nice job!"
else
    echo "Error while update data."
fi
